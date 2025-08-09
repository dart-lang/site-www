---
title: constant_pattern_never_matches_value_type
description: >-
  Details about the constant_pattern_never_matches_value_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The matched value type '{0}' can never be equal to this constant of type
'{1}'._

## Description

The analyzer produces this diagnostic when a constant pattern can never
match the value it's being tested against because the type of the constant
is known to never match the type of the value.

## Example

The following code produces this diagnostic because the type of the
constant pattern `(true)` is `bool`, and the type of the value being
matched (`x`) is `int`, and a Boolean can never match an integer:

```dart
void f(int x) {
  if (x case [!true!]) {}
}
```

## Common fixes

If the type of the value is correct, then rewrite the pattern to be
compatible:

```dart
void f(int x) {
  if (x case 3) {}
}
```

If the type of the constant is correct, then rewrite the value to be
compatible:

```dart
void f(bool x) {
  if (x case true) {}
}
```
