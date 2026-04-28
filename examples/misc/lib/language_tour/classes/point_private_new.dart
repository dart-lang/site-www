// ignore_for_file: unused_field

// #docregion initialize-private-named-after
class Point {
  final double _x;
  Point({required this._x});
}
// #enddocregion initialize-private-named-after

void initialize() {
  // #docregion initialize-private-named-usage
  var p = Point(x: 1.0);
  // #enddocregion initialize-private-named-usage
  print(p);
}
