---
title: non_constant_relational_pattern_expression
description: >-
  Details about the non_constant_relational_pattern_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The relational pattern expression must be a constant._

## Description

The analyzer produces this diagnostic when the value in a relational
pattern expression isn't a constant expression.

## Example

The following code produces this diagnostic because the operand of the `>`
operator, `a`, isn't a constant:

```dart
final a = 0;

void f(int x) {
  if (x case > [!a!]) {}
}
```

## Common fixes

Replace the value with a constant expression:

```dart
const a = 0;

void f(int x) {
  if (x case > a) {}
}
```
