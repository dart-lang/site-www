---
title: equal_keys_in_map
description: >-
  Details about the equal_keys_in_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Two keys in a map literal shouldn't be equal._

## Description

The analyzer produces this diagnostic when a key in a non-constant map is
the same as a previous key in the same map. If two keys are the same, then
the second value overwrites the first value, which makes having both pairs
pointless and likely signals a bug.

## Example

The following code produces this diagnostic because the keys `a` and `b`
have the same value:

```dart
const a = 1;
const b = 1;
var m = <int, String>{a: 'a', [!b!]: 'b'};
```

## Common fixes

If both entries should be included in the map, then change one of the keys:

```dart
const a = 1;
const b = 2;
var m = <int, String>{a: 'a', b: 'b'};
```

If only one of the entries is needed, then remove the one that isn't
needed:

```dart
const a = 1;
var m = <int, String>{a: 'a'};
```

Note that literal maps preserve the order of their entries, so the choice
of which entry to remove might affect the order in which the keys and
values are returned by an iterator.
