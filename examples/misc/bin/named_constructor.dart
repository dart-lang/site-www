// ignore_for_file: sort_constructors_first

// #docregion named-constructor
class Point {
  num x, y;

  Point(this.x, this.y);

  Point.origin() {
    x = 0;
    y = 0;
  }
}
// #enddocregion named-constructor

void main() {
  final myPoint = Point.origin();
  print(myPoint.x);
  print(myPoint.y);
}
