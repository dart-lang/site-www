---
title: duplicate_variable_pattern
description: >-
  Details about the duplicate_variable_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The variable '{0}' is already defined in this pattern._

## Description

The analyzer produces this diagnostic when a branch of a logical-and
pattern declares a variable that is already declared in an earlier branch
of the same pattern.

## Example

The following code produces this diagnostic because the variable `a` is
declared in both branches of the logical-and pattern:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var [!a!])) {
    print(a);
  }
}
```

## Common fixes

If you need to capture the matched value in multiple branches, then change
the names of the variables so that they are unique:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var b)) {
    print(a + b);
  }
}
```

If you only need to capture the matched value on one branch, then remove
the variable pattern from all but one branch:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, _)) {
    print(a);
  }
}
```
