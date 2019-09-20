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
    _test() {
      // #docregion for-and-closures
      var callbacks = [];
      for (var i = 0; i < 2; i++) {
        callbacks.add(() => print(i));
      }
      callbacks.forEach((c) => c());
      // #enddocregion for-and-closures
    }

    expect(_test, m.prints(['0', '1']));
  });

  test('collection', () {
    _test() {
      // #docregion collection
      var collection = [0, 1, 2];
      for (var x in collection) {
        print(x); // 0 1 2
      }
      // #enddocregion collection
    }

    expect(_test, m.prints([0, 1, 2]));
  });

  test('assert', () {
    var text = '', number = 0, urlString = 'https';
    // #docregion assert
    // Make sure the variable has a non-null value.
    assert(text != null);

    // Make sure the value is less than 100.
    assert(number < 100);

    // Make sure this is an https URL.
    assert(urlString.startsWith('https'));
    // #enddocregion assert

    // #docregion assert-with-message
    assert(urlString.startsWith('https'),
        'URL ($urlString) should start with "https".');
    // #enddocregion assert-with-message
  });
}
