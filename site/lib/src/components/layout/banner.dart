// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// A segment of text in the site banner, which can optionally be a link.
@immutable
final class BannerSpan {
  final String text;
  final String? url;
  final bool newTab;

  const BannerSpan({
    required this.text,
    this.url,
    this.newTab = false,
  });

  factory BannerSpan.fromMap(Map<Object?, Object?> map) {
    return BannerSpan(
      text: map['text'] as String,
      url: map['url'] as String?,
      newTab: map['newTab'] as bool? ?? false,
    );
  }
}

/// The information to display in the site banner,
/// as configured in the `src/data/banner.yml` file.
@immutable
final class BannerContent {
  final List<BannerSpan> spans;

  const BannerContent({
    required this.spans,
  });

  factory BannerContent.fromMap(Map<String, Object?> bannerData) {
    if (bannerData['spans'] case final List<Object?> spansList) {
      return BannerContent(
        spans: spansList
            .map((s) => BannerSpan.fromMap(s as Map<Object?, Object?>))
            .toList(),
      );
    }

    // Fallback for backward compatibility
    final text = bannerData['text'] as String;
    final link = bannerData['link'] as Map<Object?, Object?>?;
    if (link != null) {
      return BannerContent(
        spans: [
          BannerSpan(text: text),
          const BannerSpan(text: ' '),
          BannerSpan(
            text: link['text'] as String,
            url: link['url'] as String,
            newTab: link['newTab'] as bool? ?? false,
          ),
        ],
      );
    }

    return BannerContent(
      spans: [BannerSpan(text: text)],
    );
  }
}

/// The site-wide banner.
class DashBanner extends StatelessComponent {
  const DashBanner(this.content, {super.key});

  final BannerContent content;

  @override
  Component build(BuildContext context) => div(
    id: 'site-banner',
    attributes: {'role': 'alert'},
    [
      p([
        for (final span in content.spans)
          if (span.url != null)
            a(
              href: span.url!,
              target: span.newTab ? Target.blank : null,
              [.text(span.text)],
            )
          else
            .text(span.text),
      ]),
    ],
  );
}
