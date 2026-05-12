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
Primary constructors require a [language version][] of at least 3.13.
:::

[language version]: /language/versioning

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

## Field declarations in parameters

Parameters in primary constructors with the `var` or `final` modifier,
called **declaring parameters**, implicitly induce a field.

If you omit the modifier, the parameter does not create a field.
It behaves just like a parameter in a traditional constructor.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (declaring-parameters)"?>
```dart
// Declares both fields x and y.
class Point(var int x, var int y);

// Doesn't declare a field.
class User(String name);
```

Because `final` and `var` modifiers on parameters are reserved exclusively
for declaring parameters in primary constructors,
you cannot use them on parameters in other kinds of functions.

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
  // Accesses 'x' and 'delta' parameters directly!
  final int y = x + delta;
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
It also supports forms with just an initializer list followed by a semicolon
(for example, `this : assert(x >= 0);`),
and you can apply metadata annotations to it
(for example, `@metadata this;`).

## Initialize private fields

To initialize a private field using a named parameter,
you can write manual assignment boilerplate in a traditional constructor:

<?code-excerpt "language/lib/primary_constructors/private_named_parameters.dart (private-named-old)" replace="/UserOld/User/g"?>
```dart
// Variant not using a private named parameter.
class User({required String name}) {
  String _name = name;
}
```

With primary constructors and the private named parameters feature,
you can declare the private field directly in the constructor header.
When you use a private name (with a leading underscore) for a named parameter,
the compiler automatically makes the parameter name public for the caller
by removing the underscore:

<?code-excerpt "language/lib/primary_constructors/private_named_parameters.dart (private-named-new)" replace="/UserNew/User/g"?>
```dart
// Variant using a private named parameter.
class User({required var String _name});
```

In both cases, the caller uses the public name `name`
at the call site: `User(name: 'John Doe')`.

## Empty bodies

An empty body of a class, mixin class, extension, or extension type (`{}`)
can be replaced by a semicolon (`;`).
While this is true in general for these declarations, it is particularly
useful when using a primary constructor to keep the entire declaration on a single line.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (empty-bodies)" replace="/EmptyBodyPoint/Point/g"?>
```dart
class Point(var int x, var int y);
```

## Super parameters

Super parameters work just like they do in traditional constructors:

<?code-excerpt "language/lib/primary_constructors/super_parameters.dart"?>
```dart
class A(final int a);

class B(super.a) extends A;
```

## Constraints and breaking changes

Keep these constraints and potential errors in mind
when using primary constructors:

*   **Declaring parameters cannot be `late` or `external`**:
    The `late` and `external` modifiers are not allowed
    on parameters in the primary constructor header.
    To use these modifiers, declare the fields in the class body as usual.
*   **Name collisions**: Declaring a parameter in the primary constructor
    with the same name as a method or another field in the class body
    results in a compile-time error.

:::warning
**Important breaking changes and edge cases:**

*   **Restriction on `final` and `var` in normal function parameters**:
    With primary constructors,
    using `final` or `var` on formal parameters in normal functions
    becomes a compile-time error.
    They are reserved exclusively for declaring parameters
    in primary constructors.
    Note that the lints `avoid_final_parameters` and `var_with_no_type_annotation`
    only work in Dart 3.12 and below.
    To enforce immutable parameters as a style choice in Dart 3.13 and later,
    use the
    [parameter_assignments](https://dart.dev/tools/linter-rules/parameter_assignments)
    linter rule.
*   **The `factory` method edge case**:
    If you have a method named `factory` with no return type
    (for example, `factory() {}`),
    the compiler parses it as a factory constructor
    after primary constructors ship.
    Make sure such methods have explicit return types
    to avoid this conflict.
:::

