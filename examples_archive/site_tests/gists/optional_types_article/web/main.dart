// This example, part of the
// https://www.dartlang.org/articles/optional-types
// article, demonstrates a static warning in Dart.

class Point {
  final num x, y;
  Point(this.x, this.y);
  Point operator +(Point other) {
    return new Point(x + other.x, y + other.y);
  }

  String toString() {
    return "x: $x, y: $y";
  }
}

main() {
  Point p1 = new Point(0, 0);
  Point p2 = new Point(10, 10);

  int n = p1 + p2;

  print(n);
}
