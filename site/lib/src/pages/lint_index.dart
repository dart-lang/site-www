// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';

import '../components/common/button.dart';
import '../components/common/card.dart';
import '../components/common/client/copy_button.dart';
import '../components/common/material_icon.dart';
import '../components/pages/lint_filter_search_section.dart';
import '../markdown/markdown_parser.dart';
import '../models/lints.dart';
import '../util.dart';

class LintRuleIndex extends StatelessComponent {
  const LintRuleIndex([this.linterRules]);

  /// The list of linter rules to display. If `null`, the rules will be
  /// loaded from the `src/data/linter_rules.json` file.
  final List<LintDetails>? linterRules;

  @override
  Component build(BuildContext context) {
    final linterRules = this.linterRules ?? readAndLoadLints();
    return Component.fragment(
      [
        const LintFilterSearchSection(),
        section(
          classes: 'content-search-results',
          [
            div(
              id: 'lint-cards',
              classes: 'card-grid',
              [
                for (final lint in linterRules)
                  if (lint.state != 'internal') _LintRuleCard(lint: lint),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LintRuleCard extends StatelessComponent {
  const _LintRuleCard({
    required this.lint,
  });

  final LintDetails lint;

  @override
  Component build(BuildContext context) {
    final lintId = lint.name.toLowerCase();

    final attributes = <String, String>{
      if (lint.state == 'stable' && !lint.sinceDartSdk.contains('wip'))
        'data-stable': 'true',
      if (lint.fixStatus == 'hasFix') 'data-has-fix': 'true',
      if (lint.lintSets.contains('core')) 'data-in-core': 'true',
      if (lint.lintSets.contains('recommended')) 'data-in-recommended': 'true',
      if (lint.lintSets.contains('flutter')) 'data-in-flutter': 'true',
    };

    return Card(
      id: lintId,
      outlined: true,
      attributes: attributes,
      header: [
        header(
          id: lintId,
          classes: 'card-title',
          splitByUnderscore(lintId),
        ),
      ],
      content: [
        if (lint.description.isNotEmpty)
          DashMarkdown(content: lint.description, inline: true),
      ],
      actions: CardActions(
        leading: _statusIcons,
        trailing: [
          Button(
            href: '/tools/linter-rules/${lint.name}',
            style: ButtonStyle.outlined,
            title: 'Learn more about this lint and when to enable it.',
            content: 'Learn more',
          ),
          CopyButton(toCopy: lint.name, buttonText: 'Copy name'),
        ],
      ),
    );
  }

  List<Component> get _statusIcons => [
    ?switch (lint.state) {
      'removed' => const MaterialIcon(
        'error',
        title: 'Lint has been removed.',
        classes: ['removed-lints'],
      ),
      'deprecated' => const MaterialIcon(
        'report',
        title: 'Lint is deprecated.',
        classes: ['deprecated-lints'],
      ),
      'experimental' => const MaterialIcon(
        'science',
        title: 'Lint is experimental.',
        classes: ['experimental-lints'],
      ),
      _ when lint.sinceDartSdk.contains('wip') => const MaterialIcon(
        'pending',
        title: 'Lint is unreleased.',
        classes: ['wip-lints'],
      ),
      _ => null,
    },

    if (lint.fixStatus == 'hasFix')
      const MaterialIcon(
        'build',
        title: 'Lint has a quick fix.',
        classes: ['has-fix'],
      ),

    if (lint.lintSets.contains('core'))
      const MaterialIcon(
        'circles',
        title: 'Lint is included in the core lint set.',
      ),

    if (lint.lintSets.contains('recommended'))
      const MaterialIcon(
        'thumb_up',
        title: 'Lint is included in the recommended lint set.',
      ),

    if (lint.lintSets.contains('flutter'))
      const MaterialIcon(
        'flutter',
        title: 'Lint is included in the Flutter lint set.',
      ),
  ];
}
