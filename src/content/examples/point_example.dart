import 'dart:math';

class Point {
  final double x;
  final double y;

  // Constructor initializes x and y instance variables.
  Point(this.x, this.y);

  // Method to calculate the distance to another point.
  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  // Create two points.
  var point1 = Point(0, 0);
  var point2 = Point(3, 4);

  // Calculate the distance between point1 and point2.
  var distance = point1.distanceTo(point2);

  // Print the distance.
  print('Distance between point1 and point2: $distance');
}
