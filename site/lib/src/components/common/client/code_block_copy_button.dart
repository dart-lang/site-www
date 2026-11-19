// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import 'package:universal_web/web.dart' as web;

import '../button.dart';

/// An icon button that copies the code of
/// the code block it's placed in to the user's clipboard.
///
/// The button stays hidden until the code to copy is found on the client.
///
/// To copy other text, such as a name, use `StaticCopyButton` instead.
@client
final class CodeBlockCopyButton extends StatefulComponent {
  const CodeBlockCopyButton({this.title = 'Copy code to clipboard'});

  /// The tooltip and accessible description of the button.
  final String title;

  @override
  State<CodeBlockCopyButton> createState() => _CodeBlockCopyButtonState();
}

class _CodeBlockCopyButtonState extends State<CodeBlockCopyButton> {
  final GlobalNodeKey<web.HTMLButtonElement> buttonKey = .new();

  String? _content;
  bool _copied = false;

  static final RegExp _terminalReplacementPattern = RegExp(
    r'^(\s*\$\s*)|(PS\s+)?(C:\\(.*)>\s*)',
    multiLine: true,
  );

  @override
  void initState() {
    if (kIsWeb) {
      // Extract the code content and unhide the copy button on the client.
      context.binding.addPostFrameCallback(() {
        setState(() {
          _content = buttonKey.currentNode
              ?.closest('.code-block-wrapper')
              ?.querySelector('pre code')
              ?.textContent
              ?.replaceAll(_terminalReplacementPattern, '')
              .replaceAll('\u200B', ''); // Remove zero-width spaces.
        });

        assert(
          _content != null,
          'CodeBlockCopyButton: Unable to find code content to copy. '
          'Is the CodeBlockCopyButton inside a code block?',
        );
      });
    }

    super.initState();
  }

  void _copy() {
    final contentToCopy = _content;
    if (contentToCopy == null) {
      return;
    }

    web.window.navigator.clipboard.writeText(contentToCopy);

    setState(() => _copied = true);

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Component build(BuildContext _) {
    return Button(
      key: buttonKey,
      classes: [
        'copy-button',
        if (_content == null) 'hidden',
      ],
      title: component.title,
      content: _copied ? 'Copied!' : null,
      icon: 'content_copy',
      onClick: _copy,
    );
  }
}
