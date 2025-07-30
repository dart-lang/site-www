---
title: invalid_use_of_null_value
description: >-
  Details about the invalid_use_of_null_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_An expression whose value is always 'null' can't be dereferenced._

## Description

The analyzer produces this diagnostic when an expression whose value will
always be `null` is dereferenced.

## Example

The following code produces this diagnostic because `x` will always be
`null`:

```dart
int f(Null x) {
  return x.[!length!];
}
```

## Common fixes

If the value is allowed to be something other than `null`, then change the
type of the expression:

```dart
int f(String? x) {
  return x!.length;
}
```
