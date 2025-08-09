---
title: throw_of_invalid_type
description: >-
  Details about the throw_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type '{0}' of the thrown expression must be assignable to 'Object'._

## Description

The analyzer produces this diagnostic when the type of the expression in a
throw expression isn't assignable to `Object`. It isn't valid to throw
`null`, so it isn't valid to use an expression that might evaluate to
`null`.

## Example

The following code produces this diagnostic because `s` might be `null`:

```dart
void f(String? s) {
  throw [!s!];
}
```

## Common fixes

Add an explicit null-check to the expression:

```dart
void f(String? s) {
  throw s!;
}
```
