---
title: unnecessary_null_assert_pattern
description: >-
  Details about the unnecessary_null_assert_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The null-assert pattern will have no effect because the matched type isn't
nullable._

## Description

The analyzer produces this diagnostic when a null-assert pattern is used
to match a value that isn't nullable.

## Example

The following code produces this diagnostic because the variable `x` isn't
nullable:

```dart
void f(int x) {
  if (x case var a[!!!] when a > 0) {}
}
```

## Common fixes

Remove the null-assert pattern:

```dart
void f(int x) {
  if (x case var a when a > 0) {}
}
```
