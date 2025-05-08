---
title: constant_pattern_with_non_constant_expression
description: >-
  Details about the constant_pattern_with_non_constant_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The expression of a constant pattern must be a valid constant._

## Description

The analyzer produces this diagnostic when a constant pattern has an
expression that isn't a valid constant.

## Example

The following code produces this diagnostic because the constant pattern
`i` isn't a constant:

```dart
void f(int e, int i) {
  switch (e) {
    case [!i!]:
      break;
  }
}
```

## Common fixes

If the value that should be matched is known, then replace the expression
with a constant:

```dart
void f(int e, int i) {
  switch (e) {
    case 0:
      break;
  }
}
```

If the value that should be matched isn't known, then rewrite the code to
not use a pattern:

```dart
void f(int e, int i) {
  if (e == i) {}
}
```
