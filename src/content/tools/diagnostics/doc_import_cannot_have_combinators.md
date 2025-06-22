---
title: doc_import_cannot_have_combinators
description: >-
  Details about the doc_import_cannot_have_combinators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Doc imports can't have show or hide combinators._

## Description

The analyzer produces this diagnostic when a documentation import has one
or more `hide` or `show` combinators.

Using combinators isn't supported for documentation imports.

## Example

The following code produces this diagnostic because the documentation
import has a `show` combinator:

```dart
/// @docImport 'package:meta/meta.dart' [!show max!];
library;
```

## Common fixes

Remove the `hide` and `show` combinators:

```dart
/// @docImport 'package:meta/meta.dart';
library;
```
