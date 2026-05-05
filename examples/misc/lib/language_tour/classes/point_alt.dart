// ignore_for_file: unused_field

/// Example of:
///
/// - A constructor initializing fields in the body "the long way"
/// - A named constructor with initializers, and a print statement in the body.
///
// #docregion idiomatic-constructor
class Point {
  // Instance variables to hold the coordinates of the point.
  double x;
  double y;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
  // #enddocregion idiomatic-constructor

  // #docregion initializer-list
  // Initializer list sets instance variables before
  // the constructor body runs.
  // #docregion initializer-list-no-comment
  Point.fromJson(Map<String, double> json) : x = json['x']!, y = json['y']! {
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

// #docregion initialize-private-named
class PointPrivate {
  final double? _x; // Nullable field
  final double _y; // Non-nullable field

  PointPrivate({this._x, this._y = 0.0});

  @override
  String toString() => 'PointPrivate($_x, $_y)';
}

void testPrivate() {
  var p = PointPrivate(x: 1.0, y: 2.0);
  print(p);
}
// #enddocregion initialize-private-named

// #docregion initialize-private-named-assert
class PointPrivateAssert {
  final double _x;

  PointPrivateAssert({required this._x}) : assert(_x >= 0);
}
// #enddocregion initialize-private-named-assert

// #docregion initialize-private-named-super
class Tool {
  final int _price;
  Tool({required this._price});
}

class Hammer extends Tool {
  // Forwards to the public 'price' argument
  Hammer({required super.price});
}

// #enddocregion initialize-private-named-super
