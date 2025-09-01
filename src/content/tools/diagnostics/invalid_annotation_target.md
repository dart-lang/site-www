---
title: invalid_annotation_target
description: >-
  Details about the invalid_annotation_target
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation '{0}' can only be used on {1}._

## Description

The analyzer produces this diagnostic when an annotation is applied to a
kind of declaration that it doesn't support.

## Example

The following code produces this diagnostic because the `optionalTypeArgs`
annotation isn't defined to be valid for top-level variables:

```dart
import 'package:meta/meta.dart';

@[!optionalTypeArgs!]
int x = 0;
```

## Common fixes

Remove the annotation from the declaration.
