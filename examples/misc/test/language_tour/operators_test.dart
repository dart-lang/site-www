// ignore_for_file: dead_code, prefer_if_null_operators

import 'package:test/test.dart';
import 'package:examples/language_tour/classes/employee.dart' as employee;
import 'package:examples_util/print_matcher.dart' as m;

class T {}

void main() {
  test('expressions', () {
    var a = 1, b = 2, c = true;
    final expressions = [
      // #docregion expressions
      a++,
      a + b,
      a = b,
      a == b,
      c ? a : b,
      a is T,
      // #enddocregion expressions
    ];
    expect(expressions, [1, 4, 2, true, 2, false]);
  });

  test('precedence', () {
    int d = 1, i = 1, n = 1;
    // #docregion precedence
    // Parentheses improve readability.
    if ((n % i == 0) && (d % i == 0)) {/*-...-*/}

    // Harder to read, but equivalent.
    if (n % i == 0 && d % i == 0) {/*-...-*/}
    // #enddocregion precedence
  });

  test('arithmetic', () {
    // #docregion arithmetic
    assert(2 + 3 == 5);
    assert(2 - 3 == -1);
    assert(2 * 3 == 6);
    assert(5 / 2 == 2.5); // Result is a double
    assert(5 ~/ 2 == 2); // Result is an int
    assert(5 % 2 == 1); // Remainder

    assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');
    // #enddocregion arithmetic
  });

  test('increment-decrement', () {
    // #docregion increment-decrement
    int a;
    int b;

    a = 0;
    b = ++a; // Increment a before b gets its value.
    assert(a == b); // 1 == 1

    a = 0;
    b = a++; // Increment a after b gets its value.
    assert(a != b); // 1 != 0

    a = 0;
    b = --a; // Decrement a before b gets its value.
    assert(a == b); // -1 == -1

    a = 0;
    b = a--; // Decrement a after b gets its value.
    assert(a != b); // -1 != 0
    // #enddocregion increment-decrement
  });

  test('relational', () {
    // #docregion relational
    assert(2 == 2);
    assert(2 != 3);
    assert(3 > 2);
    assert(2 < 3);
    assert(3 >= 3);
    assert(2 <= 3);
    // #enddocregion relational
  });

  test('is-vs-as', () {
    expect(employee.main,
        m.prints(['in Person', 'in Employee', "Instance of 'Employee'"]));
  });

  group('`=` vs `??=`:', () {
    // #docregion assignment-gist-main-body
    void assignValues(int? a, int? b, int value) {
      print('Initially: a == $a, b == $b');
      // #docregion assignment
      // Assign value to a
      a = value;
      // Assign value to b if b is null; otherwise, b stays the same
      b ??= value;
      // #enddocregion assignment
      print('After: a == $a, b == $b');
    }

    // #enddocregion assignment-gist-main-body
    /*
    // #docregion assignment-gist-main-body
    main() {
    // #enddocregion assignment-gist-main-body
    */

    void testInitiallyNonNull() {
      // #docregion assignment-gist-main-body
      assignValues(0, 0, 1);
      // #enddocregion assignment-gist-main-body
    }

    void testNull() {
      // #docregion assignment-gist-main-body
      assignValues(null, null, 1);
      // #enddocregion assignment-gist-main-body
    }

    test('var initially non-null', () {
      expect(
          testInitiallyNonNull,
          m.prints([
            'Initially: a == 0, b == 0',
            'After: a == 1, b == 0',
          ]));
    });

    test('var initially non-null', () {
      expect(
          testNull,
          m.prints([
            'Initially: a == null, b == null',
            'After: a == 1, b == 1',
          ]));
    });

    /*
    // #docregion assignment-gist-main-body
    }
    // #enddocregion assignment-gist-main-body
    */
  });

  test('op-assign', () {
    // #docregion op-assign
    var a = 2; // Assign using =
    a *= 3; // Assign and multiply: a = a * 3
    assert(a == 6);
    // #enddocregion op-assign
  });

  test('op-bitwise', () {
    // #docregion op-bitwise
    final value = 0x22;
    final bitmask = 0x0f;

    assert((value & bitmask) == 0x02); // AND
    assert((value & ~bitmask) == 0x20); // AND NOT
    assert((value | bitmask) == 0x2f); // OR
    assert((value ^ bitmask) == 0x2d); // XOR

    assert((value << 4) == 0x220); // Shift left
    assert((value >> 4) == 0x02); // Shift right

    // Shift right example that results in different behavior on web
    // because the operand value changes when masked to 32 bits:
    assert((-value >> 4) == -0x03);

    assert((value >>> 4) == 0x02); // Unsigned shift right
    assert((-value >>> 4) > 0); // Unsigned shift right
    // #enddocregion op-bitwise
  }, testOn: 'vm');

  test('if-null', () {
    // #docregion if-null
    String playerName1(String? name) => name ?? 'Guest';
    // #enddocregion if-null

    // #docregion if-null-alt
    // Slightly longer version uses ?: operator.
    String playerName2(String? name) => name != null ? name : 'Guest';

    // Very long version uses if-else statement.
    String playerName3(String? name) {
      if (name != null) {
        return name;
      } else {
        return 'Guest';
      }
    }

    // #enddocregion if-null-alt
    final funcs = [playerName1, playerName2, playerName3];
    expect(funcs.map((f) => f(null)), List.filled(3, 'Guest'));
    expect(funcs.map((f) => f('Alice')), List.filled(3, 'Alice'));
  });
}
