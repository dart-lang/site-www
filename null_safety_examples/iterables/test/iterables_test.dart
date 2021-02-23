import 'package:test/test.dart';

void main() {
  group('iterables codelab', () {
    test('any_example', () {
      void any(Iterable<String> items, Function(String) print) {
        // #docregion any-false
        if (items.any((element) => element.contains('Z'))) {
          print('At least one element contains "Z"');
        } else {
          print('No element contains "Z"');
        }
        // #enddocregion any-false
      }

      var items = ['Zoo', 'Home'];
      any(items, (output) {
        expect(output, 'At least one element contains "Z"');
      });

      items = ['Home'];
      any(items, (output) {
        expect(output, 'No element contains "Z"');
      });
    });

    test('every_example', () {
      bool bad(Iterable<String> items) {
        // #docregion every-bad
        for (var item in items) {
          if (item.length < 5) {
            return false;
          }
        }
        return true;
        // #enddocregion every-bad
      }

      bool good(Iterable<String> items) {
        // #docregion every-good
        return items.every((element) => element.length >= 5);
        // #enddocregion every-good
      }

      expect(bad(['12345']), true);
      expect(bad(['1234']), false);
      expect(good(['12345']), true);
      expect(good(['1234']), false);
    });

    test('firstWhere_example', () {
      final iterable = ['a', '123456', 'abcdef'];
      // #docregion firstwhere
      String element = iterable.firstWhere((element) => element.length > 5);
      // #enddocregion firstwhere
      expect(element, '123456');
    });

    test('iterable_example', () {
      // #docregion iterable
      // #docregion iterable-elementat
      Iterable<int> iterable = [1, 2, 3];
      // #enddocregion iterable
      int value = iterable.elementAt(1);
      // #enddocregion iterable-elementat
      expect(value, 2);
    });

    test('map_int_example', () {
      final numbers = [1, 2, 3];
      // #docregion map-int
      Iterable<int> output = numbers.map((number) => number * 10);
      // #enddocregion map-int
      expect(output, [10, 20, 30]);
    });

    test('map_string_example', () {
      final numbers = [1, 2, 3];
      // #docregion map-string
      Iterable<String> output = numbers.map((number) => number.toString());
      // #enddocregion map-string
      expect(output, ['1', '2', '3']);
    });

    test('takeWhile_example', () {
      final numbers = [1, 2, 3, -1, 4, 5];
      // #docregion takewhile
      var numbersUntilNegative =
          numbers.takeWhile((number) => !number.isNegative);
      // #enddocregion takewhile
      expect(numbersUntilNegative, [1, 2, 3]);
    });

    test('where_example', () {
      final numbers = [1, 2, 3, 4];
      // #docregion where
      // #docregion where-for
      var evenNumbers = numbers.where((number) => number.isEven);
      // #enddocregion where
      for (var number in evenNumbers) {
        print('$number is even');
      }
      // #enddocregion where-for
      expect(evenNumbers, [2, 4]);
    });
  });
}
