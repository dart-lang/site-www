---
title: no_generative_constructors_in_superclass
description: >-
  Details about the no_generative_constructors_in_superclass
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't extend '{1}' because '{1}' only has factory constructors
(no generative constructors), and '{0}' has at least one generative constructor._

## Description

The analyzer produces this diagnostic when a class that has at least one
generative constructor (whether explicit or implicit) has a superclass
that doesn't have any generative constructors. Every generative
constructor, except the one defined in `Object`, invokes, either
explicitly or implicitly, one of the generative constructors from its
superclass.

## Example

The following code produces this diagnostic because the class `B` has an
implicit generative constructor that can't invoke a generative constructor
from `A` because `A` doesn't have any generative constructors:

```dart
class A {
  factory A.none() => throw '';
}

class B extends [!A!] {}
```

## Common fixes

If the superclass should have a generative constructor, then add one:

```dart
class A {
  A();
  factory A.none() => throw '';
}

class B extends A {}
```

If the subclass shouldn't have a generative constructor, then remove it by
adding a factory constructor:

```dart
class A {
  factory A.none() => throw '';
}

class B extends A {
  factory B.none() => throw '';
}
```

If the subclass must have a generative constructor but the superclass
can't have one, then implement the superclass instead:

```dart
class A {
  factory A.none() => throw '';
}

class B implements A {}
```
