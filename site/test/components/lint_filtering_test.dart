@TestOn('browser')
library;

import 'package:dart_dev_site/src/components/common/chip.dart';
import 'package:dart_dev_site/src/models/lints.dart';
import 'package:dart_dev_site/src/pages/lint_index.dart';
import 'package:jaspr_test/browser_test.dart';
import 'package:universal_web/web.dart' as web;

final testLinterRules = <LintDetails>[
  LintDetails({
    'name': 'fixable_lint',
    'description': '',
    'categories': ['style'],
    'state': 'stable',
    'incompatible': [],
    'sets': [],
    'fixStatus': 'hasFix',
    'sinceDartSdk': '2.0',
  }),
  LintDetails({
    'name': 'non_fixable_lint',
    'description': '',
    'categories': ['effectiveDart'],
    'state': 'stable',
    'incompatible': [],
    'sets': [],
    'fixStatus': 'noFix',
    'sinceDartSdk': '2.0',
  }),
  LintDetails({
    'name': 'core_lint',
    'description': '',
    'categories': [],
    'state': 'stable',
    'incompatible': [],
    'sets': ['core'],
    'fixStatus': 'hasFix',
    'sinceDartSdk': '2.0',
  }),
  LintDetails({
    'name': 'experimental_lint',
    'description': '',
    'categories': [],
    'state': 'experimental',
    'incompatible': [],
    'sets': [],
    'fixStatus': 'hasFix',
    'sinceDartSdk': '2.0',
  }),
];

void main() {
  group('lint filtering', () {
    void expectVisibleLength(int length) {
      final cards = web.document
          .getElementById('lint-cards')
          ?.querySelectorAll('.card:not(.hidden)');
      expect(cards?.length, length);
    }

    void expectCardVisible(String lintName, bool isVisible) {
      final card = web.document
          .getElementById('lint-cards')
          ?.querySelector('#${lintName.toLowerCase()}');
      expect(card, isNotNull, reason: 'Card for $lintName should exist');
      expect(
        card!.classList.contains('hidden'),
        !isVisible,
        reason: 'Card is ${isVisible ? 'not ' : ''}visible',
      );
    }

    testBrowser('shows all lints by default', (tester) async {
      tester.pumpComponent(LintRuleIndex(testLinterRules));

      final cards = web.document
          .getElementById('lint-cards')
          ?.querySelectorAll('.card');

      expect(cards?.length, equals(4));
      expectVisibleLength(4);
    });

    testBrowser('filters fixable lints', (tester) async {
      tester.pumpComponent(LintRuleIndex(testLinterRules));

      expectVisibleLength(4);

      await tester.click(find.componentWithText(FilterChip, 'Fix available'));

      expectVisibleLength(3);
      expectCardVisible('fixable_lint', true);
      expectCardVisible('non_fixable_lint', false);
    });

    testBrowser('filters stable lints', (tester) async {
      tester.pumpComponent(LintRuleIndex(testLinterRules));

      expectVisibleLength(4);

      await tester.click(find.componentWithText(FilterChip, 'Stable only'));

      expectVisibleLength(3);
      expectCardVisible('core_lint', true);
      expectCardVisible('experimental_lint', false);
    });

    testBrowser('filters core lints', (tester) async {
      tester.pumpComponent(LintRuleIndex(testLinterRules));

      expectVisibleLength(4);

      // Opens the menu
      await tester.click(
        find.ancestor(of: find.text('Rule set'), matching: find.tag('button')),
      );
      // Selects the "Core" option
      await tester.click(
        find.ancestor(of: find.text('Core'), matching: find.tag('button')),
      );

      expectVisibleLength(1);
      expectCardVisible('core_lint', true);
      expectCardVisible('fixable_lint', false);
    });

    testBrowser('filters lints by search query', (tester) async {
      tester.pumpComponent(LintRuleIndex(testLinterRules));

      expectVisibleLength(4);

      final searchInput = tester.findNode<web.HTMLInputElement>(
        find.tag('input'),
      )!;
      searchInput.value = 'fixable';
      searchInput.dispatchEvent(web.InputEvent('input'));

      expectVisibleLength(2);
      expectCardVisible('fixable_lint', true);
      expectCardVisible('non_fixable_lint', true);
      expectCardVisible('core_lint', false);
    });
  });
}
