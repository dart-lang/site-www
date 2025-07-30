---
title: map_entry_not_in_map
description: >-
  Details about the map_entry_not_in_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Map entries can only be used in a map literal._

## Description

The analyzer produces this diagnostic when a map entry (a key/value pair)
is found in a set literal.

## Example

The following code produces this diagnostic because the literal has a map
entry even though it's a set literal:

```dart
var collection = <String>{[!'a' : 'b'!]};
```

## Common fixes

If you intended for the collection to be a map, then change the code so
that it is a map. In the previous example, you could do this by adding
another type argument:

```dart
var collection = <String, String>{'a' : 'b'};
```

In other cases, you might need to change the explicit type from `Set` to
`Map`.

If you intended for the collection to be a set, then remove the map entry,
possibly by replacing the colon with a comma if both values should be
included in the set:

```dart
var collection = <String>{'a', 'b'};
```
