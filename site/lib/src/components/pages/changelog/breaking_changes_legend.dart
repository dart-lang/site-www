// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../models/changelog_model.dart';

import '../../common/dialog.dart';

/// A modal dialog extending [StatelessComponent] that displays definitions
/// of the various breaking change tags used in the changelog.
class BreakingChangesLegend extends StatelessComponent {
  const BreakingChangesLegend({
    required this.onClose,
    this.visible = false,
    super.key,
  });

  /// Callback triggered when the close button or overlay is clicked.
  final VoidCallback onClose;

  /// Whether the legend is visible.
  final bool visible;

  @override
  Component build(BuildContext context) {
    return Dialog(
      visible: visible,
      onClose: onClose,
      title: 'Types of changes',
      children: const [
        dl([
          dt([.text('New '), _TagLabel(ChangelogTag.newTag)]),
          dd([.text('Introduces a new feature or API.')]),
          dt([.text('Fixed '), _TagLabel(ChangelogTag.fixed)]),
          dd([.text('Fixes a bug or defect.')]),
          dt([.text('Changed '), _TagLabel(ChangelogTag.changed)]),
          dd([.text('Modifies existing behavior or APIs.')]),
          dt([.text('Breaking '), _TagLabel(ChangelogTag.breaking)]),
          dd([.text('Incompatible change that may require code migration.')]),
          dt([.text('Unversioned')]),
          dd([
            .text(
              "The Dart SDK doesn't maintain backward compatibility, "
              'and code might break as soon as you upgrade your SDK version '
              'if it relies on the previous behavior. '
              'These are the majority of changes and '
              "aren't specially marked.",
            ),
          ]),
          dt([
            .text('Language versioned '),
            _TagLabel(ChangelogTag.languageVersioned),
          ]),
          dd([
            .text(
              'The Dart SDK maintains backward compatibility for '
              'existing code, and the behavior change only takes effect when '
              'you upgrade the language version of your code.',
            ),
          ]),
          dt([
            .text('Deprecations '),
            _TagLabel(ChangelogTag.deprecated),
            .text(' / '),
            _TagLabel(ChangelogTag.removed),
          ]),
          dd([
            .text(
              'The Dart SDK maintains compatibility for deprecated code, '
              'with a warning. Deprecations are then completely removed in '
              'a later release, breaking any code that '
              'relies on the previous behavior.',
            ),
          ]),
          dt([
            .text('Experimental '),
            _TagLabel(ChangelogTag.experimental),
          ]),
          dd([
            .text(
              'Part of the release but not yet treated as stable in '
              'the SDK and can break from one version to another.',
            ),
          ]),
        ]),
      ],
    );
  }
}

/// A private helper component to render a consistent tag label.
class _TagLabel extends StatelessComponent {
  const _TagLabel(this.tag);

  /// The tag definition containing the ID (for CSS class) and label text.
  final ChangelogTag tag;

  @override
  Component build(BuildContext context) {
    return span(classes: 'tag-label ${tag.id}-tag', [
      .text(tag.label),
    ]);
  }
}
