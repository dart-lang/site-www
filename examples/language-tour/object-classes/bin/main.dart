import 'dart:math' show sqrt;
import 'dart:convert' show JSON;

class Point {
  num x;
  num y;

  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  Point(this.x, this.y);

  // Initializer list sets instance variables before the constructor body runs.
  Point.fromJson(Map jsonMap)
      : x = jsonMap['x'],
        y = jsonMap['y'] {
    print('In Point.fromJson(): ($x, $y)');
  }

  num distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}

class ImmutablePoint {
  final num x;
  final num y;
  const ImmutablePoint(this.x, this.y);
  static final ImmutablePoint origin = const ImmutablePoint(0, 0);
}

void main() {
  var jsonData = JSON.decode('{"x":1, "y":2}');

  // Create a Point using Point().
  var p1 = new Point(2, 2);

  // Create a Point using Point.fromJson().
  var p2 = new Point.fromJson(jsonData);

  var p = new Point(2, 2);

  // Set the value of the instance variable y.
  p.y = 3;

  // Get the value of y.
  assert(p.y == 3);

  // Invoke distanceTo() on p.
  num distance = p.distanceTo(new Point(4, 4));

/*
 * TODO: make this testable
  query('#button')
      ..text = 'Click to Confirm'                        // Get an object. Use its
      ..classes.add('important')                         // instance variables
      ..onClick.add((e) => window.alert('Confirmed!'));  // and methods.
 */

  /* var */ p = const ImmutablePoint(2, 2) as Point;
  var a = const ImmutablePoint(1, 1);
  var b = const ImmutablePoint(1, 1);

  assert(identical(a, b)); // They are the same instance!

  print('The type of a is ${a.runtimeType}');
}
