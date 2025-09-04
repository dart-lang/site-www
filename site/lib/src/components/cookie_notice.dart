// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

/// The cookie banner to show on a user's first time visiting the site.
class DashCookieNotice extends StatelessComponent {
  const DashCookieNotice({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: 'cookie-notice',
      attributes: {'data-nosnippet': 'true'},
      [
        div(classes: 'container', [
          p([
            text(
              'dart.dev uses cookies from Google to deliver and '
              'enhance the quality of its services and to analyze traffic.',
            ),
          ]),
          div(classes: 'button-group', [
            a(
              href: 'https://policies.google.com/technologies/cookies',
              target: Target.blank,
              classes: 'text-button',
              attributes: {'rel': 'noopener'},
              [text('Learn more')],
            ),
            button(id: 'cookie-consent', classes: 'filled-button', [
              text('OK, got it'),
            ]),
          ]),
        ]),
      ],
    );
  }
}
