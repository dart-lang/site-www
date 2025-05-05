---
title: non_constant_case_expression
description: >-
  Details about the non_constant_case_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Case expressions must be constant._

## Description

The analyzer produces this diagnostic when the expression in a `case`
clause isn't a constant expression.

## Example

The following code produces this diagnostic because `j` isn't a constant:

```dart
void f(int i, int j) {
  switch (i) {
    case [!j!]:
      // ...
      break;
  }
}
```

## Common fixes

Either make the expression a constant expression, or rewrite the `switch`
statement as a sequence of `if` statements:

```dart
void f(int i, int j) {
  if (i == j) {
    // ...
  }
}
```
