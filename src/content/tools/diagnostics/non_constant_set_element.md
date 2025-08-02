---
title: non_constant_set_element
description: >-
  Details about the non_constant_set_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The values in a const set literal must be constants._

## Description

The analyzer produces this diagnostic when a constant set literal contains
an element that isn't a compile-time constant.

## Example

The following code produces this diagnostic because `i` isn't a constant:

```dart
var i = 0;

var s = const {[!i!]};
```

## Common fixes

If the element can be changed to be a constant, then change it:

```dart
const i = 0;

var s = const {i};
```

If the element can't be a constant, then remove the keyword `const`:

```dart
var i = 0;

var s = {i};
```
