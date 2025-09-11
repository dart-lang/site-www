---
title: doc_import_cannot_have_prefix
description: >-
  Details about the doc_import_cannot_have_prefix
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Doc imports can't have prefixes._

## Description

The analyzer produces this diagnostic when a documentation import has a
prefix.

Using prefixes isn't supported for documentation imports.

## Example

The following code produces this diagnostic because the documentation
import declares a prefix:

```dart
/// @docImport 'package:meta/meta.dart' as [!a!];
library;
```

## Common fixes

Remove the prefix:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
