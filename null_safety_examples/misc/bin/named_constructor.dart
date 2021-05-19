// #docregion
class Point {
  double x, y;

  Point(this.x, this.y);

  Point.origin()
      : x = 0,
        y = 0;
}
// #enddocregion

void main() {
  final myPoint = Point.origin();
  print(myPoint.x);
  print(myPoint.y);
}
