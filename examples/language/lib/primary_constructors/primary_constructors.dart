// ignore_for_file: unused_field

// #docregion declaring-parameters
// Declares both fields x and y.
class Point(var int x, var int y);

// Doesn't declare a field.
class User(String name);
// #enddocregion declaring-parameters

// #docregion initializer-scope
class DeltaPoint(final int x, int delta) {
  // Accesses 'x' and 'delta' parameters directly!
  final int y = x + delta;
}
// #enddocregion initializer-scope

// #docregion constructor-bodies
class PointWithBody(var int x, var int y) {
  this : assert(x >= 0 && y >= 0) {
    print('Point initialized at ($x, $y)');
  }
}
// #enddocregion constructor-bodies

// #docregion private-fields
// 'name' is a parameter.
class UserWithPrivateField(String name) {
  final String _name = name; // '_name' is private.
}
// #enddocregion private-fields

// #docregion empty-bodies
class EmptyBodyPoint(var int x, var int y);
// #enddocregion empty-bodies

// #docregion enums
enum Color(final String hex) {
  red('#FF0000'),
  green('#00FF00'),
  blue('#0000FF');
}

// #enddocregion enums
