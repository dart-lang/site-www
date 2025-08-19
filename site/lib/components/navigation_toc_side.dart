import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../util.dart';

class NavigationTocSide extends StatelessComponent {
  const NavigationTocSide({
    super.key,
    required this.toc,
    this.maxDepth,
  });

  final TableOfContents toc;
  final int? maxDepth;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    // Only render if there is more than 1 entry.
    if (toc.entries.length <= 1) {
      return;
    }

    yield div(id: 'site-toc--side', classes: 'site-toc', [
      nav(classes: 'site-sidenav', [
        header(classes: 'site-toc__title', [text('Contents')]),
        ul(classes: 'section-nav', [
          ..._buildTocEntries(toc.entries, 1),
        ]),
      ]),
    ]);
  }

  Iterable<Component> _buildTocEntries(
    List<TocEntry> entries,
    int currentDepth,
  ) sync* {
    final nextDepth = currentDepth + 1;
    final maxDepth = this.maxDepth;
    for (final entry in entries) {
      yield li(classes: 'nav-item toc-entry', [
        a(
          href: '#${entry.id}',
          classes: 'nav-link',
          [...underscoreBreaker(entry.text)],
        ),
        // If this entry has children and the TOC hasn't reached the max depth,
        // recursively create a nested list.
        if ((maxDepth == null || nextDepth <= maxDepth) &&
            entry.children.isNotEmpty)
          ul(classes: 'nav', [
            ..._buildTocEntries(entry.children, nextDepth),
          ]),
      ]);
    }
  }
}
