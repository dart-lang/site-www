// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'button.dart';

/// A modal dialog component with a standard layout.
///
/// Includes:
/// * Overlay background with click-outside-to-close behavior
/// * Header with title and close button
/// * Content area
class Dialog extends StatelessComponent {
  const Dialog({
    required this.onClose,
    required this.title,
    required this.children,
    this.classes,
    super.key,
  });

  /// Callback triggered when closing the dialog (via button or overlay click).
  final VoidCallback onClose;

  /// The title displayed in the dialog header.
  final String title;

  /// The content of the dialog.
  final List<Component> children;

  /// Additional CSS classes for the dialog overlay.
  final String? classes;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'legend-overlay ${classes ?? ''}',
      events: {
        'click': (e) {
          if (e.target == e.currentTarget) {
            onClose();
          }
        },
      },
      [
        div(classes: 'legend-dialog', [
          div(classes: 'legend-header', [
            h3([Component.text(title)]),
            Button(
              icon: 'close',
              classes: ['close-button'],
              onClick: onClose,
            ),
          ]),
          div(classes: 'legend-content', children),
        ]),
      ],
    );
  }
}
