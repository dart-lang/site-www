---
title: undefined_shown_name
description: >-
  Details about the undefined_shown_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The library '{0}' doesn't export a member with the shown name '{1}'._

## Description

The analyzer produces this diagnostic when a show combinator includes a
name that isn't defined by the library being imported.

## Example

The following code produces this diagnostic because `dart:math` doesn't
define the name `String`:

```dart
import 'dart:math' show min, [!String!];

var x = min(0, 1);
```

## Common fixes

If a different name should be shown, then correct the name. Otherwise,
remove the name from the list:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```
