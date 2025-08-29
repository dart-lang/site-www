import 'package:jaspr/jaspr.dart';

final class FragmentTarget extends StatelessComponent {
  const FragmentTarget(this.id);

  final String id;

  @override
  Component build(BuildContext context) => a(
    href: '',
    id: id,
    attributes: {'aria-hidden': 'true'},
    [],
  );
}
