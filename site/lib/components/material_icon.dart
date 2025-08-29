// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

class MaterialIcon extends StatelessComponent {
  const MaterialIcon(
    this.id, {
    this.title,
    this.label,
    this.classes = const [],
  });

  final String id;
  final List<String> classes;
  final String? title;
  final String? label;

  @override
  Component build(BuildContext _) {
    return span(
      classes: ['material-symbols', ...classes].join(' '),
      attributes: {
        'title': ?title,
        'aria-label': ?(label ?? title),
      },
      [text(id)],
    );
  }
}
