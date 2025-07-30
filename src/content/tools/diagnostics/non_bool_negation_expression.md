---
title: non_bool_negation_expression
description: >-
  Details about the non_bool_negation_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A negation operand must have a static type of 'bool'._

## Description

The analyzer produces this diagnostic when the operand of the unary
negation operator (`!`) doesn't have the type `bool`.

## Example

The following code produces this diagnostic because `x` is an `int` when it
must be a `bool`:

```dart
int x = 0;
bool y = ![!x!];
```

## Common fixes

Replace the operand with an expression that has the type `bool`:

```dart
int x = 0;
bool y = !(x > 0);
```
