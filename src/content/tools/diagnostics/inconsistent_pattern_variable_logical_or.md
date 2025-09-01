---
title: inconsistent_pattern_variable_logical_or
description: >-
  Details about the inconsistent_pattern_variable_logical_or
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The variable '{0}' has a different type and/or finality in this branch of the
logical-or pattern._

## Description

The analyzer produces this diagnostic when a pattern variable that is
declared on all branches of a logical-or pattern doesn't have the same
type on every branch. It is also produced when the variable has a
different finality on different branches. A pattern variable declared on
multiple branches of a logical-or pattern is required to have the same
type and finality in each branch, so that the type and finality of the
variable can be known in code that's guarded by the logical-or pattern.

## Examples

The following code produces this diagnostic because the variable `a` is
defined to be an `int` on one branch and a `double` on the other:

```dart
void f(Object? x) {
  if (x case (int a) || (double [!a!])) {
    print(a);
  }
}
```

The following code produces this diagnostic because the variable `a` is
`final` in the first branch and isn't `final` in the second branch:

```dart
void f(Object? x) {
  if (x case (final int a) || (int [!a!])) {
    print(a);
  }
}
```

## Common fixes

If the finality of the variable is different, decide whether it should be
`final` or not `final` and make the cases consistent:

```dart
void f(Object? x) {
  if (x case (int a) || (int a)) {
    print(a);
  }
}
```

If the type of the variable is different and the type isn't critical to
the condition being matched, then ensure that the variable has the same
type on both branches:

```dart
void f(Object? x) {
  if (x case (num a) || (num a)) {
    print(a);
  }
}
```

If the type of the variable is different and the type is critical to the
condition being matched, then consider breaking the condition into
multiple `if` statements or `case` clauses:

```dart
void f(Object? x) {
  if (x case int a) {
    print(a);
  } else if (x case double a) {
    print(a);
  }
}
```
