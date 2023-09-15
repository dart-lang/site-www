// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:html';

class Snippet {
  final String name;
  final String sourceCode;

  const Snippet(this.name, this.sourceCode);
}

class DartPadPicker {
  final String dartPadUrl;
  final Element iFrameHost;
  final SelectElement selectElement;
  final List<Snippet> snippets;
  final String? frameId;
  late final IFrameElement _iFrameElement;
  int _selected = 0;

  DartPadPicker(
    this.iFrameHost,
    this.selectElement,
    this.snippets, {
    this.dartPadUrl = 'https://dartpad.dev',
    this.frameId,
  }) {
    _initSelectElement();
    _initDartPad();
  }

  Snippet get _selectedSnippet => snippets[_selected];

  Map<String, Object> get _sourceCodeMessage => {
        'sourceCode': {
          'main.dart': _selectedSnippet.sourceCode,
        },
        'type': 'sourceCode'
      };

  void _initSelectElement() {
    for (var i = 0; i < snippets.length; i++) {
      final snippet = snippets[i];
      final option = OptionElement(value: '$i')..text = snippet.name;
      selectElement.children.add(option);
    }
    selectElement.onChange.listen((Event _) {
      _selected = selectElement.selectedIndex ?? 0;
      _sendSourceCode();
    });
  }

  void _initDartPad() {
    _iFrameElement = IFrameElement()
      ..src = iFrameSrc(theme: 'dark', mode: 'dart');
    final id = frameId;
    if (id != null) {
      _iFrameElement.id = id;
    }
    iFrameHost.children.add(_iFrameElement);
    window.addEventListener('message', (Event event) {
      final messageEvent = event as MessageEvent;
      // Don't handle events from other iframe elements
      final data = messageEvent.data;
      if (data is Map && data['type'] == 'ready') {
        _sendSourceCode();
      }
    });
  }

  void _sendSourceCode() {
    _iFrameElement.contentWindow?.postMessage(_sourceCodeMessage, '*');
  }

  String iFrameSrc({String theme = 'dark', String mode = 'dart'}) =>
      '$dartPadUrl/embed-$mode.html?theme=$theme';
}
