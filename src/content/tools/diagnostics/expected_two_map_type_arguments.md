---
title: expected_two_map_type_arguments
description: >-
  Details about the expected_two_map_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Map literals require two type arguments or none, but {0} found._

## Description

The analyzer produces this diagnostic when a map literal has either one or
more than two type arguments.

## Example

The following code produces this diagnostic because the map literal has
three type arguments when it can have either two or zero:

```dart
var m = [!<int, String, int>!]{};
```

## Common fixes

Remove all except two of the type arguments:

```dart
var m = <int, String>{};
```
