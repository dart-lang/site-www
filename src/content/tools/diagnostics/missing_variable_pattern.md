---
title: missing_variable_pattern
description: >-
  Details about the missing_variable_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Variable pattern '{0}' is missing in this branch of the logical-or pattern._

## Description

The analyzer produces this diagnostic when one branch of a logical-or
pattern doesn't declare a variable that is declared on the other branch of
the same pattern.

## Example

The following code produces this diagnostic because the right-hand side of
the logical-or pattern doesn't declare the variable `a`:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || [!(0, _)!]) {
    print(a);
  }
}
```

## Common fixes

If the variable needs to be referenced in the controlled statements, then
add a declaration of the variable to every branch of the logical-or
pattern:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || (0, var a)) {
    print(a);
  }
}
```

If the variable doesn't need to be referenced in the controlled
statements, then remove the declaration of the variable from every branch
of the logical-or pattern:

```dart
void f((int, int) r) {
  if (r case (_, 0) || (0, _)) {
    print('found a zero');
  }
}
```

If the variable needs to be referenced if one branch of the pattern
matches but not when the other matches, then break the pattern into two
pieces:

```dart
void f((int, int) r) {
  switch (r) {
    case (var a, 0):
      print(a);
    case (0, _):
      print('found a zero');
  }
}
```
