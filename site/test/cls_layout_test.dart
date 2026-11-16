// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:dart_dev_site/main.server.options.dart';
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart';
import 'package:dart_dev_site/src/layouts/blog_layout.dart';
import 'package:dart_dev_site/src/layouts/doc_layout.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart' hide BlogLayout;
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  setUpAll(() {
    Jaspr.initializeApp(options: defaultServerOptions);
  });

  testServer(
    'DocLayout omits Roboto Serif, locks Material Symbols, '
    'and preconnects gstatic without crossorigin',
    (tester) async {
      tester.pumpComponent(
        _testContentApp([
          MemoryPage.builder(
            path: 'tools/pub/publishing.md',
            initialData: {
              'page': {'title': 'Publishing packages', 'layout': 'docs'},
              'site': {'url': 'https://dart.dev', 'title': 'Dart'},
            },
            builder: (_) => const div([.text('Body')]),
          ),
        ]),
      );

      final response = await tester.request('/tools/pub/publishing');
      expect(response.statusCode, 200);

      final doc = response.document!;
      final gstaticPreconnect = doc.head!.querySelector(
        'link[rel="preconnect"][href="https://www.gstatic.com"]',
      );
      expect(gstaticPreconnect, isNotNull);
      expect(gstaticPreconnect!.attributes.containsKey('crossorigin'), isFalse);

      final headHtml = doc.head!.innerHtml;
      expect(headHtml, isNot(contains('Roboto+Serif')));
      expect(
        headHtml,
        contains(
          'family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@'
          '24,400,0..1,0&amp;display=block',
        ),
      );
      expect(headHtml, contains('UA-26406144-4'));

      final headerLogo = doc.body!.querySelector('#site-primary-logo img')!;
      expect(headerLogo.attributes['width'], '192');
      expect(headerLogo.attributes['height'], '192');

      final footerLogo = doc.body!.querySelector('#page-footer .brand img')!;
      expect(footerLogo.attributes['width'], '164');
      expect(footerLogo.attributes['height'], '51');
    },
  );

  testServer(
    'BlogLayout splices Roboto Serif before Material Symbols and main.css',
    (tester) async {
      tester.pumpComponent(
        _testContentApp([
          MemoryPage.builder(
            path: 'blog/hello/index.md',
            initialData: {
              'page': {
                'title': 'Hello Dart',
                'layout': 'blog',
                'publishDate': '2026-04-01',
                'description': 'Summary',
                'author': 'author-a',
              },
              'authors': {
                'author-a': {'name': 'Author One'},
              },
              'site': {'url': 'https://dart.dev', 'title': 'Dart'},
            },
            builder: (_) => const div([.text('Post body')]),
          ),
        ]),
      );

      final response = await tester.request('/blog/hello');
      expect(response.statusCode, 200);

      final headHtml = response.document!.head!.innerHtml;
      final robotoIndex = headHtml.indexOf('Roboto+Serif');
      final symbolsIndex = headHtml.indexOf('Material+Symbols+Outlined');
      final mainCssIndex = headHtml.indexOf('/assets/css/main.css');

      expect(robotoIndex, greaterThanOrEqualTo(0));
      expect(robotoIndex, lessThan(symbolsIndex));
      expect(symbolsIndex, lessThan(mainCssIndex));
    },
  );

  testServer(
    'DartPadWrapper renders dartpad-placeholder pre with normalized height',
    (tester) async {
      tester.pumpComponent(
        Document(
          body: div([
            DartPadWrapper(
              content: 'void main() {}',
              title: 'Default height',
            ),
            DartPadWrapper(
              content: 'void main() {}',
              title: 'Numeric height',
              height: '520',
            ),
            DartPadWrapper(
              content: 'void main() {}',
              title: 'Unit height',
              height: '32rem',
            ),
          ]),
        ),
      );

      final response = await tester.request('/');
      expect(response.statusCode, 200);

      final placeholders = response.document!.body!.querySelectorAll(
        'pre.dartpad-placeholder',
      );
      expect(placeholders, hasLength(3));
      expect(placeholders[0].attributes['style'], contains('height: 400px'));
      expect(placeholders[1].attributes['style'], contains('height: 520px'));
      expect(placeholders[2].attributes['style'], contains('height: 32rem'));
    },
  );
}

ContentApp _testContentApp(List<MemoryPage> pages) => ContentApp.custom(
  eagerlyLoadAllPages: true,
  loaders: [MemoryLoader(pages: pages)],
  configResolver: PageConfig.all(
    layouts: const [DocLayout(), BlogLayout()],
    theme: const ContentTheme.none(),
  ),
);
