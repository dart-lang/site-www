// ignore_for_file: unused_local_variable
import 'package:test/test.dart';
import 'package:dartlang_examples_util/dart_version.dart';

import 'package:dartlang_strong/animal.dart';
import 'package:dartlang_strong/bounded/my_collection.dart';

//@nullable
String runtimeChecksSkipStatus() => dartMajorVers == 1
    ? "Dart 1 doesn't support strong mode runtime checks"
    : null; // don't skip tests in Dart 2

Matcher _throwsA<T>(String msg) => throwsA(
      allOf(
          TypeMatcher<T>(),
          predicate(
            (e) => e.toString().contains(msg),
          )),
    );

void main() {
  test('opening example', () {
    // #docregion opening-example
    void printInts(List<int> a) => print(a);

    void main() {
      var list = <int>[];
      list.add(1);
      list.add(2);
      printInts(list);
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

    final msg = "type 'List<dynamic>' is not a subtype of type 'List<int>'";
    expect(
      main,
      dartMajorVers == 1
          ? _throwsA<NoSuchMethodError>("'String' has no instance method '-'")
          : _throwsA<TypeError>(msg),
    );
  });

  group('runtime checks:', () {
    test('introductory example', () {
      // #docregion runtime-checks
      void main() {
        List<Animal> animals = [Dog()];
        // ignore_for_file: 1, 2, invalid_assignment
        List<Cat> cats = animals;
      }
      // #enddocregion runtime-checks

      const msg = "type 'List<Animal>' is not a subtype of type 'List<Cat>'";
      expect(main, _throwsA<TypeError>(msg));
    }, skip: runtimeChecksSkipStatus());

    test('downcast check fails', () {
      _test() {
        // #docregion fail-downcast-check
        assumeStrings(<int>[1, 2, 3]);
        // #enddocregion fail-downcast-check
      }

      // #docregion downcast-check-msg
      final msg = "type 'List<int>' is not a subtype of type 'List<String>'";
      // #enddocregion downcast-check-msg
      expect(_test, _throwsA<TypeError>(msg));
    });

    final expectedOutput = 'a string\n';

    test('downcast check ok for <String>[]', () {
      _test() {
        // #docregion typed-list-lit
        var list = <String>[];
        list.add('a string');
        list.add('another');
        assumeStrings(list);
        // #enddocregion typed-list-lit
      }

      expect(_test, prints(expectedOutput));
    });

    test('downcast check ok for List<String>', () {
      _test() {
        // #docregion typed-list
        List<String> list = [];
        list.add('a string');
        list.add('another');
        assumeStrings(list);
        // #enddocregion typed-list
      }

      expect(_test, prints(expectedOutput));
    });

    Map<String, dynamic> getFromExternalSource() => {
          'names': ['a string']
        };

    test('downcast check ok: use cast()', () {
      _test() {
        // #docregion cast
        Map<String, dynamic> json = getFromExternalSource();
        var names = json['names'] as List;
        // ignore_for_file: 1, argument_type_not_assignable, undefined_method
        assumeStrings(names.cast<String>());
        // #enddocregion cast
      }

      if (dartMajorVers == 1) {
        expect(
          _test,
          _throwsA<NoSuchMethodError>(
              "Class 'List' has no instance method 'cast'"),
        );
      } else {
        expect(_test, prints(expectedOutput));
      }
    });

    test('downcast check ok: create new object', () {
      _test() {
        // #docregion create-new-object
        Map<String, dynamic> json = getFromExternalSource();
        var names = json['names'] as List;
        // Use `as` and `toList` until 2.0.0-dev.22.0, when `cast` is available:
        assumeStrings(names.map((name) => name as String).toList());
        // #enddocregion create-new-object
      }

      expect(_test, prints(expectedOutput));
    });

    test('instantiate-to-bound sanity', () {
      final b = B();
      expect(b.typeOfS, 'int');
      expect(b.typeOfT, 'dynamic');
    });

    test('instantiate-to-bound fix: add type arg', () {
      // #docregion add-type-arg
      var c = C<List>([]).collection;
      c.add(2);
      // #enddocregion add-type-arg
      expect(c, [2]);
    });

    test('instantiate-to-bound fix 2', () {
      // #docregion use-iterable
      var c = C(Iterable.empty()).collection;
      // Use c as an iterable...
      // #enddocregion use-iterable
      expect(c, TypeMatcher<Iterable>());
    });
  });
}

// ignore_for_file: type_annotate_public_apis
// #docregion downcast-check
assumeStrings(List<Object> objects) {
  // ignore_for_file: 1, 2, invalid_assignment
  List<String> strings = objects; // Runtime downcast check
  String string = strings[0]; // Expect a String value
  // #enddocregion downcast-check
  print(string);
  // #docregion downcast-check
}
// #enddocregion downcast-check

class B<S extends int, T> {
  String get typeOfS => '$S';
  String get typeOfT => '$T';
}
