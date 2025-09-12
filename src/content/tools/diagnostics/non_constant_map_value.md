---
title: non_constant_map_value
description: >-
  Details about the non_constant_map_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The values in a const map literal must be constant._

## Description

The analyzer produces this diagnostic when a value in a constant map
literal isn't a constant value.

## Example

The following code produces this diagnostic because `a` isn't a constant:

```dart
var a = 'a';
var m = const {0: [!a!]};
```

## Common fixes

If the map needs to be a constant map, then make the key a constant:

```dart
const a = 'a';
var m = const {0: a};
```

If the map doesn't need to be a constant map, then remove the `const`
keyword:

```dart
var a = 'a';
var m = {0: a};
```
