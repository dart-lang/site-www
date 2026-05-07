// #docregion declaring-parameters
class Point(var int x, var int y); // Declares both fields x and y
class User(String name); // Does not declare a field
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
class UserWithPrivateField(String name) { // 'name' is a parameter
  final String _name = name; // '_name' is private
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

// #docregion factory-edge-case
class LegacyClass {
  // In current Dart, this is a method named 'factory'.
  // In Dart 3.13+, this will be parsed as a factory constructor!
  factory() {
    print('Method named factory');
  }
}
// #enddocregion factory-edge-case

// #docregion final-parameter-restriction
// In current Dart this is valid. In Dart 3.13+ it becomes an error.
void processUser(final User user) { 
  print(user.name);
}
// #enddocregion final-parameter-restriction
