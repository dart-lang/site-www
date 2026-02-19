// #docregion point
// Current syntax.
class Point {
  int x;
  int y;
  
  Point(this.x, this.y);
}
// #enddocregion point

// #docregion point-primary
// Using a primary constructor.
class PointPrimary(var int x, var int y);
// #enddocregion point-primary
