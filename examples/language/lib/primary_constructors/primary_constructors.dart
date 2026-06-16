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

// #docregion scoping-shadowing
class ScopingDemo(var String x) {
  // In a field initializer, 'x' refers to the parameter 'x'.
  late final String captureAtDeclaration = x;
  late final String captureInInitializer;

  // In the initializer list, 'x' refers to the parameter 'x'.
  this : captureInInitializer = x {
    // Inside the body, 'x' refers to the instance variable!
    print(x); 
  }
}
// #enddocregion scoping-shadowing

// #docregion const-constructor
class const ConstPoint(final int x, final int y) {
  final int z;
  // A constant primary constructor can have an initializer list, but no body block.
  this : z = x + y;
}
// #enddocregion const-constructor

// #docregion enums
enum Color(final String hex) {
  red('#FF0000'),
  green('#00FF00'),
  blue('#0000FF');
}
// #enddocregion enums
