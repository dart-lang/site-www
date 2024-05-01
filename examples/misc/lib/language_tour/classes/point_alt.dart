// ignore_for_file: prefer_initializing_formals
/// Example of:
///
/// - A constructor initializing fields in the body "the long way"
/// - A named constructor with initializers, and a print statement in the body.
///
// #docregion idiomatic-constructor
class Point {
  // Initializer list of variables and values
  double x = 2.0;
  double y = 2.0;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
  // #enddocregion idiomatic-constructor

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

// #docregion idiomatic-constructor
}
// #enddocregion idiomatic-constructor

// #docregion initialize-declaration
class PointA {
  double x = 1.0;
  double y = 2.0;

  // The implicit default constructor sets these variables to (1.0,2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
// #enddocregion initialize-declaration

// #docregion initialize-formal
class PointB {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  PointB(this.x, this.y);

  // Initializing formal parameters can also be optional.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
// #enddocregion initialize-formal

// #docregion initialize-named
class PointC {
  double x; // must be set in constructor
  double y; // must be set in constructor

  // Generative constructor with initializing formal parameters
  // with default values
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x,$y)';
  }
}

// Constructor using named variables.
final pointC = PointC.named(x: 2.0, y: 2.0);
// #enddocregion initialize-named

// #docregion initialize-null
class PointD {
  double? x; // null if not set in constructor
  double? y; // null if not set in constructor

  // Generative constructor with initializing formal parameters
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
// #enddocregion initialize-null
