// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

class BreakingChangesLegend extends StatelessComponent {
  const BreakingChangesLegend({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Component build(BuildContext context) {
    return div(classes: 'legend-overlay', [
      div(classes: 'legend-dialog', [
        div(classes: 'legend-header', [
          h3([text('About Breaking Changes')]),
          button(
            classes: 'close-button',
            onClick: onClose,
            [
              span(classes: 'material-symbols-outlined', [text('close')]),
            ],
          ),
        ]),
        div(classes: 'legend-content', [
          p([
            text(
                'This page lists all breaking changes and deprecations in updates to the Dart SDK, organized by release and area, to help Dart developers understand and manage their impact.'),
          ]),
          h4([text('Types of breaking changes')]),
          dl([
            dt([text('Unversioned')]),
            dd([
              text(
                  "The Dart SDK doesn't maintain backward compatibility, and code might break as soon as you upgrade your SDK version if it relies on the previous behavior. These are the majority of changes and aren't specially marked.")
            ]),
            dt([
              text('Language versioned '),
              span(
                  classes: 'tag-label versioned-tag',
                  [text('Language versioned')])
            ]),
            dd([
              text(
                  'The Dart SDK maintains backward compatibility for existing code, and the behavior change only takes effect when you upgrade the language version of your code.')
            ]),
            dt([
              text('Deprecations '),
              span(classes: 'tag-label deprecated-tag', [text('Deprecated')]),
              text(' / '),
              span(classes: 'tag-label removed-tag', [text('Removed')])
            ]),
            dd([
              text(
                  'The Dart SDK maintains compatibility for deprecated code, with a warning. Deprecations are then completely removed in a later release, breaking any code that relies on the previous behavior.')
            ]),
            dt([
              text('Experimental '),
              span(
                  classes: 'tag-label experimental-tag',
                  [text('Experimental')])
            ]),
            dd([
              text(
                  'Part of the release but not yet treated as stable in the SDK and can break from one version to another.')
            ]),
          ]),
          p([
            text('Complete release notes are available in the '),
            a(
                href: 'https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md',
                target: Target.blank,
                [text('Dart SDK changelog')]),
            text('.'),
          ]),
        ]),
      ]),
    ]);
  }
}

// Helper functions for definition list elements if not available in jaspr
Component dl(List<Component> children) =>
    Component.element(tag: 'dl', children: children);
Component dt(List<Component> children) =>
    Component.element(tag: 'dt', children: children);
Component dd(List<Component> children) =>
    Component.element(tag: 'dd', children: children);
