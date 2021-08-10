import 'package:test/test.dart';

void main() {
  test('make greeting', () {
    // #docregion make-greeting
    // Dart code

    String makeGreeting(String name) {
      var greeting = 'Hello $name';
      return greeting;
    }
    // #enddocregion make-greeting

    expect(makeGreeting('Dash'), equals('Hello Dash'));
    expect(makeGreeting(''), equals('Hello '));
  });
}
