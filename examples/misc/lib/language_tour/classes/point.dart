// ignore_for_file: sort_constructors_first
// #docregion class-with-distanceTo
import 'dart:math';

// #docregion constructor-initializer, named-constructor
class Point {
  double x, y;

  // #enddocregion class-with-distanceTo, named-constructor
  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  // #docregion class-with-distanceTo, named-constructor
  Point(this.x, this.y);
  // #enddocregion class-with-distanceTo, constructor-initializer

  // Named constructor
  Point.origin() {
    x = 0;
    y = 0;
  }
  // #enddocregion named-constructor

  // Initializer list sets instance variables before
  // the constructor body runs.
  Point.fromJson(Map<String, double> json)
      : x = json['x'],
        y = json['y'];
  // #docregion class-with-distanceTo

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
  // #docregion constructor-initializer, named-constructor
}
