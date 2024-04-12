// ignore_for_file: prefer_initializing_formals
import 'dart:math';

class Point {
  Point(this.x, this.y) : distanceFromOrigin = sqrt(x * x + y * y);

  final double x;
  final double y;
  final double distanceFromOrigin;
}

void main() {
  var p = Point(2, 3);
  print(p.distanceFromOrigin);
}
