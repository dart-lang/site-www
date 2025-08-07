---
title: const_spread_expected_map
description: >-
  Details about the const_spread_expected_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A map is expected in this spread._

## Description

The analyzer produces this diagnostic when the expression of a spread
operator in a constant map evaluates to something other than a map.

## Example

The following code produces this diagnostic because the value of `map1` is
`null`, which isn't a map:

```dart
const dynamic map1 = 42;
const Map<String, int> map2 = {...[!map1!]};
```

## Common fixes

Change the expression to something that evaluates to a constant map:

```dart
const dynamic map1 = {'answer': 42};
const Map<String, int> map2 = {...map1};
```
