---
title: Primary constructors
description: Create classes concisely by declaring parameters and fields in the class header.
prevpage:
  url: /language/constructors
  title: Constructors
nextpage:
  url: /language/methods
  title: Methods
---

:::version-note
Primary constructors require a language version of at least 3.13.
:::

## Overview

Primary constructors provide a concise way to declare a class's fields
and its main constructor in a single line.
They reduce the boilerplate of declaring fields, passing parameters,
and assigning them in the constructor body.
This shorthand is purely "syntax sugar"
and does not introduce new runtime semantics.

### Before and after

Consider this traditional class with two fields and a constructor:

<?code-excerpt "language/lib/primary_constructors/point.dart (point)"?>
```dart
// Current syntax.
class Point {
  int x;
  int y;

  Point(this.x, this.y);
}
```

Using a primary constructor makes the same class much more concise:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-primary)" replace="/PointPrimary/Point/g"?>
```dart
// Using a primary constructor.
class Point(var int x, var int y);
```

Declaring a parameter in the primary constructor with `var` or `final`
implicitly induces an instance variable for that parameter.

To ensure this constructor executes on every new instance,
a class, mixin class, or enum with a primary constructor
cannot have any other non-redirecting generative constructors.

## Declare parameters

Placing a parameter list just after the class name
specifies both a constructor and instance variables.
Parameters with the `var` or `final` modifier, called **declaring parameters**,
implicitly induce a field.

Omitting the modifier creates a **non-declaring parameter**,
which does not induce an implicit field.
Use non-declaring parameters for custom initialization logic.

Because `final` and `var` modifiers on parameters are reserved exclusively
for declaring parameters in primary constructors,
you cannot use them on parameters in other kinds of functions.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (declaring-parameters)"?>
```dart
class Point(var int x, var int y); // Declares both fields x and y
class User(String name); // String name is a non-declaring parameter (no field)
```

For extension types, the primary constructor must have exactly one parameter.
This parameter is always a declaring parameter, even if you omit the modifier.
You can use the `final` modifier, but it is an error to use `var`.

Mixin classes can only have a primary constructor
with no parameters, body, or initializer list.


## Primary initializer scope

When you use a primary constructor, the parameters you declare
in the class header become directly available
for initializing non-late fields in the class body.

This eliminates the need for a separate initializer list
when calculating values for other fields.
It works just as if you were initializing variables
in a traditional constructor's initializer list.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (initializer-scope)"?>
```dart
class DeltaPoint(final int x, int delta) {
  final int y = x + delta; // Accesses 'x' and 'delta' parameters directly!
}
```

This makes refactoring between traditional and primary constructors
simpler and safer.

## Add constructor bodies

To validate input or perform complex initialization,
you can add a body to the primary constructor inside the class definition.
This body uses the `this` keyword followed by a block:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (constructor-bodies)" replace="/PointWithBody/Point/g"?>
```dart
class Point(var int x, var int y) {
  this : assert(x >= 0 && y >= 0) {
    print('Point initialized at ($x, $y)');
  }
}
```

This block can specify an initializer list after `this` and/or a function body.

## Private named parameters

To use a public parameter to initialize a private field,
use a non-declaring parameter in the primary constructor header
and declare the private field in the class body:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (private-fields)" replace="/UserWithPrivateField/User/g"?>
```dart
class User(String name) { // 'name' is public
  final String _name = name; // '_name' is private
}
```

Dart also supports private named parameters in traditional constructors.
To learn more, visit
[Private named parameters](/language/constructors#private-named-parameters).

## Empty bodies

An empty body of a class, mixin class, or extension type (`{}`)
can be replaced by `;` when using a primary constructor.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (empty-bodies)" replace="/EmptyBodyPoint/Point/g"?>
```dart
class Point(var int x, var int y);
```

## Super parameters

Super parameters can be declared in the same way
as in traditional constructors today:

<?code-excerpt "language/lib/primary_constructors/super_parameters.dart"?>
```dart
class A(final int a);

class B(super.a) extends A;
```

## Constraints and breaking changes

To avoid unexpected compiler errors and understand the impact of this feature,
keep these constraints and edge cases in mind:

*   **No `late` or `external` fields**: The `late` and `external` modifiers
    are not allowed on parameters in the primary constructor header.
    To use these modifiers, declare the fields in the class body as usual.
*   **Name collisions**: Declaring a parameter in the primary constructor
    with the same name as a method or another field in the class body
    results in a compile-time error.

:::warning
**Important breaking changes and edge cases:**

*   **Restriction on `final` in normal function parameters**:
    With primary constructors,
    using `final` on formal parameters in normal functions
    becomes a compile-time error.
    It is reserved exclusively for declaring parameters in primary constructors.
    To enforce immutable parameters as a style choice,
    use the [avoid_final_parameters](https://dart.dev/tools/linter-rules/avoid_final_parameters)
    or [parameter_assignments](https://dart.dev/tools/linter-rules/parameter_assignments) linter rules.
*   **The `factory` method edge case**:
    If you have a method named `factory` with no return type
    (for example, `factory() {}`),
    it will be parsed as a factory constructor after primary constructors ship.
    Ensure your methods have explicit return types to avoid this conflict.
:::

