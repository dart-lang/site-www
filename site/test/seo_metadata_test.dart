// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:dart_dev_site/main.server.options.dart';
import 'package:dart_dev_site/src/layouts/doc_layout.dart';
import 'package:dart_dev_site/src/models/lints.dart';
import 'package:dart_dev_site/src/pages/custom_pages.dart';
import 'package:dart_dev_site/src/pages/diagnostic_index.dart';
import 'package:dart_dev_site/src/pages/lint_index.dart';
import 'package:dart_dev_site/src/util.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_test/server_test.dart';

final MemoryLoader _loader = MemoryLoader(pages: const []);
final RegExp _isoDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

void main() {
  setUpAll(() {
    if (!Jaspr.isInitialized) {
      Jaspr.initializeApp(options: defaultServerOptions);
    }
  });

  group('DashLayout.buildHead SEO tags', () {
    testServer('emits self-referencing canonical by default', (tester) async {
      final page = _page(
        path: 'overview.md',
        url: '/overview',
        pageData: {'title': 'Dart overview'},
      );
      tester.pumpComponent(
        Document(
          head: const DocLayout().buildHead(page).toList(),
          body: const Component.empty(),
        ),
      );

      final response = await tester.request('/overview');
      final head = response.document!.head!;

      expect(
        head.querySelector('link[rel="canonical"]')?.attributes['href'],
        'https://dart.dev/overview',
      );
      expect(
        head.querySelector('meta[property="og:url"]')?.attributes['content'],
        'https://dart.dev/overview',
      );
      expect(head.querySelector('meta[name="robots"]'), isNull);
    });

    testServer('suppresses default canonical when noindex is set', (
      tester,
    ) async {
      for (final noIndexValue in <Object>[true, 'true']) {
        final page = _page(
          path: 'search.html',
          url: '/search',
          pageData: {
            'title': 'Search dart.dev',
            'noindex': noIndexValue,
          },
        );
        tester.pumpComponent(
          Document(
            head: const DocLayout().buildHead(page).toList(),
            body: const Component.empty(),
          ),
        );

        final response = await tester.request('/search');
        final head = response.document!.head!;

        expect(
          head.querySelector('meta[name="robots"]')?.attributes['content'],
          'noindex',
        );
        expect(head.querySelector('link[rel="canonical"]'), isNull);
        expect(
          head.querySelector('meta[property="og:url"]')?.attributes['content'],
          'https://dart.dev/search',
        );
      }
    });

    testServer('honors explicit canonical override and false suppression', (
      tester,
    ) async {
      final overridePage = _page(
        path: 'tools/linter-rules/prefer_iterable_whereType.html',
        url: '/tools/linter-rules/prefer_iterable_whereType',
        pageData: {
          'title': 'prefer_iterable_whereType',
          'titleBase': 'Dart linter',
          'canonical': '/tools/linter-rules/prefer_iterable_wheretype',
        },
      );
      tester.pumpComponent(
        Document(
          head: const DocLayout().buildHead(overridePage).toList(),
          body: const Component.empty(),
        ),
      );

      final overrideDoc = (await tester.request('/')).document!;
      expect(
        overrideDoc.head!
            .querySelector('link[rel="canonical"]')
            ?.attributes['href'],
        'https://dart.dev/tools/linter-rules/prefer_iterable_wheretype',
      );
      expect(
        overrideDoc.head!.querySelector('title')?.text,
        'prefer_iterable_whereType | Dart linter',
      );

      final suppressedPage = _page(
        path: 'custom.md',
        url: '/custom',
        pageData: {
          'title': 'Custom',
          'canonical': false,
        },
      );
      tester.pumpComponent(
        Document(
          head: const DocLayout().buildHead(suppressedPage).toList(),
          body: const Component.empty(),
        ),
      );

      final suppressedDoc = (await tester.request('/custom')).document!;
      expect(
        suppressedDoc.head!.querySelector('link[rel="canonical"]'),
        isNull,
      );
    });
  });

  group('Diagnostic and linter MemoryPage SEO invariants', () {
    late List<MemoryPage> memoryPages;
    late List<Object?> redirects;

    setUpAll(() {
      final originalDir = Directory.current;
      if (!Directory(siteSrcDirectoryPath).existsSync() &&
          Directory('site').existsSync()) {
        Directory.current = 'site';
      }
      try {
        memoryPages = allMemoryPages;
        final firebase = jsonDecode(
          File('../firebase.json').readAsStringSync(),
        ) as Map<String, Object?>;
        final hosting = firebase['hosting'] as Map<String, Object?>;
        redirects = hosting['redirects'] as List<Object?>;
      } finally {
        Directory.current = originalDir;
      }
    });

    test('diagnostic pages distinguish titleBase and clean redirect stubs', () {
      final diagnosticPages = memoryPages
          .where((p) => p.path.startsWith('tools/diagnostics/'))
          .toList();
      expect(diagnosticPages, isNotEmpty);

      final primaryPages = diagnosticPages
          .where((p) => _pageMap(p)['redirectTo'] == null)
          .toList();
      final redirectStubs = diagnosticPages
          .where((p) => _pageMap(p)['redirectTo'] != null)
          .toList();

      expect(primaryPages, isNotEmpty);
      expect(redirectStubs, isNotEmpty);

      for (final page in primaryPages) {
        final data = _pageMap(page);
        expect(data['titleBase'], 'Dart diagnostic');
        final sitemap = data['sitemap'] as Map<String, Object?>;
        expect(sitemap['lastmod'], matches(_isoDatePattern));
      }

      for (final stub in redirectStubs) {
        final data = _pageMap(stub);
        expect(data['canonical'], startsWith('https://dart.dev/tools/'));
        expect(data['sitemap'], isFalse);
        expect(data.containsKey('noindex'), isFalse);
      }
    });

    test(
      'lint URLs are lowercase and removed rules stay out of the sitemap',
      () {
        final lintPages = memoryPages
            .where(
              (p) =>
                  p.path.startsWith('tools/linter-rules/') &&
                  p.path != 'tools/linter-rules/all.md' &&
                  p.path != 'tools/linter-rules/all.json',
            )
            .toList();
        expect(lintPages, isNotEmpty);

        var sawMixedCaseRule = false;
        var sawRemoved = false;

        for (final page in lintPages) {
          final data = _pageMap(page);
          expect(data['titleBase'], 'Dart linter');

          final ruleName = (data['title'] as String).trim();
          final slug = page.path
              .substring('tools/linter-rules/'.length)
              .replaceFirst(RegExp(r'\.html$'), '');
          expect(slug, ruleName.toLowerCase());
          if (slug != ruleName) {
            sawMixedCaseRule = true;
            final route = '/tools/linter-rules/$slug';
            expect(
              redirects,
              contains(
                equals({
                  'source': '/tools/linter-rules/$ruleName',
                  'destination': route,
                  'type': 301,
                }),
              ),
            );
          }
          final isRemoved = data['noindex'] == true;

          if (isRemoved) {
            sawRemoved = true;
            expect(data['sitemap'], isFalse);
            expect(data.containsKey('canonical'), isFalse);
          } else {
            final sitemap = data['sitemap'] as Map<String, Object?>;
            expect(sitemap['lastmod'], matches(_isoDatePattern));
          }
        }

        expect(sawMixedCaseRule, isTrue);
        expect(sawRemoved, isTrue);
      },
    );
  });

  group('Static index card links and copy buttons', () {
    testServer(
      'DiagnosticIndex links documented headers without client islands',
      (
        tester,
      ) async {
        final page = Page(
          path: 'tools/diagnostics/index.md',
          url: '/tools/diagnostics',
          content: '',
          initialData: {
            'page': {'title': 'Diagnostics'},
            'site': {'url': 'https://dart.dev', 'title': 'Dart'},
            'diagnostics': [
              {
                'id': 'ambiguous_import',
                'description': 'Ambiguous import.',
                'hasDocumentation': true,
                'fromLint': false,
                'previousNames': <String>[],
              },
              {
                'id': 'undocumented_code',
                'description': 'No docs yet.',
                'hasDocumentation': false,
                'fromLint': false,
                'previousNames': <String>[],
              },
            ],
          },
          config: const PageConfig(),
          loader: _loader,
        );

        tester.pumpComponent(
          Page.wrap(page, [page], const Document(body: DiagnosticIndex())),
        );

        final response = await tester.request('/tools/diagnostics');
        expect(response.body, isNot(contains('<!--@copy_button')));

        final doc = response.document!;
        final documentedLink = doc.querySelector('#ambiguous_import > a');
        expect(
          documentedLink?.attributes['href'],
          '/tools/diagnostics/ambiguous_import',
        );
        expect(doc.querySelector('#undocumented_code > a'), isNull);

        final copyButton = doc.querySelector(
          'button.copy-button[data-copy="ambiguous_import"]',
        );
        expect(copyButton, isNotNull);
        expect(copyButton!.attributes['type'], 'button');
        expect(copyButton.text, 'Copy name');
      },
    );

    testServer(
      'LintRuleIndex links to lowercase URLs and copies the original rule name',
      (
        tester,
      ) async {
        final page = _page(
          path: 'tools/linter-rules/index.md',
          url: '/tools/linter-rules',
          pageData: {'title': 'Linter rules'},
        );
        tester.pumpComponent(
          Page.wrap(
            page,
            [page],
            Document(
              body: LintRuleIndex([
                LintDetails(const {
                  'name': 'prefer_iterable_whereType',
                  'description': 'Prefer iterable.whereType<T>().',
                  'categories': <String>[],
                  'state': 'stable',
                  'incompatible': <String>[],
                  'sets': <String>['core'],
                  'fixStatus': 'hasFix',
                  'details': '',
                  'sinceDartSdk': '2.0',
                }),
              ]),
            ),
          ),
        );

        final response = await tester.request('/tools/linter-rules');
        expect(response.body, isNot(contains('<!--@copy_button')));

        final doc = response.document!;
        final headerLink = doc.querySelector(
          '#prefer_iterable_wheretype .card-title > a',
        );
        expect(
          headerLink?.attributes['href'],
          '/tools/linter-rules/prefer_iterable_wheretype',
        );
        expect(headerLink?.text, 'prefer_iterable_whereType');
        expect(
          doc.querySelector('.card-actions a')?.attributes['href'],
          '/tools/linter-rules/prefer_iterable_wheretype',
        );

        final copyButton = doc.querySelector('button.copy-button');
        expect(copyButton?.attributes['type'], 'button');
        expect(
          copyButton?.attributes['data-copy'],
          'prefer_iterable_whereType',
        );
        expect(copyButton?.text, 'Copy name');
      },
    );
  });
}

Map<String, Object?> _pageMap(MemoryPage page) =>
    page.initialData['page'] as Map<String, Object?>;

Page _page({
  required String path,
  required String url,
  required Map<String, Object?> pageData,
}) {
  return Page(
    path: path,
    url: url,
    content: '',
    initialData: {
      'page': pageData,
      'site': const {'url': 'https://dart.dev', 'title': 'Dart'},
    },
    config: const PageConfig(),
    loader: _loader,
  );
}
