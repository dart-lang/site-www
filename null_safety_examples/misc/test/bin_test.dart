import 'dart:io';

import 'package:test/test.dart';

import '../bin/cat_no_hash.dart' as cat_no_hash;

void main() {
  const pathToQuotes = 'test_data/quote.txt';

  test('cat_no_hash', () {
    final quotes = File(pathToQuotes);
    expect(quotes.readAsStringSync(), contains('#'));

    expect(
        () => cat_no_hash.main([quotes.path]),
        prints(
          isNot(contains('#')),
        ));
  });
}
