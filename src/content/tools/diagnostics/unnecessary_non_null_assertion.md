---
title: unnecessary_non_null_assertion
description: >-
  Details about the unnecessary_non_null_assertion
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The '!' will have no effect because the receiver can't be null._

## Description

The analyzer produces this diagnostic when the operand of the `!` operator
can't be `null`.

## Example

The following code produces this diagnostic because `x` can't be `null`:

```dart
int f(int x) {
  return x[!!!];
}
```

## Common fixes

Remove the null check operator (`!`):

```dart
int f(int x) {
  return x;
}
```
