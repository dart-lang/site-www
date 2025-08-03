---
title: equal_keys_in_map_pattern
description: >-
  Details about the equal_keys_in_map_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Two keys in a map pattern can't be equal._

## Description

The analyzer produces this diagnostic when a map pattern contains more
than one key with the same name. The same key can't be matched twice.

## Example

The following code produces this diagnostic because the key `'a'` appears
twice:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, [!'a'!]: 2}) {}
}
```

## Common fixes

If you are trying to match two different keys, then change one of the keys
in the pattern:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, 'b': 2}) {}
}
```

If you are trying to match the same key, but allow any one of multiple
patterns to match, the use a logical-or pattern:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1 || 2}) {}
}
```
