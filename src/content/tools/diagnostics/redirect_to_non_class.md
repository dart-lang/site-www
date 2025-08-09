---
title: redirect_to_non_class
description: >-
  Details about the redirect_to_non_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The name '{0}' isn't a type and can't be used in a redirected constructor._

## Description

One way to implement a factory constructor is to redirect to another
constructor by referencing the name of the constructor. The analyzer
produces this diagnostic when the redirect is to something other than a
constructor.

## Example

The following code produces this diagnostic because `f` is a function:

```dart
C f() => throw 0;

class C {
  factory C() = [!f!];
}
```

## Common fixes

If the constructor isn't defined, then either define it or replace it with
a constructor that is defined.

If the constructor is defined but the class that defines it isn't visible,
then you probably need to add an import.

If you're trying to return the value returned by a function, then rewrite
the constructor to return the value from the constructor's body:

```dart
C f() => throw 0;

class C {
  factory C() => f();
}
```
