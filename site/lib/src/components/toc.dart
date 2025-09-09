import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'material_icon.dart';

final class SideTableOfContents extends StatelessComponent {
  const SideTableOfContents(
    this.toc, {
    this.maxDepth,
  });

  final TableOfContents toc;
  final int? maxDepth;

  @override
  Component build(BuildContext _) {
    return nav(id: 'toc-side', classes: 'site-toc', [
      header([
        const MaterialIcon('list'),
        span([text('On this page')]),
      ]),
      _TocContents(toc, maxDepth: maxDepth),
    ]);
  }
}

final class TopTableOfContents extends StatelessComponent {
  const TopTableOfContents(
    this.toc, {
    required this.currentTitle,
    this.maxDepth,
  });

  final TableOfContents toc;
  final String currentTitle;
  final int? maxDepth;

  @override
  Component build(BuildContext _) {
    return div(id: 'toc-top', classes: 'site-toc dropdown', [
      button(
        classes: 'dropdown-button',
        attributes: {
          'title': 'Toggle the table of contents dropdown',
          'aria-expanded': 'false',
          'aria-controls': 'toc-dropdown',
          'aria-label': 'Toggle the table of contents dropdown',
        },
        [
          span(classes: 'toc-intro', [
            const MaterialIcon('list'),
            span(
              attributes: {'aria-label': 'On this page'},
              [
                text('On this page'),
              ],
            ),
          ]),
          span(classes: 'toc-current', [
            const MaterialIcon('chevron_right'),
            span(id: 'current-header', [text(currentTitle)]),
          ]),
        ],
      ),
      div(id: 'toc-dropdown', classes: 'dropdown-content', [
        a(
          href: '#site-content-title',
          id: 'return-to-top',
          [
            const MaterialIcon('vertical_align_top'),
            span([text(currentTitle)]),
          ],
        ),
        div(
          classes: 'dropdown-divider',
          attributes: {'aria-hidden': 'true', 'role': 'separator'},
          [],
        ),
        nav(
          attributes: {'role': 'menu'},
          [_TocContents(toc, maxDepth: maxDepth)],
        ),
      ]),
    ]);
  }
}

final class _TocContents extends StatelessComponent {
  const _TocContents(this.toc, {required int? maxDepth})
    : maxDepth = maxDepth ?? 2;

  final TableOfContents toc;
  final int maxDepth;

  @override
  Component build(BuildContext _) => ul(
    classes: 'styled-toc-list',
    _buildEntries(toc.entries, 0),
  );

  List<Component> _buildEntries(List<TocEntry> entries, int depth) {
    if (depth >= maxDepth) {
      return const [];
    }

    final nextDepth = depth + 1;

    return [
      for (final entry in entries)
        li([
          span(classes: 'sidenav-item', [
            a(
              href: '#${entry.id}',
              [text(entry.text)],
            ),
          ]),
          if (nextDepth < maxDepth && entry.children.isNotEmpty)
            ul(_buildEntries(entry.children, nextDepth)),
        ]),
    ];
  }
}
