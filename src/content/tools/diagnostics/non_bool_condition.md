---
title: non_bool_condition
description: >-
  Details about the non_bool_condition
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Conditions must have a static type of 'bool'._

## Description

The analyzer produces this diagnostic when a condition, such as an `if` or
`while` loop, doesn't have the static type `bool`.

## Example

The following code produces this diagnostic because `x` has the static type
`int`:

```dart
void f(int x) {
  if ([!x!]) {
    // ...
  }
}
```

## Common fixes

Change the condition so that it produces a Boolean value:

```dart
void f(int x) {
  if (x == 0) {
    // ...
  }
}
```
