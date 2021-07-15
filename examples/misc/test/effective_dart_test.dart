import 'package:test/test.dart';

void main() {
  test('sublist', () {
    // #docregion param-range
    expect([0, 1, 2, 3].sublist(1, 3), /**/ [1, 2]);
    // #enddocregion param-range
  });

  test('substring', () {
    // #docregion param-range
    expect('abcd'.substring(1, 3), /**/ 'bc');
    // #enddocregion param-range
  });

  group('List.toList() and List.from()', () {
    test('basic', () {
      var iterable = [1, 2];
      // #docregion list-from-1
      var copy1 = iterable.toList();
      var copy2 = List.from(iterable);
      // #enddocregion list-from-1
      expect(copy1, orderedEquals([1, 2]));
      expect(copy2, orderedEquals([1, 2]));
    });

    test('runtimeType', () {
      expect(() {
        // #docregion list-from-good
        // Creates a List<int>:
        var iterable = [1, 2, 3];

        // Prints "List<int>":
        print(iterable.toList().runtimeType);
        // #enddocregion list-from-good
      }, prints('List<int>\n'));

      expect(() {
        // #docregion list-from-bad
        // Creates a List<int>:
        var iterable = [1, 2, 3];

        // Prints "List<dynamic>":
        print(List.from(iterable).runtimeType);
        // #enddocregion list-from-bad
      }, prints('List<dynamic>\n'));
    });

    test('List.from<int>() from List<num>', () {
      // #docregion list-from-3
      var numbers = [1, 2.3, 4]; // List<num>.
      numbers.removeAt(1); // Now it only contains integers.
      var ints = List<int>.from(numbers);
      // #enddocregion list-from-3

      expect(ints, orderedEquals([1, 4]));
    });
  });

  test('whereType usage_good', () {
    // #docregion whereType
    var objects = [1, 'a', 2, 'b', 3];
    var ints = objects.whereType<int>();
    // #enddocregion whereType
    expect(ints, TypeMatcher<Iterable<int>>());
    expect(ints, [1, 2, 3]);
  });
}
