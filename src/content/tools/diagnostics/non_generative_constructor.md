---
title: non_generative_constructor
description: >-
  Details about the non_generative_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The generative constructor '{0}' is expected, but a factory was found._

## Description

The analyzer produces this diagnostic when the initializer list of a
constructor invokes a constructor from the superclass, and the invoked
constructor is a factory constructor. Only a generative constructor can be
invoked in the initializer list.

## Example

The following code produces this diagnostic because the invocation of the
constructor `super.one()` is invoking a factory constructor:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : [!super.one()!];
}
```

## Common fixes

Change the super invocation to invoke a generative constructor:

```dart
class A {
  factory A.one() = B;
  A.two();
}

class B extends A {
  B() : super.two();
}
```

If the generative constructor is the unnamed constructor, and if there are
no arguments being passed to it, then you can remove the super invocation.
