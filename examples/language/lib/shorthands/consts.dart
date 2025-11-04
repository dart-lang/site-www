enum Status { none, running, stopped, paused }

class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Enum values are always constants
const Status defaultStatus = .running; // Instead of Status.running

// Invoking a const named constructor
const Point myOrigin = .origin(); // Instead of Point.origin()

// Using shorthands in a const collection literal
const List<Point> keyPoints = [.origin(), .new(1.0, 1.0)];
// Instead of [Point.origin(), Point(1.0, 1.0)]
