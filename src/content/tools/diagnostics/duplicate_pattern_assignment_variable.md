---
title: duplicate_pattern_assignment_variable
description: >-
  Details about the duplicate_pattern_assignment_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The variable '{0}' is already assigned in this pattern._

## Description

The analyzer produces this diagnostic when a single pattern variable is
assigned a value more than once in the same pattern assignment.

## Example

The following code produces this diagnostic because the variable `a` is
assigned twice in the pattern `(a, a)`:

```dart
int f((int, int) r) {
  int a;
  (a, [!a!]) = r;
  return a;
}
```

## Common fixes

If you need to capture all of the values, then use a unique variable for
each of the subpatterns being matched:

```dart
int f((int, int) r) {
  int a, b;
  (a, b) = r;
  return a + b;
}
```

If some of the values don't need to be captured, then use a wildcard
pattern `_` to avoid having to bind the value to a variable:

```dart
int f((int, int) r) {
  int a;
  (_, a) = r;
  return a;
}
```
