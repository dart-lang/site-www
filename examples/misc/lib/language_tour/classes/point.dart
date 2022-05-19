// #docregion class-with-distanceTo
import 'dart:math';

// #enddocregion class-with-distanceTo
// #docregion named-constructor
const double xOrigin = 0;
const double yOrigin = 0;

// #docregion class-with-distanceTo, constructor-initializer
class Point {
  final double x;
  final double y;

  // #enddocregion class-with-distanceTo, named-constructor
  // Sets the x and y instance variables
  // before the constructor body runs.
  // #docregion class-with-distanceTo, named-constructor
  Point(this.x, this.y);
  // #enddocregion class-with-distanceTo, constructor-initializer

  // Named constructor
  Point.origin()
      : x = xOrigin,
        y = yOrigin;
  // #enddocregion named-constructor

  // Initializer list sets instance variables before
  // the constructor body runs.
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']!;
  // #docregion class-with-distanceTo

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
  // #docregion constructor-initializer, named-constructor
}
