// Enum example
enum Status { none, running, stopped, paused }

Status currentStatus = .running; // Instead of Status.running

// Static method example
int port = .parse('8080'); // Instead of int.parse('8080')

// Constructor example
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

Point origin = .origin(); // Instead of Point.origin()
