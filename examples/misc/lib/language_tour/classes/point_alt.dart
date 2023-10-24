// ignore_for_file: prefer_initializing_formals
/// Example of:
///
/// - A constructor initializing fields in the body "the long way"
/// - A named constructor with initializers, and a print statement in the body.
///
// #docregion constructor-long-way, idiomatic-constructor
class Point {
  double x = 0;
  double y = 0;
  // #enddocregion constructor-long-way

  Point(this.x, this.y);
  // #enddocregion idiomatic-constructor

  /* 
  // #docregion constructor-long-way
  
  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }
  // #enddocregion constructor-long-way
  */

  // #docregion initializer-list
  // Initializer list sets instance variables before
  // the constructor body runs.
  // #docregion initializer-list-no-comment
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']! {
    print('In Point.fromJson(): ($x, $y)');
  }
  // #enddocregion initializer-list-no-comment
  // #enddocregion initializer-list

  // #docregion initializer-list-with-assert
  Point.withAssert(this.x, this.y) : assert(x >= 0) {
    print('In Point.withAssert(): ($x, $y)');
  }
  // #enddocregion initializer-list-with-assert

// #docregion constructor-long-way, idiomatic-constructor
}
