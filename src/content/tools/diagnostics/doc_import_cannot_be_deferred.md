---
title: doc_import_cannot_be_deferred
description: >-
  Details about the doc_import_cannot_be_deferred
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Doc imports can't be deferred._

## Description

The analyzer produces this diagnostic when a documentation import uses the
`deferred` keyword.

Documentation imports can't be deferred because deferring them wouldn't
impact the size of the compiled code.

## Example

The following code produces this diagnostic because the documentation
import has a `deferred` keyword:

```dart
// ignore:missing_prefix_in_deferred_import
/// @docImport 'package:meta/meta.dart' [!deferred!];
library;
```

## Common fixes

Remove the `deferred` keyword:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
