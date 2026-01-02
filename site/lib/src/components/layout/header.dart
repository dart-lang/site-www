// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../util.dart';
import '../../utils/active_nav.dart';
import '../common/material_icon.dart';
import 'menu_toggle.dart';
import 'site_switcher.dart';
import 'theme_switcher.dart';

/// The site-wide top navigation bar.
class DashHeader extends StatelessComponent {
  const DashHeader({super.key});

  @override
  Component build(BuildContext context) {
    final pageUrlPath = context.page.url;
    final layout = context.page.data.page['layout'];
    final activeEntry = activeNavEntry(pageUrlPath);

    return header(id: 'site-header', classes: 'always-dark-mode', [
      nav(classes: 'navbar', [
        const a(
          id: 'site-primary-logo',
          classes: 'site-wordmark',
          href: '/',
          attributes: {
            'aria-label': 'Go to the Dart homepage',
            'title': 'Go to the Dart homepage',
          },
          [
            img(
              src: '/assets/img/logo/dart-192.svg',
              alt: 'Dart logo',
              attributes: {'width': '192'},
            ),
            span(
              classes: 'name',
              attributes: {'translate': 'no'},
              [.text('Dart')],
            ),
          ],
        ),

        ul(classes: 'nav-items', [
          li([
            a(
              href: '/overview',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.overview) 'active',
              ].toClasses,
              [const .text('Overview')],
            ),
          ]),
          li([
            a(
              href: '/docs',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.docs) 'active',
              ].toClasses,
              [
                const span([.text('Docs')]),
              ],
            ),
          ]),
          li([
            a(
              href: 'https://blog.dart.dev',
              classes: [
                'nav-link',
              ].toClasses,
              [const .text('Blog')],
            ),
          ]),
          li([
            a(
              href: '/community',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.community) 'active',
              ].toClasses,
              [const .text('Community')],
            ),
          ]),
          li([
            if (activeEntry == ActiveNavEntry.learn)
              const a(href: '/learn', classes: 'nav-link active', [
                .text('Learn'),
              ])
            else
              const a(href: '/#try-dart', classes: 'nav-link', [
                .text('Try Dart'),
              ]),
          ]),
          li([
            a(
              href: '/get-dart',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.getDart) 'active',
              ].toClasses,
              [const .text('Get Dart')],
            ),
          ]),
        ]),

        div(
          classes: 'navbar-contents',
          [
            const form(
              action: '/search/',
              id: 'header-search',
              [
                input(
                  classes: 'search-field',
                  type: InputType.search,
                  name: 'q',
                  id: 'q',
                  attributes: {
                    'autocomplete': 'off',
                    'placeholder': 'Search',
                    'aria-label': 'Search',
                  },
                ),
              ],
            ),
            const a(
              id: 'fallback-search-button',
              classes: 'icon-button',
              href: '/search',
              attributes: {
                'aria-label': 'Navigate to the dart.dev search page.',
                'title': 'Navigate to the dart.dev search page.',
              },
              [
                MaterialIcon('search'),
              ],
            ),
            if (layout != 'homepage') const ThemeSwitcher(),
            const SiteSwitcher(),
            const MenuToggle(),
          ],
        ),
      ]),
    ]);
  }
}
