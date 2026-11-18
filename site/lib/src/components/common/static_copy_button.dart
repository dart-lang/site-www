// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import 'button.dart';

/// A button that copies [toCopy] to the user's clipboard when clicked.
///
/// This button isn't hydrated as a client component.
/// Its click handling is delegated to the global site scripts,
/// so it's cheap to render many of them on one page.
///
/// To copy the contents of a code block, use `CodeBlockCopyButton` instead.
final class StaticCopyButton extends StatelessComponent {
  const StaticCopyButton({required this.toCopy, required this.buttonText});

  /// The text to copy to the clipboard.
  final String toCopy;

  /// The label of the button, restored after copy feedback is shown.
  final String buttonText;

  @override
  Component build(BuildContext context) => Button(
    style: .filled,
    classes: const ['copy-button'],
    title: 'Copy $toCopy to your clipboard.',
    content: buttonText,
    attributes: {'type': 'button', 'data-copy': toCopy},
  );
}
