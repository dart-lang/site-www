import 'package:jaspr/jaspr.dart';

import 'material_icon.dart';

class SearchBar extends StatelessComponent {
  const SearchBar({
    required this.placeholder,
    required this.label,
  });

  final String placeholder;
  final String label;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'search-row', [
      div(classes: 'search-wrapper', [
        const MaterialIcon('search', classes: ['leading-icon']),
        input(
          type: InputType.search,
          attributes: {
            'placeholder': placeholder,
            'aria-label': label,
          },
        ),
      ]),
    ]);
  }
}
