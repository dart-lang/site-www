---
title: const_with_non_constant_argument
description: >-
  Details about the const_with_non_constant_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Arguments of a constant creation must be constant expressions._

## Description

The analyzer produces this diagnostic when a const constructor is invoked
with an argument that isn't a constant expression.

## Example

The following code produces this diagnostic because `i` isn't a constant:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => const C([!i!]);
```

## Common fixes

Either make all of the arguments constant expressions, or remove the
`const` keyword to use the non-constant form of the constructor:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => C(i);
```
