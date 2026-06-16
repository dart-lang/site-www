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

// #docregion point-named
// A named primary constructor.
class PointNamed.custom(var int x, var int y);
// #enddocregion point-named

// #docregion point-private
// A private named primary constructor.
class PointPrivate._(var int x, var int y);
// #enddocregion point-private
