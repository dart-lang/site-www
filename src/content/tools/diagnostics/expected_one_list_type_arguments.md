---
title: expected_one_list_type_arguments
description: >-
  Details about the expected_one_list_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_List literals require one type argument or none, but {0} found._

## Description

The analyzer produces this diagnostic when a list literal has more than one
type argument.

## Example

The following code produces this diagnostic because the list literal has
two type arguments when it can have at most one:

```dart
var l = [!<int, int>!][];
```

## Common fixes

Remove all except one of the type arguments:

```dart
var l = <int>[];
```
