// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

// TODO(https://github.com/dart-lang/site-www/issues/6838):
//  Migrate this TOC to the style used by Flutter docs.
class NavigationTocTop extends StatelessComponent {
  const NavigationTocTop({
    super.key,
    required this.toc,
    this.maxDepth,
  });

  final TableOfContents toc;
  final int? maxDepth;

  @override
  Component build(BuildContext context) {
    // Only render if there is more than 1 entry.
    if (toc.entries.length <= 1) {
      return const Component.empty();
    }

    final isCollapsible = toc.entries.length > 10;

    return div(
      id: 'site-toc--inline',
      classes: isCollapsible
          ? 'site-toc toc-collapsible toc-collapsed'
          : 'site-toc',
      [
        header(classes: 'site-toc__title', [
          text('Contents'),
          if (isCollapsible) ...[
            span(classes: 'site-toc--inline__toggle toc-toggle-down', [
              i(classes: 'material-symbols', [text('expand_more')]),
            ]),
            span(classes: 'site-toc--inline__toggle toc-toggle-up', [
              i(classes: 'material-symbols', [text('expand_less')]),
            ]),
          ],
        ]),
        ul(classes: 'section-nav', [
          ..._buildTocEntries(toc.entries, 1),
        ]),
        if (isCollapsible)
          span(classes: 'site-toc--inline__toggle toc-toggle-more-items', [
            i(classes: 'material-symbols', [text('more_horiz')]),
          ]),
      ],
    );
  }

  List<Component> _buildTocEntries(
    List<TocEntry> entries,
    int currentDepth,
  ) {
    final nextDepth = currentDepth + 1;
    final maxDepth = this.maxDepth;
    return [
      for (final entry in entries)
        li(classes: 'toc-entry', [
          a(
            href: '#${entry.id}',
            [text(entry.text)],
          ),
          // If this entry has children and the TOC hasn't reached max depth,
          // recursively create a nested list.
          if ((maxDepth == null || nextDepth <= maxDepth) &&
              entry.children.isNotEmpty)
            ul([
              ..._buildTocEntries(entry.children, nextDepth),
            ]),
        ]),
    ];
  }
}
