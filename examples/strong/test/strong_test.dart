// ignore_for_file: unused_local_variable
import 'package:test/test.dart';
import 'package:dartlang_examples_util/dart_version.dart';

import '../lib/animal.dart';

//@nullable
String runtimeChecksSkipStatus() => dartMajorVers == 1
    ? "Dart 1 doesn't support strong mode runtime checks"
    : null; // don't skip tests in Dart 2

Matcher _throwsA<T>(String msg) => throwsA(
      allOf(
          new isInstanceOf<T>(),
          predicate(
            (e) => e.toString().contains(msg),
          )),
    );

void main() {
  test('opening example', () {
    // #docregion opening-example
    void fn(List<int> a) => print(a);

    void main() {
      var list = <int>[];
      list.add(1);
      list.add(2);
      fn(list);
    }

    // #enddocregion opening-example
    expect(main, prints('[1, 2]\n'));
  });

  test("String isn't a number", () {
    // #docregion what-is-soundness
    void main() {
      List<dynamic> strings = ["not", "ints"];
      // ignore_for_file: 1, 2, invalid_assignment
      List<int> numbers = strings; //!analysis-issue
      for (var number in numbers) {
        print(number - 10); // Classic Dart runtime exception
      }
    }
    // #enddocregion what-is-soundness

    final msg = "type 'List' is not a subtype of type 'List<int>'";
    expect(
      main,
      dartMajorVers == 1
          ? _throwsA<NoSuchMethodError>("'String' has no instance method '-'")
          : _throwsA<TypeError>(msg),
    );
  });

  test('runtime-checks: introductory example', () {
    // #docregion runtime-checks
    void main() {
      List<Animal> animals = [new Dog()];
      // ignore_for_file: 1, 2, invalid_assignment
      List<Cat> cats = animals;
    }
    // #enddocregion runtime-checks

    const msg = "type 'List<Animal>' is not a subtype of type 'List<Cat>'";
    expect(main, _throwsA<TypeError>(msg));
  }, skip: runtimeChecksSkipStatus());
}
