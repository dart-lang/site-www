---
title: expected_one_set_type_arguments
description: >-
  Details about the expected_one_set_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Set literals require one type argument or none, but {0} were found._

## Description

The analyzer produces this diagnostic when a set literal has more than one
type argument.

## Example

The following code produces this diagnostic because the set literal has
three type arguments when it can have at most one:

```dart
var s = [!<int, String, int>!]{0, 'a', 1};
```

## Common fixes

Remove all except one of the type arguments:

```dart
var s = <int>{0, 1};
```
