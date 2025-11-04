class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor

  // Factory constructor
  factory Point.fromList(List<double> list) {
    return Point(list[0], list[1]);
  }
}

// Named constructor
Point origin = .origin(); // Instead of Point.origin()

// Factory constructor
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// Generic class constructor
List<int> intList = .filled(5, 0); // Instead of List.filled(5, 0)
