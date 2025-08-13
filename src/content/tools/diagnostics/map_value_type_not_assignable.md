---
title: map_value_type_not_assignable
description: >-
  Details about the map_value_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The element type '{0}' can't be assigned to the map value type '{1}'._

## Description

The analyzer produces this diagnostic when a value of a key-value pair in a
map literal has a type that isn't assignable to the value type of the
map.

## Example

The following code produces this diagnostic because `2` is an `int`, but/
the values of the map are required to be `String`s:

```dart
var m = <String, String>{'a' : [!2!]};
```

## Common fixes

If the type of the map is correct, then change the value to have the
correct type:

```dart
var m = <String, String>{'a' : '2'};
```

If the type of the value is correct, then change the value type of the map:

```dart
var m = <String, int>{'a' : 2};
```
