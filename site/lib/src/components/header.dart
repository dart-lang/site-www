// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'material_icon.dart';

/// The site-wide top navigation bar.
class DashHeader extends StatelessComponent {
  const DashHeader({super.key});

  @override
  Component build(BuildContext context) {
    final pageUrlPath = context.page.url;
    final activeEntry = _activeNavEntry(pageUrlPath);

    return header(id: 'site-header', classes: 'always-dark-mode', [
      nav(classes: 'navbar', [
        a(
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
              [text('Dart')],
            ),
          ],
        ),

        ul(classes: 'nav-items', [
          li([
            a(
              href: '/overview',
              classes: [
                'nav-link',
                if (activeEntry == _ActiveNavEntry.overview) 'active',
              ].join(' '),
              [text('Overview')],
            ),
          ]),
          li([
            a(
              href: '/docs',
              classes: [
                'nav-link',
                if (activeEntry == _ActiveNavEntry.docs) 'active',
              ].join(' '),
              [
                span([text('Docs')]),
              ],
            ),
          ]),
          li([
            a(
              href: '/community',
              classes: [
                'nav-link',
                if (activeEntry == _ActiveNavEntry.community) 'active',
              ].join(' '),
              [text('Community')],
            ),
          ]),
          li([
            if (activeEntry == _ActiveNavEntry.learn)
              a(href: '/get-started', classes: 'nav-link active', [
                text('Learn'),
              ])
            else
              a(href: '/#try-dart', classes: 'nav-link', [
                text('Try Dart'),
              ]),
          ]),
          li([
            a(
              href: '/get-dart',
              classes: [
                'nav-link',
                if (activeEntry == _ActiveNavEntry.getDart) 'active',
              ].join(' '),
              [text('Get Dart')],
            ),
          ]),
        ]),

        div(
          classes: 'navbar-contents',
          [
            form(
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
            a(
              id: 'fallback-search-button',
              classes: 'icon-button',
              href: '/search',
              attributes: {
                'aria-label': 'Navigate to the dart.dev search page.',
                'title': 'Navigate to the dart.dev search page.',
              },
              const [
                MaterialIcon('search'),
              ],
            ),
            div(id: 'theme-switcher', classes: 'dropdown', [
              button(
                classes: 'dropdown-button icon-button',
                attributes: {
                  'title': 'Select a theme',
                  'aria-label': 'Select a theme',
                  'aria-expanded': 'false',
                  'aria-controls': 'theme-menu',
                },
                const [MaterialIcon('routine')],
              ),
              div(classes: 'dropdown-content', id: 'theme-menu', [
                div(classes: 'dropdown-menu', [
                  ul(
                    attributes: {'role': 'listbox'},
                    [
                      li([
                        button(
                          attributes: {
                            'data-theme': 'light',
                            'title': 'Switch to light mode',
                            'aria-label': 'Switch to light mode',
                            'aria-selected': 'false',
                          },
                          [
                            const MaterialIcon('light_mode'),
                            span([text('Light')]),
                          ],
                        ),
                      ]),
                      li([
                        button(
                          attributes: {
                            'data-theme': 'dark',
                            'title': 'Switch to dark mode',
                            'aria-label': 'Switch to dark mode',
                            'aria-selected': 'false',
                          },
                          [
                            const MaterialIcon('dark_mode'),
                            span([text('Dark')]),
                          ],
                        ),
                      ]),
                      li([
                        button(
                          attributes: {
                            'data-theme': 'auto',
                            'title': 'Follow the device theme',
                            'aria-label': 'Follow the device theme',
                            'aria-selected': 'false',
                          },
                          [
                            const MaterialIcon('night_sight_auto'),
                            span([text('Automatic')]),
                          ],
                        ),
                      ]),
                    ],
                  ),
                ]),
              ]),
            ]),
            div(
              id: 'site-switcher',
              classes: 'dropdown',
              [
                button(
                  classes: 'dropdown-button icon-button',
                  attributes: {
                    'title': 'Select a theme',
                    'aria-label': 'Select a theme',
                    'aria-expanded': 'false',
                    'aria-controls': 'site-switcher-menu',
                  },
                  const [MaterialIcon('apps')],
                ),

                div(
                  id: 'site-switcher-menu',
                  classes: 'dropdown-content',
                  [
                    nav(
                      classes: 'dropdown-menu',
                      attributes: {
                        'role': 'menu',
                      },
                      [
                        ul(
                          const [
                            _SiteWordMarkListEntry(
                              name: 'Dart',
                              href: '/',
                              current: true,
                            ),
                            _SiteWordMarkListEntry(
                              name: 'Dart',
                              subtype: 'API',
                              href: 'https://api.dart.dev',
                            ),
                            _SiteWordMarkListEntry(
                              name: 'DartPad',
                              href: 'https://dartpad.dev',
                            ),
                            _SiteWordMarkListEntry(
                              name: 'pub.dev',
                              href: 'https://pub.dev',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            button(
              id: 'menu-toggle',
              classes: 'icon-button',
              type: ButtonType.button,
              attributes: {
                'aria-controls': 'sidenav',
                'aria-label': 'Open navigation menu.',
                'title': 'Open navigation menu.',
              },
              const [
                MaterialIcon('menu'),
                MaterialIcon('close'),
              ],
            ),
          ],
        ),
      ]),
    ]);
  }
}

class _SiteWordMarkListEntry extends StatelessComponent {
  const _SiteWordMarkListEntry({
    required this.href,
    required this.name,
    this.subtype,
    this.current = false,
  });

  final String href;
  final String name;
  final String? subtype;
  final bool current;

  String get _combinedName => '$name${subtype != null ? ' $subtype' : ''}';

  @override
  Component build(BuildContext context) {
    return li(
      attributes: {'role': 'presentation'},
      [
        a(
          href: '/',
          classes: ['site-wordmark', if (current) 'current-site'].join(' '),
          attributes: {
            'role': 'menuitem',
            'title': 'Navigate to the $_combinedName website.',
            'aria-label': 'Navigate to the $_combinedName website.',
          },
          [
            img(
              src: '/assets/img/logo/dart-192.svg',
              alt: 'Dart logo',
              width: 28,
              height: 28,
            ),
            span(
              classes: 'name',
              attributes: {
                'translate': 'no',
              },
              [text(name)],
            ),
            if (subtype case final subtype?)
              span(
                classes: 'subtype',
                [text(subtype)],
              ),
          ],
        ),
      ],
    );
  }
}

_ActiveNavEntry? _activeNavEntry(String pageUrlPath) {
  final firstFragment = pageUrlPath
      .split('/')
      .where((fragment) => fragment.isNotEmpty)
      .firstOrNull
      ?.trim()
      .toLowerCase();

  return switch (firstFragment) {
    'overview' => _ActiveNavEntry.overview,
    'community' => _ActiveNavEntry.community,
    'get-started' => _ActiveNavEntry.learn,
    'get-dart' => _ActiveNavEntry.getDart,
    'deprecated' ||
    'docs' ||
    'effective-dart' ||
    'get-started' ||
    'interop' ||
    'language' ||
    'libraries' ||
    'null-safety' ||
    'resources' ||
    'server' ||
    'tools' ||
    'tutorials' ||
    'web' ||
    'multiplatform-apps' => _ActiveNavEntry.docs,
    _ => null,
  };
}

enum _ActiveNavEntry {
  overview,
  community,
  getDart,
  docs,
  learn,
}
