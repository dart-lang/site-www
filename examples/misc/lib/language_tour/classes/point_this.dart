// ignore_for_file: unnecessary_this
// #docregion this-late
double initialX = 1.5;

class Point {
  double? x = initialX; // OK, can access declarations that do not depend on `this`.
  // ignore: stable, beta, dev, invalid_reference_to_this, invalid_assignment
  double? y = this.x; // ERROR, can't access `this` in non-`late` initializer.
  late double? z = this.x; // OK, can access `this` in `late` initializer.

  Point(this.x, this.y); // OK, `this.fieldName` is a parameter declaration, not an expression.
}
// #enddocregion this-late
