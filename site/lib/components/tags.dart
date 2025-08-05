import 'package:jaspr/jaspr.dart';

import 'material_icon.dart';

class Tags extends StatelessComponent {
  const Tags(this.tags);

  final List<Tag> tags;

  @override
  Iterable<Component> build(BuildContext context) {
    return [
      div(classes: 'tags', [for (final tag in tags) tag]),
    ];
  }
}

class Tag extends StatelessComponent {
  const Tag(this.content, {this.icon, this.title, this.label, this.color});

  final String content;
  final String? icon;
  final String? title;
  final String? label;
  final String? color;

  @override
  Iterable<Component> build(BuildContext context) {
    return [
      div(
        classes: 'tag-label',
        attributes: {
          'title': ?title,
          'aria-label': ?(label ?? title),
        },
        [
          if (icon case final iconId?) MaterialIcon(iconId),
          span([text(content)]),
        ],
      ),
    ];
  }
}
