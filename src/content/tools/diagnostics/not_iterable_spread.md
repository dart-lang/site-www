---
title: not_iterable_spread
description: >-
  Details about the not_iterable_spread
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Spread elements in list or set literals must implement 'Iterable'._

## Description

The analyzer produces this diagnostic when the static type of the
expression of a spread element that appears in either a list literal or a
set literal doesn't implement the type `Iterable`.

## Example

The following code produces this diagnostic:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...[!m!]};
```

## Common fixes

The most common fix is to replace the expression with one that produces an
iterable object:

```dart
var m = <String, int>{'a': 0, 'b': 1};
var s = <String>{...m.keys};
```
