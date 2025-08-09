---
title: empty_map_pattern
description: >-
  Details about the empty_map_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A map pattern must have at least one entry._

## Description

The analyzer produces this diagnostic when a map pattern is empty.

## Example

The following code produces this diagnostic because the map pattern
is empty:

```dart
void f(Map<int, String> x) {
  if (x case [!{}!]) {}
}
```

## Common fixes

If the pattern should match any map, then replace it with an object
pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map()) {}
}
```

If the pattern should only match an empty map, then check the length
in the pattern:

```dart
void f(Map<int, String> x) {
  if (x case Map(isEmpty: true)) {}
}
```
