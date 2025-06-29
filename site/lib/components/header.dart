import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'banner.dart';

class DashHeader extends StatelessComponent {
  const DashHeader({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final page = context.page;
    final pageUrlPath = page.url;
    final pageData = page.data['page'] as Map<String, Object?>;
    final siteData = page.data['site'] as Map<String, Object?>;
    final siteTitle = siteData['title'] as String;
    final obsolete = pageData['obsolete'] == true;

    if (siteData['showBanner'] != false && pageData['showBanner'] != false) {
      yield DashBanner(
        BannerContent.fromMap(page.data['banner'] as Map<String, Object?>),
      );
    }

    yield header(id: 'site-header', [
      nav(id: 'mainnav', classes: 'always-dark-mode', [
        a(
          href: '/',
          classes: 'brand',
          attributes: {'title': siteTitle},
          [img(src: '/assets/img/logo/logo-white-text.svg', alt: siteTitle)],
        ),

        ul(classes: 'navbar', [
          li([
            a(
              href: '/overview',
              classes: [
                'nav-link',
                if (pageUrlPath.contains('/overview/')) 'active',
              ].join(' '),
              [text('Overview')],
            ),
          ]),
          li([
            a(
              href: '/docs',
              classes: [
                'nav-link',
                if (_isDocsActive(pageUrlPath)) 'active',
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
                if (pageUrlPath.contains('/community/')) 'active',
              ].join(' '),
              [text('Community')],
            ),
          ]),
          li([
            if (pageUrlPath.contains('/get-started/'))
              a(href: '/get-started', classes: 'nav-link active', [
                text('Learn'),
              ])
            else
              a(href: '/#try-dart', classes: 'nav-link', [text('Try Dart')]),
          ]),
          li([
            a(
              href: '/get-dart',
              classes: [
                'nav-link',
                if (pageUrlPath.contains('/get-dart/')) 'active',
              ].join(' '),
              [text('Get Dart')],
            ),
          ]),
        ]),
        div(classes: 'navbar-contents', [
          form(
            action: '/search/',
            classes: 'site-header-search',
            id: 'cse-search-box',
            [
              input(
                type: InputType.hidden,
                name: 'cx',
                value: '011220921317074318178:_yy-tmb5t_i',
                [],
              ),
              input(type: InputType.hidden, name: 'ie', value: 'UTF-8', []),
              input(type: InputType.hidden, name: 'hl', value: 'en', []),
              input(
                type: InputType.search,
                name: 'q',
                id: 'search-main',
                classes: 'site-header-searchfield search-field',
                attributes: {
                  'autocomplete': 'off',
                  'placeholder': 'Search',
                  'aria-label': 'Search',
                },
                [],
              ),
            ],
          ),

          a(
            href: '/search',
            id: 'fallback-search-button',
            classes: 'icon-button',
            attributes: {
              'aria-label': 'Navigate to the docs search page.',
              'title': 'Navigate to the docs search page.',
            },
            [
              span(
                classes: 'material-symbols',
                attributes: {'aria-hidden': 'true'},
                [text('search')],
              ),
            ],
          ),
          div(id: 'theme-switcher', classes: 'dropdown', [
            button(
              classes: 'dropdown-button icon-button',
              attributes: {
                'title': 'Select a theme',
                'aria-label': 'Select a theme',
                'aria-expanded': 'false',
                'aria-controls': 'site-switcher-menu',
              },
              [
                span(
                  classes: 'material-symbols',
                  attributes: {'aria-hidden': 'true'},
                  [text('routine')],
                ),
              ],
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
                          span(
                            classes: 'material-symbols',
                            attributes: {'aria-hidden': 'true'},
                            [text('light_mode')],
                          ),
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
                          span(
                            classes: 'material-symbols',
                            attributes: {'aria-hidden': 'true'},
                            [text('dark_mode')],
                          ),
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
                          span(
                            classes: 'material-symbols',
                            attributes: {'aria-hidden': 'true'},
                            [text('night_sight_auto')],
                          ),
                          span([text('Automatic')]),
                        ],
                      ),
                    ]),
                  ],
                ),
              ]),
            ]),
          ]),
          button(
            id: 'menu-toggle',
            classes: 'icon-button',
            type: ButtonType.button,
            attributes: {
              'aria-controls': 'sidenav',
              'aria-label': 'Toggle side navigation menu.',
              'title': 'Toggle side navigation menu.',
            },
            [
              span(
                classes: 'material-symbols',
                attributes: {'aria-hidden': 'true'},
                [text('menu')],
              ),
              span(
                classes: 'material-symbols',
                attributes: {'aria-hidden': 'true'},
                [text('close')],
              ),
            ],
          ),
        ]),
      ]),
      if (obsolete)
        div(classes: 'alert alert-warning', [
          h4(classes: 'text-center', [
            text('Some of the content of this page might be out of date.'),
          ]),
        ]),
    ]);
  }

  bool _isDocsActive(String pageUrlPath) {
    return pageUrlPath.contains('/docs/') ||
        pageUrlPath.contains('/language/') ||
        pageUrlPath.contains('/resources/') ||
        pageUrlPath.contains('/codelabs/') ||
        pageUrlPath.contains('/deprecated/') ||
        pageUrlPath.contains('/tools/') ||
        pageUrlPath.contains('/tutorials/') ||
        pageUrlPath.contains('/server/') ||
        pageUrlPath.contains('/web/') ||
        pageUrlPath.contains('/effective-dart/') ||
        pageUrlPath.contains('/libraries/');
  }
}
