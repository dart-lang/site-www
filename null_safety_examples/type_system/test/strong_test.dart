// ignore_for_file: unused_local_variable, strict_raw_type
import 'package:test/test.dart';

import 'package:examples_strong/animal.dart';
import 'package:examples_strong/bounded/my_collection.dart';

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

  group('runtime checks:', () {
    test('introductory example', () {
      // #docregion runtime-checks
      void main() {
        List<Animal> animals = [Dog()];
        List<Cat> cats = animals as List<Cat>;
      }
      // #enddocregion runtime-checks

      const msg = "type 'List<Animal>' is not a subtype of type 'List<Cat>'";
      expect(main, _throwsA<TypeError>(msg));
    });

    test('downcast check fails', () {
      void _test() {
        // #docregion fail-downcast-check
        assumeStrings(<int>[1, 2, 3]);
        // #enddocregion fail-downcast-check
      }

      // #docregion downcast-check-msg
      const msg = "type 'List<int>' is not a subtype of type 'List<String>'";
      // #enddocregion downcast-check-msg
      expect(_test, _throwsA<TypeError>(msg));
    });

    final expectedOutput = 'a string\n';

    test('downcast check ok for <String>[]', () {
      void _test() {
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
      void _test() {
        // #docregion typed-list
        List<String> list = [];
        list.add('a string');
        list.add('another');
        assumeStrings(list);
        // #enddocregion typed-list
      }

      expect(_test, prints(expectedOutput));
    });

    Map<String, dynamic> fetchFromExternalSource() => {
          'names': ['a string']
        };

    test('downcast check ok: use cast()', () {
      void _test() {
        // #docregion cast
        Map<String, dynamic> json = fetchFromExternalSource();
        var names = json['names'] as List;
        assumeStrings(names.cast<String>());
        // #enddocregion cast
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
  });
}

// #docregion downcast-check
void assumeStrings(dynamic objects) {
  // ignore_for_file: invalid_assignment
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
