// ignore_for_file: unused_local_variable
import 'package:test/test.dart';

import 'package:type_system_examples/animal.dart';

Matcher _throwsA<T>(String msg) => throwsA(
  allOf(TypeMatcher<T>(), predicate((e) => e.toString().contains(msg))),
);

void main() {
  test('opening example', () {
    // #docregion opening-example
    void printInts(List<int> a) => print(a);

    void main() {
      final list = <int>[];
      list.add(1);
      list.add(2);
      printInts(list);
    }
    // #enddocregion opening-example

    expect(main, prints('[1, 2]\n'));
  });

  group('runtime checks:', () {
    test('introductory example', () {
      // #docregion runtime-checks
      void main() {
        List<Animal> animals = <Dog>[Dog()];
        List<Cat> cats = animals as List<Cat>;
      }
      // #enddocregion runtime-checks

      const msg = "type 'List<Dog>' is not a subtype of type 'List<Cat>'";
      expect(main, _throwsA<TypeError>(msg));
    });
  });
}
