// ignore_for_file: prefer_single_quotes, prefer_typing_uninitialized_variables, prefer_adjacent_string_concatenation, avoid_init_to_null

import 'package:test/test.dart';

void main() {
  test('number-conversion', () {
    // #docregion number-conversion
    // String -> int
    var one = int.parse('1');
    assert(one == 1);

    // String -> double
    var onePointOne = double.parse('1.1');
    assert(onePointOne == 1.1);

    // int -> String
    String oneAsString = 1.toString();
    assert(oneAsString == '1');

    // double -> String
    String piAsString = 3.14159.toStringAsFixed(2);
    assert(piAsString == '3.14');
    // #enddocregion number-conversion
  });

  test('bit-shifting', () {
    // #docregion bit-shifting
    assert((3 << 1) == 6); // 0011 << 1 == 0110
    assert((3 | 4) == 7); // 0011 | 0100 == 0111
    assert((3 & 4) == 0); // 0011 & 0100 == 0000
    // #enddocregion bit-shifting
  });

  test('string-interpolation', () {
    // #docregion string-interpolation
    var s = 'string interpolation';

    assert('Dart has $s, which is very handy.' ==
        'Dart has string interpolation, '
            'which is very handy.');
    assert('That deserves all caps. '
            '${s.toUpperCase()} is very handy!' ==
        'That deserves all caps. '
            'STRING INTERPOLATION is very handy!');
    // #enddocregion string-interpolation
  });

  test('adjacent-string-literals', () {
    // #docregion adjacent-string-literals
    var s1 = 'String '
        'concatenation'
        " works even over line breaks.";
    assert(s1 ==
        'String concatenation works even over '
            'line breaks.');

    var s2 = 'The + operator ' + 'works, as well.';
    assert(s2 == 'The + operator works, as well.');
    // #enddocregion adjacent-string-literals
  });

  test('no-truthy', () {
    // #docregion no-truthy
    // Check for an empty string.
    var fullName = '';
    assert(fullName.isEmpty);

    // Check for zero.
    var hitPoints = 0;
    assert(hitPoints <= 0);

    // Check for null.
    var unicorn = null;
    assert(unicorn == null);

    // Check for NaN.
    var iMeantToDoThis = 0 / 0;
    assert(iMeantToDoThis.isNaN);
    // #enddocregion no-truthy
  });

  test('list-indexing', () {
    // #docregion list-indexing
    var list = [1, 2, 3];
    assert(list.length == 3);
    assert(list[1] == 2);

    list[1] = 1;
    assert(list[1] == 1);
    // #enddocregion list-indexing
  });

  test('list-spread', () {
    // #docregion list-spread
    var list = [1, 2, 3];
    var list2 = [0, ...list];
    assert(list2.length == 4);
    // #enddocregion list-spread
  });

  test('list-null-spread', () {
    List<int>? list;
    // #docregion list-null-spread
    var list2 = [0, ...?list];
    assert(list2.length == 1);
    // #enddocregion list-null-spread
  });

  test('list-if', () {
    var promoActive = true;
    // #docregion list-if
    var nav = ['Home', 'Furniture', 'Plants', if (promoActive) 'Outlet'];
    // #enddocregion list-if
    assert(nav.length == 4);
  });

  test('list-for', () {
    // #docregion list-for
    var listOfInts = [1, 2, 3];
    var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
    assert(listOfStrings[1] == '#1');
    // #enddocregion list-for
  });

  test('set-length', () {
    var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};

    // #docregion set-length
    var elements = <String>{};
    elements.add('fluorine');
    elements.addAll(halogens);
    assert(elements.length == 5);
    // #enddocregion set-length
  });

  test('map-retrieve-item', () {
    // #docregion map-retrieve-item
    var gifts = {'first': 'partridge'};
    assert(gifts['first'] == 'partridge');
    // #enddocregion map-retrieve-item
  });

  test('map-missing-key', () {
    // #docregion map-missing-key
    var gifts = {'first': 'partridge'};
    assert(gifts['fifth'] == null);
    // #enddocregion map-missing-key
  });

  test('map-length', () {
    // #docregion map-length
    var gifts = {'first': 'partridge'};
    gifts['fourth'] = 'calling birds';
    assert(gifts.length == 2);
    // #enddocregion map-length
  });
}
