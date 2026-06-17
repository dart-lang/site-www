---
title: Primary constructors
description: >-
  Create classes concisely by
  declaring parameters and fields in the class header.
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
This shorthand changes how you write the declaration,
but it doesn't change runtime behavior.

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

Any other constructors declared inside the class body are referred to as
**in-body constructors**.

To ensure the primary constructor executes on every new instance,
a class, mixin class, or enum with a primary constructor
cannot have any other non-redirecting generative in-body constructors.

:::note
If you want to declare traditional constructors in the class body more concisely
without repeating the class name, see
[Concise constructor syntax](/language/constructors#concise-constructor-syntax).
:::

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

### Primary constructor scopes

Because primary constructor parameters are available in different parts
of the class declaration, Dart manages their visibility using two distinct
scopes:

*   **Primary initializer scope**: Applies to non-late field initializers
    in the class body and the primary constructor's initializer list (after
    `this :`). In this scope, referencing a parameter name (like `x`) refers
    directly to the constructor parameter.
*   **Primary parameter scope**: Applies to the body block of the primary
    constructor (inside `{ ... }`). In this scope, referencing a parameter
    name refers to the *induced instance variable* (field) rather than the
    parameter itself.

This distinction ensures that any updates to instance variables are correctly
reflected in the constructor body, while initializers still have access
to the original parameters.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (scoping-shadowing)"?>
```dart
class ScopingDemo(var String x) {
  // In a non-late field initializer, 'x' refers to the parameter 'x'.
  final String fieldAtDeclaration = x;
  final String fieldInInitializer;

  // In the initializer list, 'x' refers to the parameter 'x'.
  this : fieldInInitializer = x {
    // Inside the body, 'x' refers to the instance variable!
    print(x);
  }
}
```

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

The block can specify an initializer list after `this` and/or a function body.
To provide only an initializer list,
end it with a semicolon, such as `this : assert(x >= 0);`.
You can also annotate the block with metadata,
such as `@metadata this;`.

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
While this is true in general for these declarations,
it is particularly useful when using a primary constructor to
keep the entire declaration on a single line.

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (empty-bodies)" replace="/EmptyBodyPoint/Point/g"?>
```dart
class Point(var int x, var int y);
```

## Constant primary constructors

Just like traditional constructors, a primary constructor can be constant
if the class and its fields allow it. To declare a constant primary constructor,
place the `const` modifier before the class name in the class header:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (const-constructor)"?>
```dart
class const ConstPoint(final int x, final int y) {
  final int z;
  // A constant primary constructor can have an initializer list, but no body block.
  this : z = x + y;
}
```

Constant primary constructors have two important constraints:

*   They **cannot have a body block** (that is, `{ ... }` is a compile-time
    error, even if it is empty). They can only use an initializer list
    followed by a semicolon.
*   Any non-late instance variables in the class body must have initializing
    expressions that are **potentially constant**.

## Named primary constructors

You can also declare a primary constructor as a **named constructor** by
appending a dot (`.`) and a name after the class name in the class header:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-named)" replace="/PointNamed/Point/g"?>
```dart
// A named primary constructor.
class Point.custom(var int x, var int y);
```

This is particularly useful when you want to define a private primary
constructor (such as `Point._`) to restrict direct instantiation and force
callers to use factory methods or other constructors:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-private)" replace="/PointPrivate/Point/g"?>
```dart
// A private named primary constructor.
class Point._(var int x, var int y);
```

## Super parameters

Super parameters work just like they do in traditional constructors,
allowing you to forward parameters to the superclass constructor:

<?code-excerpt "language/lib/primary_constructors/super_parameters.dart (super-parameters)"?>
```dart
class Person(final String name, final int age);

class Employee(super.name, super.age, final String role) extends Person;
```

This is particularly useful for reducing boilerplate
in hierarchical class structures,
as it eliminates the need to manually write initializer lists
or duplicate parameter declarations.

## Enums

You can use primary constructors to declare
[enhanced enums](/language/enums#declaring-enhanced-enums) much more concisely.

By using a primary constructor, you can define the enum's fields and its
constructor in a single line, eliminating the usual boilerplate of declaring
fields, parameters, and initializing them:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (enums)"?>
```dart
enum Color(final String hex) {
  red('#FF0000'),
  green('#00FF00'),
  blue('#0000FF');
}
```

Primary constructors in enums are **implicitly constant**. While you can
optionally write the `const` modifier before the enum name or the primary
constructor name, it is redundant and can be omitted.

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
*   **No assignments to primary constructor parameters**:
    Primary constructor parameters are read-only within the primary initializer
    scope. Assigning to them (for example, `x = 5` or `x++`) in a field
    initializer or the primary constructor's initializer list is a
    compile-time error.
*   **Double initialization**:
    You cannot initialize an instance variable both in its declaration
    and in the primary constructor's initializer list (or as an initializing
    formal parameter), even if the field is mutable. Doing so results
    in a compile-time error.
*   **Body part constraints**:
    *   A primary constructor body part (the `this` block) cannot use the
        `async`, `async*`, or `sync*` modifiers, and it cannot use the
        expression body arrow (`=>`) syntax.
    *   You cannot write a `this` block if the class header does not declare
        a primary constructor.
    *   A class can have at most one primary constructor body part.
*   **Mixin class primary constructors must be trivial**:
    A mixin class can only declare a primary constructor if it has
    no parameters, no initializer list, and no body.
*   **Covariant parameters**:
    You can only use the `covariant` modifier on a primary constructor
    parameter if it is a declaring parameter (uses the `var` modifier).
    Using `covariant` on `final` or non-declaring parameters is a
    compile-time error because they do not induce a setter.

:::warning
**Important breaking changes and edge cases:**

*   **Restriction on `final` and `var` in normal function parameters**:
    With primary constructors,
    using `final` or `var` on formal parameters in normal functions
    becomes a compile-time error.
    They are reserved exclusively for declaring parameters
    in primary constructors.
    Note that the lints `avoid_final_parameters` and
    `var_with_no_type_annotation` only work in Dart 3.12 and below.
    To enforce immutable parameters as a style choice in Dart 3.13 and later,
    use the [`parameter_assignments`][] linter rule.
*   **The `factory` method edge case**:
    If you have a method named `factory` with no return type
    (for example, `factory() {}`),
    the compiler parses it as a factory constructor
    after primary constructors ship.
    Make sure such methods have explicit return types
    to avoid this conflict.
:::

[`parameter_assignments`]: /tools/linter-rules/parameter_assignments
