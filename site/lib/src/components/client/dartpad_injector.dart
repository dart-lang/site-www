// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'embedded_dartpad.dart';

/// Prepares an element with the structure expected by
/// the `inject_dartpad` tool from site-shared.
@client
final class DartPadInjector extends StatefulComponent {
  DartPadInjector({
    super.key,
    required this.content,
    required this.title,
    this.theme,
    this.height,
    this.runAutomatically = false,
  });

  final String content;
  final String title;
  final String? theme;
  final String? height;
  final bool runAutomatically;

  @override
  State<StatefulComponent> createState() => _DartPadInjectorState();
}

final class _DartPadInjectorState extends State<DartPadInjector> {
  static int _injectedIndex = 0;

  final String _frameId = () {
    final nextId = _injectedIndex;
    _injectedIndex += 1;
    return 'embedded-dartpad-$nextId';
  }();

  @override
  Component build(BuildContext context) {
    return div(classes: 'injected-dartpad-wrapper', [
      if (!kIsWeb)
        pre([
          code(
            attributes: {'title': component.title},
            [text(component.content)],
          ),
        ])
      else
        Component.wrapElement(
          attributes: {
            'height': ?component.height,
            'title': component.title,
          },
          child: EmbeddedDartPad.create(
            iframeId: _frameId,
            theme: switch (component.theme) {
              'auto' => DartPadTheme.auto,
              'dark' => DartPadTheme.dark,
              _ => DartPadTheme.light,
            },
            embedLayout: true,
            code: component.content,
          ),
        ),
    ]);
  }
}
