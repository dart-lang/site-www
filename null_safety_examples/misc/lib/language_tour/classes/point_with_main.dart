// #docregion class, class-main
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
  // #enddocregion class-main
  double z = 0; // Declare z, initially 0.
// #docregion class-main
}
// #enddocregion class

void main() {
  var point = Point();
  point.x = 4; // Use the setter method for x.
  assert(point.x == 4); // Use the getter method for x.
  assert(point.y == null); // Values default to null.
}
