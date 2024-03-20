// #docregion class-with-distance-to
import 'dart:math';

// #enddocregion class-with-distance-to
// #docregion named-constructor
const double xOrigin = 0;
const double yOrigin = 0;

// #docregion class-with-distance-to, constructor-initializer
class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  // #docregion class-with-distance-to, named-constructor
  Point(this.x, this.y);
  // #enddocregion class-with-distance-to, constructor-initializer

  // #docregion named-constructor
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
  // #docregion class-with-distance-to

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
  // #docregion constructor-initializer, named-constructor
}
// #enddocregion class-with-distance-to, constructor-initializer, named-constructor
