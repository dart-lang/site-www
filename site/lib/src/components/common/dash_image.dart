// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
    final imageSrc = attributes['src'];
    if (imageSrc == null) {
      throw ArgumentError.value(
        attributes,
        'src',
        'DashImage requires a "src" attribute',
      );
    }
    return DashImage(
      src: imageSrc,
      alt: attributes['alt'],
      caption: attributes['caption'],
    );
  }

  @override
  Component build(BuildContext context) {
    if (alt == null) {
      print(
        '[WARNING] DashImage is missing an "alt" attribute for '
        '${context.page.url}:$src',
      );
    }
    return figure([
      img(src: context.resolveAsset(src), alt: alt),
      if (caption case final caption? when caption.isNotEmpty)
        figcaption([
          DashMarkdown(content: caption, inline: true),
        ], classes: 'figure-caption'),
    ]);
  }
}
