---
title: dead_null_aware_expression
description: >-
  Details about the dead_null_aware_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The left operand can't be null, so the right operand is never executed._

## Description

The analyzer produces this diagnostic in two cases.

The first is when the left operand of an `??` operator can't be `null`.
The right operand is only evaluated if the left operand has the value
`null`, and because the left operand can't be `null`, the right operand is
never evaluated.

The second is when the left-hand side of an assignment using the `??=`
operator can't be `null`. The right-hand side is only evaluated if the
left-hand side has the value `null`, and because the left-hand side can't
be `null`, the right-hand side is never evaluated.

## Examples

The following code produces this diagnostic because `x` can't be `null`:

```dart
int f(int x) {
  return x ?? [!0!];
}
```

The following code produces this diagnostic because `f` can't be `null`:

```dart
class C {
  int f = -1;

  void m(int x) {
    f ??= [!x!];
  }
}
```

## Common fixes

If the diagnostic is reported for an `??` operator, then remove the `??`
operator and the right operand:

```dart
int f(int x) {
  return x;
}
```

If the diagnostic is reported for an assignment, and the assignment isn't
needed, then remove the assignment:

```dart
class C {
  int f = -1;

  void m(int x) {
  }
}
```

If the assignment is needed, but should be based on a different condition,
then rewrite the code to use `=` and the different condition:

```dart
class C {
  int f = -1;

  void m(int x) {
    if (f < 0) {
      f = x;
    }
  }
}
```
