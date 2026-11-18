// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:dart_dev_site/main.server.options.dart';
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart';
import 'package:dart_dev_site/src/extensions/code_block_processor.dart';
import 'package:dart_dev_site/src/layouts/blog_layout.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart' hide BlogLayout;
import 'package:jaspr_test/server_test.dart';

void main() {
  setUpAll(() {
    if (!Jaspr.isInitialized) {
      Jaspr.initializeApp(options: defaultServerOptions);
    }
  });

  testServer('BlogLayout includes shared fonts and Roboto Serif', (
    tester,
  ) async {
    tester.pumpComponent(
      Document(
        head: const BlogLayout()
            .buildHead(_page('/blog/hello', pageData: {'title': 'Hello Dart'}))
            .toList(),
        body: const Component.empty(),
      ),
    );

    final response = await tester.request('/');
    expect(response.statusCode, 200);

    final headHtml = response.document!.head!.innerHtml;
    expect(headHtml, contains('Google+Sans+Flex'));
    expect(headHtml, contains('Roboto+Serif'));
  });

  testServer('DartPadWrapper renders placeholder pre with pixel height', (
    tester,
  ) async {
    tester.pumpComponent(
      Document(
        body: DartPadWrapper(
          content: 'void main() {}',
          title: 'Example',
          height: 520,
        ),
      ),
    );

    final response = await tester.request('/');
    expect(response.statusCode, 200);

    final placeholder = response.document!.body!.querySelector(
      'pre.embedded-dartpad',
    );
    expect(placeholder, isNotNull);
    expect(placeholder!.attributes['style'], contains('height: 520px'));
  });

  group('CodeBlockProcessor DartPad height', () {
    Future<DartPadWrapper> processDartPad(String metadata) async {
      final nodes = await const CodeBlockProcessor().apply(_page('/test'), [
        ElementNode('pre', {}, [
          ElementNode(
            'code',
            {'class': 'language-dartpad', 'data-meta': metadata},
            [const TextNode('void main() {}')],
          ),
        ]),
      ]);
      return (nodes.single as ComponentNode).component as DartPadWrapper;
    }

    test('defaults to 400 pixels if not specified', () async {
      expect((await processDartPad('title="Example"')).height, 400);
    });

    test('is parsed as a number of pixels', () async {
      expect((await processDartPad('height="520"')).height, 520);
    });

    test('rejects heights that are not positive whole pixels', () async {
      for (final height in [
        '',
        '0',
        '-100',
        '400.5',
        '520px',
        '32rem',
        '50%',
        '1e3',
        'NaN',
        'Infinity',
        '400px; display: none',
      ]) {
        await expectLater(
          processDartPad('height="$height"'),
          throwsArgumentError,
          reason: 'height: "$height"',
        );
      }
    });
  });
}

/// Creates a minimal [Page] at [url] with [pageData] as its `page` data.
Page _page(String url, {Map<String, Object?> pageData = const {}}) => Page(
  path: '${url.substring(1)}.md',
  url: url,
  content: '',
  initialData: {
    'page': pageData,
    'site': const {'url': 'https://dart.dev', 'title': 'Dart'},
  },
  config: const PageConfig(),
  loader: MemoryLoader(pages: []),
);
