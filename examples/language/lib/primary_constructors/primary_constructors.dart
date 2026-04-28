// #docregion declaring-parameters
class Point(var int x, var int y); // Declares both fields x and y
class User(String name); // String name is a non-declaring parameter (no field)
// #enddocregion declaring-parameters

// #docregion initializer-scope
class DeltaPoint(final int x, int delta) {
  final int y = x + delta; // Accesses 'x' and 'delta' parameters directly!
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
class UserWithPrivateField(String name) { // 'name' is public
  final String _name = name; // '_name' is private
}
// #enddocregion private-fields

// #docregion empty-bodies
class EmptyBodyPoint(var int x, var int y);
// #enddocregion empty-bodies
