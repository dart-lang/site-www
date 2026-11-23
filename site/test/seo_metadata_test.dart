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
import 'package:html/dom.dart' as html;
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_test/server_test.dart';

final MemoryLoader _loader = MemoryLoader(pages: const []);

void main() {
  setUpAll(() {
    if (!Jaspr.isInitialized) {
      Jaspr.initializeApp(options: defaultServerOptions);
    }
  });

  group('DashLayout.buildHead SEO tags', () {
    testServer('emits self-referencing canonical by default', (tester) async {
      final head = await _renderHead(
        tester,
        _page(
          path: 'overview.md',
          url: '/overview',
          pageData: {'title': 'Dart overview'},
        ),
      );

      expect(_canonicalHref(head), 'https://dart.dev/overview');
      expect(_ogUrl(head), 'https://dart.dev/overview');
      expect(head.querySelector('meta[name="robots"]'), isNull);
    });

    testServer('suppresses default canonical when noindex is set', (
      tester,
    ) async {
      for (final noIndexValue in <Object>[true, 'true']) {
        final head = await _renderHead(
          tester,
          _page(
            path: 'search.html',
            url: '/search',
            pageData: {
              'title': 'Search dart.dev',
              'noindex': noIndexValue,
            },
          ),
        );

        expect(
          head.querySelector('meta[name="robots"]')?.attributes['content'],
          'noindex',
        );
        expect(_canonicalHref(head), isNull);
        expect(_ogUrl(head), 'https://dart.dev/search');
      }
    });

    testServer('honors explicit canonical override and false suppression', (
      tester,
    ) async {
      final overrideHead = await _renderHead(
        tester,
        _page(
          path: 'tools/linter-rules/prefer_iterable_whereType.html',
          url: '/tools/linter-rules/prefer_iterable_whereType',
          pageData: {
            'title': 'prefer_iterable_whereType',
            'titleBase': 'Dart linter',
            'canonical': '/tools/linter-rules/prefer_iterable_wheretype',
          },
        ),
      );
      expect(
        _canonicalHref(overrideHead),
        'https://dart.dev/tools/linter-rules/prefer_iterable_wheretype',
      );
      expect(
        overrideHead.querySelector('title')?.text,
        'prefer_iterable_whereType | Dart linter',
      );

      final suppressedHead = await _renderHead(
        tester,
        _page(
          path: 'custom.md',
          url: '/custom',
          pageData: {
            'title': 'Custom',
            'canonical': false,
          },
        ),
      );
      expect(_canonicalHref(suppressedHead), isNull);
    });

    testServer('emits alternate JSON link when alternateJson is configured', (
      tester,
    ) async {
      final withJsonHead = await _renderHead(
        tester,
        _page(
          path: 'changelog.md',
          url: '/changelog',
          pageData: {
            'title': 'Dart changelog',
            'alternateJson': '/changelog/index.json',
          },
        ),
      );
      final jsonLink = withJsonHead.querySelector(
        'link[rel="alternate"][type="application/json"]',
      );
      expect(jsonLink?.attributes['href'], '/changelog/index.json');
      expect(jsonLink?.attributes['title'], 'JSON');

      final withoutJsonHead = await _renderHead(
        tester,
        _page(
          path: 'overview.md',
          url: '/overview',
          pageData: {'title': 'Dart overview'},
        ),
      );
      expect(
        withoutJsonHead.querySelector(
          'link[rel="alternate"][type="application/json"]',
        ),
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
        expect(data['sitemap'], isNot(false));
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
                  p.path.endsWith('.html'),
            )
            .toList();
        expect(lintPages, isNotEmpty);

        var sawMixedCaseRule = false;
        var sawRemoved = false;

        for (final page in lintPages) {
          final data = _pageMap(page);
          expect(data['titleBase'], 'Dart linter');

          final ruleName = (data['title'] as String).trim();
          final slug = ruleName.toLowerCase();
          expect(page.path, 'tools/linter-rules/$slug.html');
          if (slug != ruleName) {
            sawMixedCaseRule = true;
            expect(
              redirects,
              contains(
                equals({
                  'source': '/tools/linter-rules/$ruleName',
                  'destination': '/tools/linter-rules/$slug',
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
            expect(data['sitemap'], isNot(false));
          }
        }

        expect(sawMixedCaseRule, isTrue);
        expect(sawRemoved, isTrue);
      },
    );
  });

  group('Static index card links and copy buttons', () {
    testServer(
      'DiagnosticIndex links documented headers and copies diagnostic names',
      (
        tester,
      ) async {
        final page = _page(
          path: 'tools/diagnostics/index.md',
          url: '/tools/diagnostics',
          pageData: {'title': 'Diagnostics'},
          data: {
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
        );

        tester.pumpComponent(
          Page.wrap(page, [page], const Document(body: DiagnosticIndex())),
        );

        final response = await tester.request('/tools/diagnostics');

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

/// Returns the `page` data that the memory [page] was created with.
Map<String, Object?> _pageMap(MemoryPage page) =>
    page.initialData['page'] as Map<String, Object?>;

/// Creates a [Page] at [path] and [url] with [pageData] as its `page` data.
///
/// Any top-level [data], such as data files a component reads,
/// is included alongside a minimal `site` configuration.
Page _page({
  required String path,
  required String url,
  required Map<String, Object?> pageData,
  Map<String, Object?> data = const {},
}) {
  return Page(
    path: path,
    url: url,
    content: '',
    initialData: {
      ...data,
      'page': pageData,
      'site': const {'url': 'https://dart.dev', 'title': 'Dart'},
    },
    config: const PageConfig(),
    loader: _loader,
  );
}

/// Renders the `<head>` that [DocLayout] builds for [page]
/// with [tester] and returns the parsed element.
Future<html.Element> _renderHead(ServerTester tester, Page page) async {
  tester.pumpComponent(
    Document(
      head: const DocLayout().buildHead(page).toList(),
      body: const Component.empty(),
    ),
  );
  return (await tester.request('/')).document!.head!;
}

/// Returns the URL of the canonical link in [head],
/// or `null` if it doesn't have one.
String? _canonicalHref(html.Element head) =>
    head.querySelector('link[rel="canonical"]')?.attributes['href'];

/// Returns the URL of the `og:url` meta tag in [head],
/// or `null` if it doesn't have one.
String? _ogUrl(html.Element head) =>
    head.querySelector('meta[property="og:url"]')?.attributes['content'];
