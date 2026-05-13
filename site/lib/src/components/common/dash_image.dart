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
    required this.alt,
    this.caption,
    super.key,
  });

  final String src;
  final String alt;
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
    final alt = attributes['alt'];
    if (alt == null || alt.trim().isEmpty) {
      throw ArgumentError.value(
        alt,
        'alt',
        'DashImage requires a non-empty "alt" attribute',
      );
    }
    return DashImage(
      src: imageSrc,
      alt: alt,
      caption: attributes['caption'],
    );
  }

  @override
  Component build(BuildContext context) {
    return figure([
      img(src: context.resolveAsset(src), alt: alt),
      if (caption case final caption? when caption.isNotEmpty)
        figcaption([
          DashMarkdown(content: caption, inline: true),
        ], classes: 'figure-caption'),
    ]);
  }
}
