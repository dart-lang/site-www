// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/pages/changelog/changelog_index.dart';

/// The Markdown secondary output shared by routing and page layouts.
final canonicalMarkdownOutput = CanonicalMarkdownOutput(
  createHeader: _createHeader,
);

/// Outputs a secondary Markdown file at the canonical page URL with a `.md`
/// suffix.
final class CanonicalMarkdownOutput extends MarkdownOutput {
  static final _changelogTagPattern = RegExp(
    r'<ChangelogIndex\s*(?:/>|>\s*</ChangelogIndex>)',
    caseSensitive: false,
  );

  CanonicalMarkdownOutput({super.createHeader});

  /// Returns the secondary Markdown route for [page], if one is generated.
  String? routeForPage(Page page) {
    if (pattern.matchAsPrefix(page.path) == null) return null;
    // `MemoryPage.builder` pages render Jaspr components directly and don't
    // have Markdown source content for `MarkdownOutput` to emit.
    if (page.loader is MemoryLoader && page.content.isEmpty) return null;
    return createRoute(page.url);
  }

  @override
  String createRoute(String route) {
    // Keep Markdown URLs absolute and avoid a `/.md` suffix.
    final absoluteRoute = route.startsWith('/') ? route : '/$route';
    final normalizedRoute = absoluteRoute.endsWith('/')
        ? absoluteRoute.substring(0, absoluteRoute.length - 1)
        : absoluteRoute;
    return normalizedRoute.isEmpty ? '/index.md' : '$normalizedRoute.md';
  }

  /// Renders the Markdown output string when [page] contains a
  /// `<ChangelogIndex />` tag, or returns `null` when default rendering
  /// applies.
  String? renderChangelogMarkdown(Page page) {
    if (!_changelogTagPattern.hasMatch(page.content)) {
      return null;
    }

    final pageContent = StringBuffer();
    if (createHeader case final createHeader?) {
      final headerForPage = createHeader(page);
      pageContent.writeln(headerForPage);
    }

    final changesData = page.data['changelog'] as List<Object?>?;
    final renderedChangelog = changesData != null
        ? ChangelogIndex.renderMarkdown(changesData)
        : '';
    pageContent.writeln(
      page.content.replaceFirst(_changelogTagPattern, renderedChangelog),
    );
    return pageContent.toString();
  }

  @override
  Component build(Page page) {
    final changelogMarkdown = renderChangelogMarkdown(page);
    if (changelogMarkdown == null) {
      return super.build(page);
    }

    return Builder(
      builder: (context) {
        context.setHeader('Content-Type', 'text/markdown; charset=utf-8');
        context.setStatusCode(200, responseBody: changelogMarkdown);
        return const Component.empty();
      },
    );
  }
}

String _createHeader(Page page) {
  final header = StringBuffer();
  if (page.data.page['title'] case final String title when title.isNotEmpty) {
    header.writeln('# $title');

    if (page.data.page['description'] case final String description
        when description.isNotEmpty) {
      header.writeln();
      header.writeln('> $description');
    }
  }

  return header.toString();
}
