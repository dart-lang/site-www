@TestOn('browser')
library;

import 'package:dart_dev_site/src/pages/glossary.dart';
import 'package:jaspr_test/browser_test.dart';
import 'package:universal_web/web.dart' as web;

final testGlossaryEntries = <Object>[
  {
    'term': 'Test Term',
    'short_description': '',
    'related_links': <String>[],
    'labels': ['label1', 'label2'],
    'alternate': ['Alternate Term'],
  },
  {
    'term': 'Another Term',
    'short_description': '',
    'related_links': <String>[],
    'labels': ['label3'],
    'alternate': <String>[],
  },
  {
    'term': 'Yet Another Term',
    'short_description': '',
    'related_links': <String>[],
    'labels': ['label4'],
    'alternate': <String>[],
  },
];

void main() {
  group('glossary filtering', () {
    Future<void> enterSearchQuery(BrowserTester tester, String query) async {
      final searchInput = tester.findNode<web.HTMLInputElement>(
        find.tag('input'),
      )!;
      searchInput.value = query;
      searchInput.dispatchEvent(web.InputEvent('input'));

      await pumpEventQueue();
    }

    void expectVisibleLength(int length) {
      final cards = web.document
          .getElementById('content-search-results')
          ?.querySelectorAll('.card:not(.hidden)');
      expect(cards?.length, length);
    }

    void expectCardVisible(String entryId, bool isVisible) {
      final card = web.document
          .getElementById('content-search-results')
          ?.querySelector('#${entryId.toLowerCase()}');
      expect(card, isNotNull, reason: 'Card for $entryId should exist');
      expect(
        card!.classList.contains('hidden'),
        !isVisible,
        reason: 'Card is ${isVisible ? 'not ' : ''}visible',
      );
    }

    testBrowser('shows all entries by default', (tester) async {
      tester.pumpComponent(GlossaryIndex(testGlossaryEntries));

      final cards = web.document
          .getElementById('content-search-results')
          ?.querySelectorAll('.card');

      expect(cards?.length, equals(3));
      expectVisibleLength(3);
    });

    testBrowser('filters by partial term', (tester) async {
      tester.pumpComponent(GlossaryIndex(testGlossaryEntries));

      expectVisibleLength(3);

      await enterSearchQuery(tester, 'Test');

      expectVisibleLength(1);
      expectCardVisible('test-term', true);
      expectCardVisible('another-term', false);

      await enterSearchQuery(tester, 'Another');

      expectVisibleLength(2);
      expectCardVisible('test-term', false);
      expectCardVisible('another-term', true);
      expectCardVisible('yet-another-term', true);
    });

    testBrowser('no results on unknown query', (tester) async {
      tester.pumpComponent(GlossaryIndex(testGlossaryEntries));

      expectVisibleLength(3);

      await enterSearchQuery(tester, 'Unknown');

      expectVisibleLength(0);
    });

    testBrowser('filters by full alternate term', (tester) async {
      tester.pumpComponent(GlossaryIndex(testGlossaryEntries));

      expectVisibleLength(3);

      await enterSearchQuery(tester, 'Alternate Term');

      expectVisibleLength(1);
      expectCardVisible('test-term', true);
      expectCardVisible('another-term', false);
      expectCardVisible('yet-another-term', false);

      await enterSearchQuery(tester, 'Alternate');

      expectVisibleLength(0);
    });
  });
}
