---
title: expected_two_map_pattern_type_arguments
description: >-
  Details about the expected_two_map_pattern_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Map patterns require two type arguments or none, but {0} found._

## Description

The analyzer produces this diagnostic when a map pattern has either one
type argument or more than two type arguments. Map patterns can have
either two type arguments or zero type arguments, but can't have any other
number.

## Example

The following code produces this diagnostic because the map pattern
(`<int>{}`) has one type argument:

```dart
void f(Object x) {
  if (x case [!<int>!]{0: _}) {}
}
```

## Common fixes

Add or remove type arguments until there are two, or none:

```dart
void f(Object x) {
  if (x case <int, int>{0: _}) {}
}
```
