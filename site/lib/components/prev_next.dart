import 'package:jaspr/jaspr.dart';

class PrevNext extends StatelessComponent {
  const PrevNext({super.key, this.previousPage, this.nextPage});

  final ({String url, String title})? previousPage;
  final ({String url, String title})? nextPage;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    if (previousPage == null && nextPage == null) return;

    yield nav(id: 'site-prev-next', [
      if (previousPage case final previousPage?)
        _PrevNextCard(page: previousPage, isPrevious: true),
      if (nextPage case final nextPage?)
        _PrevNextCard(page: nextPage, isPrevious: false),
    ]);
  }
}

class _PrevNextCard extends StatelessComponent {
  const _PrevNextCard({required this.page, required this.isPrevious});

  final ({String url, String title}) page;
  final bool isPrevious;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final classes = isPrevious ? 'prev' : 'next';
    final subtitle = isPrevious ? 'Previous' : 'Next';
    final ariaLabel = isPrevious ? 'Previous page: ' : 'Next page: ';
    final iconName = isPrevious ? 'chevron_left' : 'chevron_right';

    yield a(classes: classes, href: page.url, [
      if (isPrevious)
        span(
          classes: 'material-symbols',
          attributes: {'aria-hidden': 'true'},
          [text(iconName)],
        ),
      div([
        span(
          classes: 'prev-next-subtitle',
          attributes: {'aria-label': ariaLabel},
          [text(subtitle)],
        ),
        span(classes: 'prev-next-title', [text(page.title)]),
      ]),
      if (!isPrevious)
        span(
          classes: 'material-symbols',
          attributes: {'aria-hidden': 'true'},
          [text(iconName)],
        ),
    ]);
  }
}
