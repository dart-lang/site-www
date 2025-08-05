---
title: case_expression_type_is_not_switch_expression_subtype
description: >-
  Details about the case_expression_type_is_not_switch_expression_subtype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The switch case expression type '{0}' must be a subtype of the switch expression type '{1}'._

## Description

The analyzer produces this diagnostic when the expression following `case`
in a `switch` statement has a static type that isn't a subtype of the
static type of the expression following `switch`.

## Example

The following code produces this diagnostic because `1` is an `int`, which
isn't a subtype of `String` (the type of `s`):

```dart
void f(String s) {
  switch (s) {
    case [!1!]:
      break;
  }
}
```

## Common fixes

If the value of the `case` expression is wrong, then change the `case`
expression so that it has the required type:

```dart
void f(String s) {
  switch (s) {
    case '1':
      break;
  }
}
```

If the value of the `case` expression is correct, then change the `switch`
expression to have the required type:

```dart
void f(int s) {
  switch (s) {
    case 1:
      break;
  }
}
```
