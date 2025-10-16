// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:meta/meta.dart';
import 'package:universal_web/web.dart' as web;

@Import.onWeb(
  'package:inject_dartpad/inject_dartpad.dart',
  show: [#EmbeddedDartPad, #DartPadTheme],
)
import 'dartpad_injector.imports.dart';

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

  final GlobalNodeKey<web.HTMLElement> _wrapperKey = GlobalNodeKey();
  final String _frameId = () {
    final nextId = _injectedIndex;
    _injectedIndex += 1;
    return 'embedded-dartpad-$nextId';
  }();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      context.binding.addPostFrameCallback(_replaceWithDartPad);
    }
  }

  /// Initialize the embedded DartPad.
  ///
  /// If successful, replaces the original `pre` element
  /// with a DartPad `iframe`.
  @awaitNotRequired
  Future<void> _replaceWithDartPad() async {
    if (_initialized || !kIsWeb) return;

    final dartPad = EmbeddedDartPad.create(
      iframeId: _frameId,
      theme: switch (component.theme) {
        'auto' => DartPadTheme.auto,
        'dark' => DartPadTheme.dark,
        _ => DartPadTheme.light,
      },
      embedLayout: true,
    );

    await dartPad.initialize(
      onElementCreated: (iframe) {
        final wrapperElement = _wrapperKey.currentNode;
        if (wrapperElement == null) return;

        if (component.height case final heightToSet?) {
          iframe.style.height = heightToSet;
        }
        iframe.title = component.title;

        // Replace the original code block with the
        // created iframe so it can begin loading.
        wrapperElement.replaceChildren(iframe);
      },
    );

    dartPad.updateCode(component.content);

    _initialized = true;
  }

  @override
  Component build(BuildContext context) {
    return div(key: _wrapperKey, classes: 'injected-dartpad-wrapper', [
      pre([
        code(
          attributes: {'title': component.title},
          [text(component.content)],
        ),
      ]),
    ]);
  }
}
