import 'package:jaspr/jaspr.dart';

/// A generic card component.
class Card extends StatelessComponent {
  const Card({
    super.key,
    this.header = const [],
    this.content = const [],
    this.actions,
    this.outlined = false,
    this.filled = false,
    this.id,
    this.attributes = const {},
    this.additionalClasses,
    this.link,
  }) : collapsedContent = null,
       expandable = false,
       initiallyExpanded = true;

  const Card.expandable({
    super.key,
    this.header = const [],
    required List<Component> expandedContent,
    required this.collapsedContent,
    this.actions,
    this.outlined = false,
    this.filled = false,
    required String this.id,
    this.attributes = const {},
    this.additionalClasses,
    this.initiallyExpanded = true,
  }) : content = expandedContent,
       link = null,
       expandable = true;

  final List<Component> header;
  final List<Component> content;
  final List<Component>? collapsedContent;
  final CardActions? actions;

  final bool outlined;
  final bool filled;
  final bool expandable;
  final String? id;
  final String? link;
  final Map<String, String> attributes;
  final String? additionalClasses;
  final bool initiallyExpanded;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final classes = [
      'card',
      if (outlined) 'outlined-card',
      if (filled) 'filled-card',
      if (expandable) 'expandable-card',
      if (additionalClasses != null) additionalClasses!,
    ].join(' ');

    final children = [
      if (header.isNotEmpty) div(classes: 'card-header', header),
      if (collapsedContent case final collapsedContent?)
        div(classes: 'initial-content', collapsedContent),
      div(
        id: id != null ? '$id-content' : null,
        classes: [
          'card-content',
          if (expandable) 'expandable-content',
        ].join(' '),
        content,
      ),
      ?actions,
    ];

    if (link case final link?) {
      yield a(
        classes: classes,
        id: id,
        href: link,
        attributes: attributes,
        children,
      );
    } else {
      yield div(
        classes: classes,
        id: id,
        attributes: attributes,
        children,
      );
    }
  }
}

class CardActions extends StatelessComponent {
  const CardActions({this.leading = const [], this.trailing = const []});

  final List<Component> leading;
  final List<Component> trailing;

  @override
  Iterable<Component> build(BuildContext context) {
    return [
      div(classes: 'card-actions', [
        div(classes: 'leading', leading),
        div(classes: 'trailing', trailing),
      ]),
    ];
  }
}
