// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import '../button.dart';
import '../dropdown.dart';
import '../material_icon.dart';

@client
final class ThemeSwitcher extends StatelessComponent {
  const ThemeSwitcher();

  @override
  Component build(BuildContext _) => Dropdown(
    id: 'theme-switcher',
    children: [
      const DropdownToggle(Button(icon: 'routine', title: 'Select a theme.')),
      DropdownContent(
        div(
          classes: 'dropdown-menu',
          [
            ul(
              attributes: {'role': 'listbox'},
              const [
                _ThemeButtonEntry(
                  themeId: 'light',
                  themeName: 'Light',
                  title: 'Switch to light mode.',
                  iconId: 'light_mode',
                ),
                _ThemeButtonEntry(
                  themeId: 'dark',
                  themeName: 'Dark',
                  title: 'Switch to dark mode.',
                  iconId: 'dark_mode',
                ),
                _ThemeButtonEntry(
                  themeId: 'auto',
                  themeName: 'Automatic',
                  title: 'Match theme to device theme.',
                  iconId: 'night_sight_auto',
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

final class _ThemeButtonEntry extends StatelessComponent {
  const _ThemeButtonEntry({
    required this.themeId,
    required this.themeName,
    required this.title,
    required this.iconId,
  });

  final String themeId;
  final String themeName;
  final String title;
  final String iconId;

  @override
  Component build(BuildContext _) => li([
    button(
      attributes: {
        'data-theme': themeId,
        'title': title,
        'aria-label': title,
        'aria-selected': 'false',
      },
      [
        MaterialIcon(iconId),
        span([text(themeName)]),
      ],
    ),
  ]);
}
