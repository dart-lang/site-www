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

Primary constructors are a conciseness feature that allows you to express a class with a constructor and fields using a less verbose notation. They do not introduce new semantics but simplify the declaration of classes where parameters directly map to fields.

## Introduction

Consider this traditional class with two fields and a constructor:

```dart
// Current syntax.
class Point {
  int x;
  int y;
  
  Point(this.x, this.y);
}
```

A primary constructor allows you to define the same class much more concisely:

```dart
// Using a primary constructor.
class Point(var int x, var int y);
```

When you declare a parameter in the primary constructor with the `var` or `final` modifier, Dart implicitly declares an instance variable for that parameter. 

A class that has a primary constructor cannot have any other non-redirecting generative constructors. This ensures that the primary constructor is executed on every newly created instance of this class. All other generative constructors must redirect to the primary one.

## Parameter syntax changes

With the introduction of primary constructors, all other declarations of formal parameters as `final` will be a compile-time error. This ensures that `final int x` is unambiguously a declaring parameter. 

Similarly, a regular (non-declaring) formal parameter can no longer use the syntax `var name`. It must have a type (`T name`) or the type must be omitted (`name`).

## Constructor body and initializers

A primary constructor can have a body and/or an initializer list. These elements are placed in the class body.

```dart
// Using a primary constructor.
class ModifierClass(this.x) {
  late int x;
  external double d;
}
```

An empty body of a class, mixin class, or extension type (`{}`) can be replaced by `;` when using a primary constructor.

## Super parameters

Super parameters can be declared in the same way as in a constructor today:

```dart
class A(final int a);

class B(super.a) extends A;
```
