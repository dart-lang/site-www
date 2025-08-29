---
title: equal_keys_in_const_map
description: >-
  Details about the equal_keys_in_const_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Two keys in a constant map literal can't be equal._

## Description

The analyzer produces this diagnostic when a key in a constant map is the
same as a previous key in the same map. If two keys are the same, then the
second value would overwrite the first value, which makes having both pairs
pointless.

## Example

The following code produces this diagnostic because the key `1` is used
twice:

```dart
const map = <int, String>{1: 'a', 2: 'b', [!1!]: 'c', 4: 'd'};
```

## Common fixes

If both entries should be included in the map, then change one of the keys
to be different:

```dart
const map = <int, String>{1: 'a', 2: 'b', 3: 'c', 4: 'd'};
```

If only one of the entries is needed, then remove the one that isn't
needed:

```dart
const map = <int, String>{1: 'a', 2: 'b', 4: 'd'};
```

Note that literal maps preserve the order of their entries, so the choice
of which entry to remove might affect the order in which keys and values
are returned by an iterator.
