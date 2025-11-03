// #docregion allowed-equality
enum Color { red, green, blue }

void allowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // OK: `myColor` is a `Color`, so `.green` is inferred as `Color.green`.
  if (myColor == .green) {
    print('The color is green.');
  }

  // OK: Works with `!=` as well.
  if (myColor != .blue) {
    print('The color is not blue.');
  }

  // OK: The context for the ternary is the variable `inferredColor`
  // being assigned to, which has a type of `Color`.
  Color inferredColor = condition ? .green : .blue;
  print('Inferred color is $inferredColor');
}
// #enddocregion allowed-equality

// #docregion not-allowed-equality
enum Color { red, green, blue }

void notAllowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // ERROR: The shorthand must be on the right side of `==`.
  // Dart's `==` operator is not symmetric for this feature.
  if (.red == myColor) {
    print('This will not compile.');
  }

  // ERROR: The right-hand side is a complex expression (a ternary),
  // which is not a valid target for shorthand in a comparison.
  if (myColor == (condition ? .green : .blue)) {
    print('This will not compile.');
  }

  // ERROR: The type context is lost by casting `myColor` to `Object`.
  // The compiler no longer knows that `.green` should refer to `Color.green`.
  if ((myColor as Object) == .green) {
    print('This will not compile.');
  }
}
// #enddocregion not-allowed-equality
