// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:html';
import 'package:dartpad_picker/dartpad_picker.dart';

const tryDartIdPrefix = 'try-dart';

void main() {
  if (isMobile()) {
    querySelector('.dash-dartpad').style.display = 'none';
    return;
  }

  var dartPadHost = querySelector('#dartpad-host');
  var select = querySelector('#dartpad-select');
  final examples = querySelector('#try-dart-examples');

  final exampleNames = [
    'Hello world',
    'Functions',
    'Control flow',
    'Strings',
    'Collection literals',
    'Classes',
    'Compute Pi',
  ];

  final snippets = exampleNames.map((n) => _createSnippet(examples, n));

  DartPadPicker(dartPadHost, select, snippets.toList());
}

Snippet _createSnippet(HtmlElement root, String name) => Snippet(
      name,
      _src(
        root,
        '#try-dart-${name.toLowerCase().replaceAll(' ', '-')}',
      ),
    );

String _src(HtmlElement root, String id, [String fallback]) =>
    root.querySelector(id)?.innerText ??
    fallback ??
    "/* Can't load example sources. Please refresh the page. */";

// Mobile browser detection

final RegExp _mobileRegex =
    RegExp(r'Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini');

bool isMobile() {
  return _mobileRegex.hasMatch(window.navigator.userAgent);
}
