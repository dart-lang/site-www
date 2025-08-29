---
title: for_in_of_invalid_type
description: >-
  Details about the for_in_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type '{0}' used in the 'for' loop must implement '{1}'._

## Description

The analyzer produces this diagnostic when the expression following `in` in
a for-in loop has a type that isn't a subclass of `Iterable`.

## Example

The following code produces this diagnostic because `m` is a `Map`, and
`Map` isn't a subclass of `Iterable`:

```dart
void f(Map<String, String> m) {
  for (String s in [!m!]) {
    print(s);
  }
}
```

## Common fixes

Replace the expression with one that produces an iterable value:

```dart
void f(Map<String, String> m) {
  for (String s in m.values) {
    print(s);
  }
}
```
