---
title: undefined_hidden_name
description: >-
  Details about the undefined_hidden_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The library '{0}' doesn't export a member with the hidden name '{1}'._

## Description

The analyzer produces this diagnostic when a hide combinator includes a
name that isn't defined by the library being imported.

## Example

The following code produces this diagnostic because `dart:math` doesn't
define the name `String`:

```dart
import 'dart:math' hide [!String!], max;

var x = min(0, 1);
```

## Common fixes

If a different name should be hidden, then correct the name. Otherwise,
remove the name from the list:

```dart
import 'dart:math' hide max;

var x = min(0, 1);
```
