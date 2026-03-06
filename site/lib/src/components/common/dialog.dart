// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../util/global_event_listener.dart';
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
    this.visible = false,
    this.classes,
    super.key,
  });

  void _closeAndBlur() {
    if (kIsWeb) {
      if (web.document.activeElement case final web.HTMLElement activeElement) {
        activeElement.blur();
      }
    }
    onClose();
  }

  /// Callback triggered when closing the dialog (via button or overlay click).
  final VoidCallback onClose;

  /// The title displayed in the dialog header.
  final String title;

  /// The content of the dialog.
  final List<Component> children;

  /// Whether to show the dialog.
  final bool visible;

  /// Additional CSS classes for the dialog overlay.
  final String? classes;

  @override
  Component build(BuildContext context) {
    return GlobalEventListener(
      div(
        classes: 'legend-overlay ${visible ? 'show' : ''} ${classes ?? ''}',
        events: {
          'click': (e) {
            if (e.target == e.currentTarget) {
              _closeAndBlur();
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
                onClick: _closeAndBlur,
              ),
            ]),
            div(classes: 'legend-content', children),
          ]),
        ],
      ),
      onKeyDown: (event) {
        if (visible && event.key == 'Escape') {
          _closeAndBlur();
        }
      },
    );
  }
}
