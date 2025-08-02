import 'package:jaspr/jaspr.dart';

class MaterialIcon extends StatelessComponent {
  const MaterialIcon(
    this.id, {
    this.title,
    this.label,
    this.classes = const [],
  });

  final String id;
  final List<String> classes;
  final String? title;
  final String? label;

  @override
  Iterable<Component> build(BuildContext _) {
    return [
      span(
        classes: ['material-symbols', ...classes].join(' '),
        attributes: {
          'title': ?title,
          'aria-label': ?(label ?? title),
        },
        [text(id)],
      ),
    ];
  }
}

class SvgIcon extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
