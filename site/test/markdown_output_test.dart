// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:dart_dev_site/src/pages/markdown.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:test/test.dart';

final MemoryLoader _memoryLoader = MemoryLoader(pages: const []);
final FilesystemLoader _filesystemLoader = FilesystemLoader('src/content');

void main() {
  group('CanonicalMarkdownOutput', () {
    test('normalizes canonical Markdown routes', () {
      expect(canonicalMarkdownOutput.createRoute('/'), '/index.md');
      expect(canonicalMarkdownOutput.createRoute(''), '/index.md');
      expect(canonicalMarkdownOutput.createRoute('/language'), '/language.md');
      expect(canonicalMarkdownOutput.createRoute('/language/'), '/language.md');
      expect(
        canonicalMarkdownOutput.createRoute('tools/pub/workspaces'),
        '/tools/pub/workspaces.md',
      );
    });

    test('returns Markdown routes only for Markdown-backed pages', () {
      expect(
        canonicalMarkdownOutput.routeForPage(
          _page(
            path: 'language/index.md',
            url: '/language',
            content: 'Tour content.',
            loader: _filesystemLoader,
          ),
        ),
        '/language.md',
      );

      expect(
        canonicalMarkdownOutput.routeForPage(
          _page(
            path: 'index.html',
            url: '/',
            content: '<div>Home</div>',
            loader: _filesystemLoader,
          ),
        ),
        isNull,
      );

      expect(
        canonicalMarkdownOutput.routeForPage(
          _page(
            path: 'tools/linter-rules/all.md',
            url: '/tools/linter-rules/all',
            content: 'Generated Markdown list.',
            loader: _memoryLoader,
          ),
        ),
        '/tools/linter-rules/all.md',
      );

      // `MemoryPage.builder` pages have empty Markdown content.
      expect(
        canonicalMarkdownOutput.routeForPage(
          _page(
            path: 'tools/diagnostics/unused_import.md',
            url: '/tools/diagnostics/unused_import',
            content: '',
            loader: _memoryLoader,
          ),
        ),
        isNull,
      );
    });

    test('expands ChangelogIndex tags when rendering Markdown', () {
      final standardPage = _page(
        path: 'overview.md',
        url: '/overview',
        content: 'Plain Markdown body.',
        loader: _filesystemLoader,
      );
      expect(
        canonicalMarkdownOutput.renderChangelogMarkdown(standardPage),
        isNull,
      );

      final changelogPage = _page(
        path: 'changelog.md',
        url: '/changelog',
        content: 'Intro text.\n\n<ChangelogIndex />\n',
        loader: _filesystemLoader,
        pageData: const {
          'title': 'Changelog',
          'description': 'Recent changes in Dart.',
        },
        changelog: const [
          {
            'version': '3.14.0',
            'area': 'Tools',
            'description': 'Added `dart migrate`.',
          },
        ],
      );
      final rendered = canonicalMarkdownOutput.renderChangelogMarkdown(
        changelogPage,
      );

      expect(rendered, isNotNull);
      expect(rendered, contains('# Changelog'));
      expect(rendered, contains('> Recent changes in Dart.'));
      expect(rendered, contains('Added `dart migrate`.'));
      expect(rendered, isNot(contains('<ChangelogIndex')));
    });
  });
}

Page _page({
  required String path,
  required String url,
  required String content,
  required RouteLoader loader,
  Map<String, Object?> pageData = const {},
  List<Object?>? changelog,
}) {
  return Page(
    path: path,
    url: url,
    content: content,
    initialData: {'page': pageData, 'changelog': ?changelog},
    config: const PageConfig(),
    loader: loader,
  );
}
