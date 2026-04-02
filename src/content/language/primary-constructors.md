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

Primary constructors provide a concise syntax for expressing a class with its constructor and fields.
They simplify declaring classes where parameters directly map to fields without introducing new runtime semantics.

## Introduction

Use primary constructors to define a class's fields and its main constructor in a single line.
While they do not introduce new runtime semantics,
they eliminate the triple-redundancy of declaring fields,
passing parameters,
and assigning them in the constructor body.

### Before and after

Consider this traditional class with two fields and a constructor:

<?code-excerpt "language/lib/primary_constructors/point.dart (point)"?>
```dart
// Traditional syntax
class Point {
  int x;
  int y;

  Point(this.x, this.y);
}
```

Using a primary constructor makes the same class much more concise:

<?code-excerpt "language/lib/primary_constructors/point.dart (point-primary)" replace="/PointPrimary/Point/g"?>
```dart
// Using a primary constructor
class Point(var int x, var int y);
```

When you declare a parameter in the primary constructor with the `var` or `final` modifier,
Dart implicitly declares an instance variable for that parameter.

A class with a primary constructor cannot have any other non-redirecting generative constructors.
This constraint ensures that the primary constructor executes on every newly created instance. 

## Declare parameters

A parameter list placed just after the class name specifies both a constructor and instance variables.
Each formal parameter that has the `var` or `final` modifier implicitly induces a field.
These are called **declaring parameters**.

-   `final`: Specifies that the induced instance variable is immutable.
-   `var`: Specifies that the instance variable is mutable.

If you omit the modifier,
it is a **non-declaring parameter** and does not create an implicit field.
Use non-declaring parameters for custom initialization logic.

```dart
class Point(var int x, var int y); // Declares both fields x and y
class User(String name); // String name is a non-declaring parameter (no field)
```

## Primary initializer scope

When a class has a primary constructor,
the formal parameters in the header enter a new scope known as the **primary initializer scope**.

This scope is the active scope for initializing each non-late instance variable in the class body.
Initialize fields directly from constructor parameters without a separate initializer list!



```dart
class DeltaPoint(final int x, int delta) {
  final int y = x + delta; // Accesses 'x' and 'delta' parameters directly!
}
```

This makes refactoring from traditional constructors to primary constructors safer and simpler.

## Add constructor bodies

If you need to validate input or perform complex initialization,
use a **body part** for the primary constructor inside the class definition.
It uses the `this` keyword:

```dart
class Point(var int x, var int y) {
  this : assert(x >= 0 && y >= 0) {
    print('Point initialized at ($x, $y)');
  }
}
```

The body part can specify an initializer list after `this` and/or a normal function body.

## Private named parameters

If you want to use a public parameter to initialize a private field, use a non-declaring parameter in the primary constructor header and declare the private field in the class body:

```dart
class User(String name) { // 'name' is public
  final String _name = name; // '_name' is private
}
```

## Empty bodies

An empty body of a class, mixin class, or extension type (`{}`) can be replaced by `;` when using a primary constructor.

```dart
class Point(var int x, var int y);
```

## Super parameters

Super parameters can be declared in the same way as in traditional constructors today:

```dart
class A(final int a);

class B(super.a) extends A;
```

