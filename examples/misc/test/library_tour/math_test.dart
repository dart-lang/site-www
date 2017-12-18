// #docregion import
import 'dart:math' as math;
// #enddocregion import
import 'package:test/test.dart';
import 'package:dartlang_examples_util/print_matcher.dart' as m;

void main() {
  test('trigonometric functions', () {
    // #docregion trig
    // Cosine
    assert(math.cos(math.PI) == -1.0);

    // Sine
    var degrees = 30;
    var radians = degrees * (math.PI / 180);
    // radians is now 0.52359.
    var sinOf30degrees = math.sin(radians);
    // sin 30° = 0.5
    assert((sinOf30degrees - 0.5).abs() < 0.01);
    // #enddocregion trig
  });

  test('min-max', () {
    // #docregion min-max
    assert(math.max(1, 1000) == 1000);
    assert(math.min(1, -1000) == -1000);
    // #enddocregion min-max
  });

  test('constants', () {
    expect(() {
      // #docregion constants
      // See the Math library for additional constants.
      print(math.E); // 2.718281828459045
      print(math.PI); // 3.141592653589793
      print(math.SQRT2); // 1.4142135623730951
      // #enddocregion constants
    }, m.prints([math.E, math.PI, math.SQRT2]));
  });

  test('Random', () {
    // #docregion Random
    var random = new math.Random();
    random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
    random.nextInt(10); // Between 0 and 9.
    // #enddocregion Random
  });

  test('Random-bool', () {
    // #docregion Random-bool
    var random = new math.Random();
    random.nextBool(); // true or false
    // #enddocregion Random-bool
  });
}
