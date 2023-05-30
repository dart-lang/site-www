// ignore_for_file: unrelated_type_equality_checks
import 'package:test/test.dart';
// import 'package:examples_util/print_matcher.dart' as m;

void main() {
  test('record-syntax', () {
    // #docregion record-syntax
    var record = ('first', a: 2, b: true, 'last');
    // #enddocregion record-syntax
    expect(record.$1, 'first');
    expect(record.a, 2);
    expect(record.b, true);
    expect(record.$2, 'last');
  });

  test('record-type-annotation', () {
    // #docregion record-type-annotation
    (int, int) swap((int, int) record) {
      var (a, b) = record;
      return (b, a);
    }

    // #enddocregion record-type-annotation
    expect(swap((1, 2)), (2, 1));
  });

  test('record-type-declaration', () {
    // #docregion record-type-declaration
    // Record type annotation in a variable declaration:
    (String, int) record;

    // Initialize it with a record expression:
    record = ('A string', 123);
    // #enddocregion record-type-declaration
    expect(record, ('A string', 123));
  });

  test('record-type-named-declaration', () {
    // #docregion record-type-named-declaration
    // Record type annotation in a variable declaration:
    ({int a, bool b}) record;

    // Initialize it with a record expression:
    record = (a: 123, b: true);
    // #enddocregion record-type-named-declaration
    expect(record, (a: 123, b: true));
  });

  test('record-type-mismatched-names', () {
    // #docregion record-type-mismatched-names
    ({int a, int b}) recordAB = (a: 1, b: 2);
    ({int x, int y}) recordXY = (x: 3, y: 4);

    // Compile error! These records don't have the same type.
    // recordAB = recordXY;
    // #enddocregion record-type-mismatched-names
    recordAB;
    recordXY;
  });

  test('record-type-matched-names', () {
    // #docregion record-type-matched-names
    (int a, int b) recordAB = (1, 2);
    (int x, int y) recordXY = (3, 4);

    recordAB = recordXY; // OK.
    // #enddocregion record-type-matched-names
    recordAB;
    recordXY;
  });

  test('record-getters', () {
    // #docregion record-getters
    var record = ('first', a: 2, b: true, 'last');

    print(record.$1); // Prints 'first'
    print(record.a); // Prints 2
    print(record.b); // Prints true
    print(record.$2); // Prints 'last'
    // #enddocregion record-getters
  });

  test('record-getters-two', () {
    // #docregion record-getters-two
    (num, Object) pair = (42, 'a');

    var first = pair.$1; // Static type `num`, runtime type `int`.
    var second = pair.$2; // Static type `Object`, runtime type `String`.
    // #enddocregion record-getters-two
    first;
    second;
  });

  test('record-shape', () {
    // #docregion record-shape
    (int x, int y, int z) point = (1, 2, 3);
    (int r, int g, int b) color = (1, 2, 3);

    print(point == color); // Prints 'true'.
    // #enddocregion record-shape
    expect(point, (1, 2, 3));
  });

  test('record-shape-mismatch', () {
    // #docregion record-shape-mismatch
    ({int x, int y, int z}) point = (x: 1, y: 2, z: 3);
    ({int r, int g, int b}) color = (r: 1, g: 2, b: 3);

    print(point == color); // Prints 'false'. Lint: Equals on unrelated types.
    // #enddocregion record-shape-mismatch
    point;
    color;
  });

  test('record-multiple-returns', () {
    // #docregion record-multiple-returns
    // Returns multiple values in a record:
    (String, int) userInfo(Map<String, dynamic> json) {
      return (json['name'] as String, json['age'] as int);
    }

    final json = <String, dynamic>{
      'name': 'Dash',
      'age': 10,
      'color': 'blue',
    };

    // Destructures using a record pattern:
    var (name, age) = userInfo(json);

    /* Equivalent to:
      var info = userInfo(json);
      var name = info.$1;
      var age  = info.$2;
    */
    // #enddocregion record-multiple-returns
    name;
    age;
  });
}
