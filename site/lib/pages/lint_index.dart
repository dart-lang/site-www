import 'package:jaspr/jaspr.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/chip.dart';
import '../components/material_icon.dart';
import '../components/search.dart';
import '../lints.dart';
import '../markdown/markdown_parser.dart';
import '../util.dart';

class LintRuleIndex extends StatelessComponent {
  const LintRuleIndex();

  @override
  Iterable<Component> build(BuildContext context) {
    final linterRules = readAndLoadLints();
    return [
      const _LintFilterSearchSection(),
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
    ];
  }
}

class _LintFilterSearchSection extends StatelessComponent {
  const _LintFilterSearchSection();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(
      id: 'filter-and-search',
      classes: 'hidden',
      [
        div(classes: 'search-row', [
          const SearchBar(
            placeholder: 'Search rules...',
            label: 'Search linter rules by their name.',
          ),
        ]),
        const ChipSet(
          [
            SelectChip(
              label: 'Rule set',
              menuId: 'rule-set-menu',
              dataTitle: 'Rule set',
              menuItems: [
                SelectMenuItem(
                  dataFilter: 'inFlutter',
                  icon: 'flutter',
                  label: 'Flutter',
                ),
                SelectMenuItem(
                  dataFilter: 'inRecommended',
                  icon: 'thumb_up',
                  label: 'Recommended',
                ),
                SelectMenuItem(
                  dataFilter: 'inCore',
                  icon: 'circles',
                  label: 'Core',
                ),
              ],
            ),
            FilterChip(
              label: 'Fix available',
              dataFilter: 'hasFix',
              ariaLabel: 'Show only lints with a fix available',
            ),
            FilterChip(
              label: 'Stable only',
              dataFilter: 'stable',
              ariaLabel: 'Show only released, stable rules',
            ),
          ],
          resettable: true,
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
  Iterable<Component> build(BuildContext context) sync* {
    final lintId = lint.name.toLowerCase();

    final attributes = <String, String>{
      if (lint.state == 'stable' && !lint.sinceDartSdk.contains('wip'))
        'data-stable': 'true',
      if (lint.fixStatus == 'hasFix') 'data-has-fix': 'true',
      if (lint.lintSets.contains('core')) 'data-in-core': 'true',
      if (lint.lintSets.contains('recommended')) 'data-in-recommended': 'true',
      if (lint.lintSets.contains('flutter')) 'data-in-flutter': 'true',
    };

    yield Card(
      id: lintId,
      outlined: true,
      attributes: attributes,
      header: [
        header(
          id: lintId,
          classes: 'card-title',
          underscoreBreaker(lintId),
        ),
      ],
      content: [
        DashMarkdown(content: lint.description, inline: true),
      ],
      actions: CardActions(
        leading: _statusIcons,
        trailing: [
          Button.text(
            href: '/tools/linter-rules/${lint.name}',
            style: ButtonStyle.outlined,
            title: 'Learn more about this lint and when to enable it.',
            content: 'Learn more',
          ),
          Button.text(
            style: ButtonStyle.filled,
            classes: ['copy-button', 'hidden'],
            title: 'Copy ${lint.name} to your clipboard.',
            content: 'Copy',
          ),
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
