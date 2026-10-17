// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_dev_site/src/util.dart';
import 'package:test/test.dart';

void main() {
  group('lintMatchesQuery', () {
    const name = 'directives_ordering';
    const description =
        'Adhere to Effective Dart Guide directives sorting conventions.';

    test('empty query matches everything', () {
      expect(
        lintMatchesQuery(name: name, description: description, query: ''),
        isTrue,
      );
    });

    test('matches partial lint name', () {
      expect(
        lintMatchesQuery(
          name: name,
          description: description,
          query: 'directives',
        ),
        isTrue,
      );
    });

    test('treats spaces as underscores in the name', () {
      expect(
        lintMatchesQuery(
          name: name,
          description: description,
          query: 'directives or',
        ),
        isTrue,
      );
      expect(
        lintMatchesQuery(
          name: name,
          description: description,
          query: 'directives ordering',
        ),
        isTrue,
      );
    });

    test('matches description text', () {
      expect(
        lintMatchesQuery(
          name: name,
          description: description,
          query: 'Effective Dart',
        ),
        isTrue,
      );
    });

    test('returns false when nothing matches', () {
      expect(
        lintMatchesQuery(name: name, description: description, query: 'zzzz'),
        isFalse,
      );
    });
  });
}
