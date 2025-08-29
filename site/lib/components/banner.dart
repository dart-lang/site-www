import 'package:jaspr/jaspr.dart';

@immutable
final class BannerContent {
  final String text;
  final String linkText;
  final String linkUri;
  final bool newTab;

  const BannerContent({
    required this.text,
    required this.linkText,
    required this.linkUri,
    this.newTab = false,
  });

  factory BannerContent.fromMap(Map<String, Object?> bannerData) {
    final text = bannerData['text'] as String;
    final link = bannerData['link'] as Map<Object?, Object?>;
    final linkText = link['text'] as String;
    final linkUri = link['url'] as String;
    final newTab = link['newTab'] as bool? ?? false;

    return BannerContent(
      text: text,
      linkText: linkText,
      linkUri: linkUri,
      newTab: newTab,
    );
  }
}

class DashBanner extends StatelessComponent {
  const DashBanner(this.content, {super.key});

  final BannerContent content;

  @override
  Component build(BuildContext context) => div(
    id: 'site-banner',
    attributes: {'role': 'alert'},
    [
      p([
        text(content.text),
        text(' '),
        a(
          href: content.linkUri,
          target: content.newTab ? Target.blank : null,
          [text(content.linkText)],
        ),
      ]),
    ],
  );
}
