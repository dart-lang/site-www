// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../util.dart';

/// The wide layout, side version of the table of contents.
class NavigationTocSide extends StatelessComponent {
  const NavigationTocSide({
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

    return div(id: 'site-toc--side', classes: 'site-toc', [
      nav(classes: 'site-sidenav', [
        header(classes: 'site-toc__title', [text('Contents')]),
        ul(classes: 'section-nav', [
          ..._buildTocEntries(toc.entries, 1),
        ]),
      ]),
    ]);
  }

  List<Component> _buildTocEntries(
    List<TocEntry> entries,
    int currentDepth,
  ) {
    final nextDepth = currentDepth + 1;
    final maxDepth = this.maxDepth;
    return [
      for (final entry in entries)
        li(classes: 'nav-item toc-entry', [
          a(
            href: '#${entry.id}',
            classes: 'nav-link',
            [...splitByUnderscore(entry.text)],
          ),
          // If this entry has children and the TOC hasn't reached max depth,
          // recursively create a nested list.
          if ((maxDepth == null || nextDepth <= maxDepth) &&
              entry.children.isNotEmpty)
            ul(classes: 'nav', [
              ..._buildTocEntries(entry.children, nextDepth),
            ]),
        ]),
    ];
  }
}
