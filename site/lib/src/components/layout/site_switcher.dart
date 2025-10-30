// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import '../../util.dart';
import '../common/button.dart';
import '../common/dropdown.dart';

@client
final class SiteSwitcher extends StatelessComponent {
  const SiteSwitcher();

  @override
  Component build(BuildContext _) => Dropdown(
    id: 'site-switcher',
    children: [
      const DropdownToggle(Button(icon: 'apps', title: 'Visit related sites.')),
      DropdownContent(
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
      ),
    ],
  );
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
  Component build(BuildContext _) {
    return li(
      [
        a(
          href: href,
          classes: ['site-wordmark', if (current) 'current-site'].toClasses,
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
