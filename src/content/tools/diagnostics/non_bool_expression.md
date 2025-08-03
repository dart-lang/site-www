---
title: non_bool_expression
description: >-
  Details about the non_bool_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The expression in an assert must be of type 'bool'._

## Description

The analyzer produces this diagnostic when the first expression in an
assert has a type other than `bool`.

## Example

The following code produces this diagnostic because the type of `p` is
`int`, but a `bool` is required:

```dart
void f(int p) {
  assert([!p!]);
}
```

## Common fixes

Change the expression so that it has the type `bool`:

```dart
void f(int p) {
  assert(p > 0);
}
```
