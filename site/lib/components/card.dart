import 'package:jaspr/jaspr.dart';

/// A card component that displays content with an optional title and link.
class ContentCard extends StatelessComponent {
  const ContentCard({
    super.key,
    required this.title,
    required this.child,
    this.link,
  });

  final String title;
  final Component child;
  final String? link;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final cardContent = div([
      div(classes: 'card-header', [
        header(classes: 'card-title', [text(title)]),
      ]),
      div(classes: 'card-content', [child]),
    ]);

    if (link case final link?) {
      yield a(href: link, classes: 'card filled-card', [cardContent]);
    } else {
      yield div(classes: 'card', [cardContent]);
    }
  }
}
