---
title: pattern_never_matches_value_type
description: >-
  Details about the pattern_never_matches_value_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The matched value type '{0}' can never match the required type '{1}'._

## Description

The analyzer produces this diagnostic when the type of the object being
matched can't ever be matched by the pattern.

## Example

The following code produces this diagnostic because a `double` is being
matched by a pattern that requires an `int`, which can never succeed:

```dart
void f(String? s) {
  if (s case [!int!] _) {}
}
```

## Common fixes

If one of the types is wrong, then change one or both of the types so that
the pattern can succeed:

```dart
void f(String? s) {
  if (s case String _) {}
}
```

If the types aren't wrong, then remove the pattern match:

```dart
void f(double x) {}
```
