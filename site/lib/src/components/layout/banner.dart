// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../markdown/markdown_parser.dart';

/// The information to display in the site banner,
/// as configured in the `src/data/banner.yml` file.
///
/// The [text] is rendered as inline Markdown, so it can include
/// links (such as `[label](url)`) and inline attributes
/// (such as `{:target="_blank"}` to open a link in a new tab).
@immutable
final class BannerContent {
  /// The raw banner text, rendered as inline Markdown.
  final String text;

  const BannerContent({required this.text});

  factory BannerContent.fromMap(Map<String, Object?> bannerData) =>
      BannerContent(text: bannerData['text'] as String);
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
      p([DashMarkdown(content: content.text, inline: true)]),
    ],
  );
}
