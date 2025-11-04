enum Status { none, running, stopped, paused }

class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Use dot shorthand syntax for enum value:
const Status defaultStatus = .running; // Instead of Status.running

// Use dot shorthand syntax to invoke a const named constructor:
const Point myOrigin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax in a const collection literal:
const List<Point> keyPoints = [.origin(), .new(1.0, 1.0)];
// Instead of [Point.origin(), Point(1.0, 1.0)]
