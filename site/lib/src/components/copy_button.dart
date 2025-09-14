// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import 'package:universal_web/web.dart' as web;

import 'button.dart';

@client
class CopyButton extends StatefulComponent {
  const CopyButton({
    required this.toCopy,
    this.buttonText,
    this.classes = const [],
    this.title,
  });

  final String toCopy;
  final String? title;
  final String? buttonText;
  final List<String> classes;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _hidden = true;

  @override
  void initState() {
    // Unhide the copy button if successfully initialized on the client.
    if (kIsWeb && component.toCopy.isNotEmpty) {
      _hidden = false;
    }

    super.initState();
  }

  @override
  Component build(BuildContext _) {
    final iconButton = component.buttonText == null;
    return Button(
      style: iconButton ? ButtonStyle.text : ButtonStyle.filled,
      classes: [
        'copy-button',
        if (_hidden) 'hidden',
        ...component.classes,
      ],
      title: component.title ?? 'Copy ${component.toCopy} to your clipboard.',
      content: component.buttonText,
      icon: iconButton ? 'content_copy' : null,
      onClick: () {
        web.window.navigator.clipboard.writeText(component.toCopy);
      },
    );
  }
}
