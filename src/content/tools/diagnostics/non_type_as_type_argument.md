---
title: non_type_as_type_argument
description: >-
  Details about the non_type_as_type_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The name '{0}' isn't a type, so it can't be used as a type argument._

## Description

The analyzer produces this diagnostic when an identifier that isn't a type
is used as a type argument.

## Example

The following code produces this diagnostic because `x` is a variable, not
a type:

```dart
var x = 0;
List<[!x!]> xList = [];
```

## Common fixes

Change the type argument to be a type:

```dart
var x = 0;
List<int> xList = [];
```
