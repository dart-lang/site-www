---
title: set_element_type_not_assignable
description: >-
  Details about the set_element_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The element type '{0}' can't be assigned to the set type '{1}'._

## Description

The analyzer produces this diagnostic when an element in a set literal has
a type that isn't assignable to the element type of the set.

## Example

The following code produces this diagnostic because the type of the string
literal `'0'` is `String`, which isn't assignable to `int`, the element
type of the set:

```dart
var s = <int>{[!'0'!]};
```

## Common fixes

If the element type of the set literal is wrong, then change the element
type of the set:

```dart
var s = <String>{'0'};
```

If the type of the element is wrong, then change the element:

```dart
var s = <int>{'0'.length};
```
