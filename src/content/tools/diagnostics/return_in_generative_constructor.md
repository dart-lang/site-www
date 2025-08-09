---
title: return_in_generative_constructor
description: >-
  Details about the return_in_generative_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Constructors can't return values._

## Description

The analyzer produces this diagnostic when a generative constructor
contains a `return` statement that specifies a value to be returned.
Generative constructors always return the object that was created, and
therefore can't return a different object.

## Example

The following code produces this diagnostic because the `return` statement
has an expression:

```dart
class C {
  C() {
    return [!this!];
  }
}
```

## Common fixes

If the constructor should create a new instance, then remove either the
`return` statement or the expression:

```dart
class C {
  C();
}
```

If the constructor shouldn't create a new instance, then convert it to be a
factory constructor:

```dart
class C {
  factory C() {
    return _instance;
  }

  static C _instance = C._();

  C._();
}
```
