---
title: not_map_spread
description: >-
  Details about the not_map_spread
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Spread elements in map literals must implement 'Map'._

## Description

The analyzer produces this diagnostic when the static type of the
expression of a spread element that appears in a map literal doesn't
implement the type `Map`.

## Example

The following code produces this diagnostic because `l` isn't a `Map`:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...[!l!]};
```

## Common fixes

The most common fix is to replace the expression with one that produces a
map:

```dart
var l =  <String>['a', 'b'];
var m = <int, String>{...l.asMap()};
```
