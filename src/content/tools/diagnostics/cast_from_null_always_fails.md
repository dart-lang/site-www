---
title: cast_from_null_always_fails
description: >-
  Details about the cast_from_null_always_fails
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_This cast always throws an exception because the expression always evaluates to
'null'._

## Description

The analyzer produces this diagnostic when an expression whose type is
`Null` is being cast to a non-nullable type.

## Example

The following code produces this diagnostic because `n` is known to always
be `null`, but it's being cast to a non-nullable type:

```dart
void f(Null n) {
  [!n as int!];
}
```

## Common fixes

Remove the unnecessary cast:

```dart
void f(Null n) {
  n;
}
```
