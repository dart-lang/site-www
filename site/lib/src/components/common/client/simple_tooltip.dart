// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import '../tooltip.dart';

@client
class SimpleTooltip extends StatelessComponent {
  const SimpleTooltip({
    required this.target,
    required this.content,
    super.key,
  });

  final Component target;
  final Component content;

  @override
  Component build(BuildContext context) {
    return Tooltip(
      target: target,
      content: content,
    );
  }
}
