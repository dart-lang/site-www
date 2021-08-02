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

    test('firstWhere_long_example', () {
      // #docregion first-where-long
      bool predicate(String element) {
        return element.length > 5;
      }

      void main() {
        const items = ['Salad', 'Popcorn', 'Toast', 'Lasagne'];

        // You can find with a simple expression:
        var element1 = items.firstWhere((element) => element.length > 5);
        print(element1);

        // Or try using a function block:
        var element2 = items.firstWhere((element) {
          return element.length > 5;
        });
        print(element2);

        // Or even pass in a function reference:
        var element3 = items.firstWhere(predicate);
        print(element3);

        // You can also use an `orElse` function in case no value is found!
        var element4 = items.firstWhere(
          (element) => element.length > 10,
          orElse: () => 'None!',
        );
        print(element4);
      }
      // #enddocregion first-where-long

      expect(
          main,
          prints(allOf(
              stringContainsInOrder(
                  ['Popcorn\n', 'Popcorn\n', 'Popcorn\n', 'None!\n']),
              isNot(contains('Lasagne')),
              isNot(contains('Salad')),
              isNot(contains('Toast')))));
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
      const numbers = [1, 2, 3, -1, 4, 5];
      // #docregion takewhile
      var numbersUntilNegative =
          numbers.takeWhile((number) => !number.isNegative);
      // #enddocregion takewhile
      expect(numbersUntilNegative, [1, 2, 3]);
    });

    test('takeWhile_example_long', () {
      // #docregion take-while-long
      void main() {
        const numbers = [1, 3, -2, 0, 4, 5];

        var numbersUntilZero = numbers.takeWhile((number) => number != 0);
        print('Numbers until 0: $numbersUntilZero');

        var numbersStartingAtZero = numbers.skipWhile((number) => number != 0);
        print('Numbers starting at 0: $numbersStartingAtZero');
      }
      // #enddocregion take-while-long

      expect(main, [1, 2, 3]);
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

    test('for_in_loop', () {
      // #docregion for-in
      void main() {
        const iterable = ['Salad', 'Popcorn', 'Toast'];
        for (var element in iterable) {
          print(element);
        }
      }
      // #enddocregion for-in

      expect(main, prints('Salad\nPopcorn\nToast\n'));
    });

    test('first_and_last', () {
      // #docregion first-last
      void main() {
        Iterable<String> iterable = const ['Salad', 'Popcorn', 'Toast'];
        print('The first element is ${iterable.first}');
        print('The last element is ${iterable.last}');
      }
      // #enddocregion first-last

      expect(
          main,
          prints(allOf(contains('Salad'), contains('Toast'),
              isNot(contains('Popcorn')))));
    });

    test('numbers_where', () {
      // #docregion numbers-where
      void main() {
        var evenNumbers = const [1, -2, 3, 42].where((number) => number.isEven);

        for (var number in evenNumbers) {
          print('$number is even.');
        }

        if (evenNumbers.any((number) => number.isNegative)) {
          print('evenNumbers contains negative numbers.');
        }

        // If no element satisfies the predicate, the output is empty.
        var largeNumbers = evenNumbers.where((number) => number > 1000);
        if (largeNumbers.isEmpty) {
          print('largeNumbers is empty!');
        }
      }
      // #enddocregion numbers-where

      expect(
          main,
          prints(allOf(
              isNot(contains('1 is even.\n')),
              contains('-2 is even.\n'),
              contains('42 is even.\n'),
              isNot(contains('3 is even')),
              contains('evenNumbers contains negative'),
              contains('largeNumbers is empty'))));
    });

    test('numbers_by_two', () {
      // #docregion numbers-by-two
      void main() {
        var numbersByTwo = const [1, -2, 3, 42].map((number) => number * 2);
        print('Numbers: $numbersByTwo');
      }
      // #enddocregion numbers-by-two

      expect(main, prints('Numbers: (2, -4, 6, 84)\n'));
    });
  });
}
