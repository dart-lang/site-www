import 'package:test/test.dart';
import 'package:examples_util/print_matcher.dart' as m;

void main() {
  test('for', () {
    // #docregion for
    var message = StringBuffer('Dart is fun');
    for (var i = 0; i < 5; i++) {
      message.write('!');
    }
    // #enddocregion for
    expect(message.toString(), 'Dart is fun!!!!!');
  });

  test('for-and-closures', () {
    void testForEachClosures() {
      // #docregion for-and-closures
      var callbacks = [];
      for (var i = 0; i < 2; i++) {
        callbacks.add(() => print(i));
      }

      for (final c in callbacks) {
        c();
      }
      // #enddocregion for-and-closures
    }

    expect(testForEachClosures, m.prints(['0', '1']));
  });

  test('forEach', () {
    void testCollectionForEach() {
      // #docregion for-each
      var collection = [1, 2, 3];
      collection.forEach(print); // 1 2 3
      // #enddocregion for-each
    }

    expect(testCollectionForEach, m.prints([1, 2, 3]));
  });
}
