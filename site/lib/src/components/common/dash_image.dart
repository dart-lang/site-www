import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../markdown/markdown_parser.dart';

class DashImage extends StatelessComponent {
  const DashImage({
    required this.src,
    this.alt,
    this.caption,
    super.key,
  });

  final String src;
  final String? alt;
  final String? caption;

  static DashImage fromAttributes(Map<String, String> attributes) {
    if (attributes['src'] == null) {
      throw ArgumentError.value(
        attributes,
        'src',
        'DashImage requires a "src" attribute',
      );
    }
    return DashImage(
      src: attributes['src']!,
      alt: attributes['alt'],
      caption: attributes['caption'],
    );
  }

  @override
  Component build(BuildContext context) {
    return figure([
      img(src: context.resolveAsset(src), alt: alt),
      if (caption != null && caption!.isNotEmpty)
        figcaption([
          DashMarkdown(content: caption!, inline: true),
        ], classes: 'figure-caption'),
    ]);
  }
}
