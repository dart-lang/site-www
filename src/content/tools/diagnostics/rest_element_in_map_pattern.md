---
title: rest_element_in_map_pattern
description: >-
  Details about the rest_element_in_map_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A map pattern can't contain a rest pattern._

## Description

The analyzer produces this diagnostic when a map pattern contains a rest
pattern. Map patterns match a map with more keys
than those explicitly given in the pattern (as long as the given keys match),
so a rest pattern is unnecessary.

## Example

The following code produces this diagnostic because the map pattern contains
a rest pattern:

```dart
void f(Map<int, String> x) {
  if (x case {0: _, [!...!]}) {}
}
```

## Common fixes

Remove the rest pattern:

```dart
void f(Map<int, String> x) {
  if (x case {0: _}) {}
}
```
