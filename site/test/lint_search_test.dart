// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart';
import 'package:test/test.dart';

void main() {
  group('lintMatchesQuery', () {
    const name = 'directives_ordering';
    const description =
        'Adhere to Effective Dart Guide directives sorting conventions.';

    bool matches(String query) =>
        lintMatchesQuery(name: name, description: description, query: query);

    test('empty query matches everything', () {
      expect(matches(''), isTrue);
      expect(matches('   '), isTrue);
    });

    test('matches partial lint name', () {
      expect(matches('directives'), isTrue);
      expect(matches('ordering'), isTrue);
    });

    test('treats spaces as underscores in the name', () {
      expect(matches('directives or'), isTrue);
      expect(matches('directives ordering'), isTrue);
    });

    test('matches description text', () {
      expect(matches('Effective Dart'), isTrue);
      expect(matches('sorting conventions'), isTrue);
    });

    test('ignores case', () {
      expect(matches('DIRECTIVES_Ordering'), isTrue);
      expect(matches('effective dart GUIDE'), isTrue);
    });

    test('ignores surrounding and repeated whitespace', () {
      expect(matches('  directives   ordering  '), isTrue);
      expect(matches(' effective \t dart '), isTrue);
    });

    test('returns false when nothing matches', () {
      expect(matches('zzzz'), isFalse);
      expect(matches('ordering directives'), isFalse);
    });
  });
}
