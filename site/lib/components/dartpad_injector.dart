import 'package:jaspr/jaspr.dart';

final class DartPadInjector extends StatelessComponent {
  const DartPadInjector({
    super.key,
    required this.content,
    String? theme,
    String? title,
    this.height,
    bool? runAutomatically,
  }) : theme = theme ?? 'light',
       title = title ?? 'Runnable Dart sample',
       runAutomatically = runAutomatically ?? false;

  final List<String> content;
  final String theme;
  final String title;
  final String? height;
  final bool runAutomatically;

  @override
  Iterable<Component> build(BuildContext context) {
    return [
      pre([
        code(
          attributes: {
            'title': title,
            'data-dartpad': 'true',
            'data-embed': 'true',
            'data-theme': theme,
            'data-run': runAutomatically.toString(),
            'data-height': ?height,
          },
          [
            text(content.join('\n')),
          ],
        ),
      ]),
    ];
  }
}
