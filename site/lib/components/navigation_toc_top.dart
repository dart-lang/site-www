import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

// TODO(parlough): Migrate this TOC to the style used by Flutter docs.
class NavigationTocTop extends StatelessComponent {
  const NavigationTocTop({
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

    final isCollapsible = toc.entries.length > 10;

    yield div(
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

  Iterable<Component> _buildTocEntries(
    List<TocEntry> entries,
    int currentDepth,
  ) sync* {
    final nextDepth = currentDepth + 1;
    final maxDepth = this.maxDepth;
    for (final entry in entries) {
      yield li(classes: 'toc-entry', [
        a(
          href: '#${entry.id}',
          [text(entry.text)],
        ),
        // If this entry has children and the TOC hasn't reached the max depth,
        // recursively create a nested list.
        if ((maxDepth == null || nextDepth <= maxDepth) &&
            entry.children.isNotEmpty)
          ul([
            ..._buildTocEntries(entry.children, nextDepth),
          ]),
      ]);
    }
  }
}
