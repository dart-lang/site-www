// ignore_for_file: sort_constructors_first
/// Example of:
///
/// - A constructor initializing fields in the body "the long way"
/// - A named constructor with initializers, and a print statement in the body.
///
// #docregion constructor-long-way
class Point {
  num x, y;

  Point(num x, num y) {
    // There's a better way to do this, stay tuned.
    this.x = x;
    this.y = y;
  }
  // #enddocregion constructor-long-way

  // #docregion initializer-list
  // Initializer list sets instance variables before
  // the constructor body runs.
  Point.fromJson(Map<String, num> json)
      : x = json['x'],
        y = json['y'] {
    print('In Point.fromJson(): ($x, $y)');
  }
  // #enddocregion initializer-list

  // #docregion initializer-list-with-assert
  Point.withAssert(this.x, this.y) : assert(x >= 0) {
    print('In Point.withAssert(): ($x, $y)');
  }
  // #enddocregion initializer-list-with-assert

// #docregion constructor-long-way
}
