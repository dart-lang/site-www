// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import 'chip.dart';
import 'search.dart';

enum RuleSetOption {
  inFlutter('Flutter'),
  inRecommended('Recommended'),
  inCore('Core');

  final String label;
  const RuleSetOption(this.label);
}

class LintInfo {
  LintInfo({
    required this.name,
    required this.hasFix,
    required this.stable,
    required this.inCore,
    required this.inRecommended,
    required this.inFlutter,
  });

  final String name;
  final bool hasFix;
  final bool stable;
  final bool inCore;
  final bool inRecommended;
  final bool inFlutter;
}

@client
class LintFilterSearchSection extends StatefulComponent {
  const LintFilterSearchSection();

  @override
  State createState() => _LintFilterSearchSectionState();
}

class _LintFilterSearchSectionState extends State<LintFilterSearchSection> {
  bool onlyFixable = false;
  bool onlyStable = false;

  RuleSetOption? selectedRuleSet;

  String searchQuery = '';

  final lintCards = <web.HTMLElement>[];
  final lintsInfo = <LintInfo>[];

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Waiting until after the frame is only needed for tests, since there
      // the cards are not pre-rendered. Does not affect the real app.
      context.binding.addPostFrameCallback(() {
        final cards = web.document
            .getElementById('lint-cards')
            ?.querySelectorAll('.card');
        if (cards == null) return;

        bool hasData(web.HTMLElement elem, String name) =>
            elem.attributes.getNamedItem('data-$name')?.value == 'true';

        for (var i = 0; i < cards.length; i++) {
          final card = cards.item(i) as web.HTMLElement;
          lintCards.add(card);

          final lintName = card.id;
          if (lintName.isEmpty) return;

          lintsInfo.add(
            LintInfo(
              name: lintName,
              hasFix: hasData(card, 'has-fix'),
              stable: hasData(card, 'stable'),
              inCore: hasData(card, 'in-core'),
              inRecommended: hasData(card, 'in-recommended'),
              inFlutter: hasData(card, 'in-flutter'),
            ),
          );
        }
      });
    }
  }

  /// Update the filter state and re-evaluate which lints to show.
  ///
  /// Use like the `setState` method by passing a callback that updates
  /// the relevant state variables.
  ///
  /// Example:
  ///
  /// ```dart
  /// updateFilters(() {
  ///   onlyFixable = !onlyFixable;
  /// });
  /// ```
  void updateFilters(void Function() callback) {
    setState(() {
      callback();
    });

    final lintsToShow = <String>{};

    for (final lint in lintsInfo) {
      final lintName = lint.name;

      if (!lintName.contains(searchQuery.trim().toLowerCase())) continue;
      if (onlyFixable && !lint.hasFix) continue;
      if (onlyStable && !lint.stable) continue;
      switch (selectedRuleSet) {
        case RuleSetOption.inFlutter:
          if (!lint.inFlutter) continue;
        case RuleSetOption.inRecommended:
          if (!lint.inRecommended) continue;
        case RuleSetOption.inCore:
          if (!lint.inCore) continue;
        case null:
          // No rule set filter applied.
          break;
      }
      lintsToShow.add(lintName);
    }

    for (final card in lintCards) {
      if (lintsToShow.contains(card.id)) {
        card.classList.remove('hidden');
      } else {
        card.classList.add('hidden');
      }
    }
  }

  @override
  Component build(BuildContext context) {
    return section(
      id: 'filter-and-search',
      classes: kIsWeb ? '' : 'hidden',
      [
        div(classes: 'search-row', [
          SearchBar(
            placeholder: 'Search rules...',
            label: 'Search linter rules by their name.',
            value: searchQuery,
            onInput: (value) {
              updateFilters(() {
                searchQuery = value;
              });
            },
          ),
        ]),
        ChipSet(
          [
            SelectChip<RuleSetOption>(
              label: selectedRuleSet?.label ?? 'Rule set',
              menuId: 'rule-set-menu',
              menuItems: [
                SelectMenuItem(
                  icon: 'flutter',
                  label: RuleSetOption.inFlutter.label,
                  value: RuleSetOption.inFlutter,
                ),
                SelectMenuItem(
                  icon: 'thumb_up',
                  label: RuleSetOption.inRecommended.label,
                  value: RuleSetOption.inRecommended,
                ),
                SelectMenuItem(
                  icon: 'circles',
                  label: RuleSetOption.inCore.label,
                  value: RuleSetOption.inCore,
                ),
              ],
              selectedValue: selectedRuleSet,
              onSelect: (ruleSet) {
                updateFilters(() {
                  selectedRuleSet = ruleSet;
                });
              },
            ),
            FilterChip(
              label: 'Fix available',
              ariaLabel: 'Show only lints with a fix available',
              selected: onlyFixable,
              onTap: () {
                updateFilters(() {
                  onlyFixable = !onlyFixable;
                });
              },
            ),
            FilterChip(
              label: 'Stable only',
              ariaLabel: 'Show only released, stable rules',
              selected: onlyStable,
              onTap: () {
                updateFilters(() {
                  onlyStable = !onlyStable;
                });
              },
            ),
          ],
          onReset: () {
            updateFilters(() {
              onlyFixable = false;
              onlyStable = false;
              selectedRuleSet = null;
              searchQuery = '';
            });
          },
        ),
      ],
    );
  }
}
