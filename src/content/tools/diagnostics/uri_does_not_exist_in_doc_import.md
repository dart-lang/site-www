---
title: uri_does_not_exist_in_doc_import
description: >-
  Details about the uri_does_not_exist_in_doc_import
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Target of URI doesn't exist: '{0}'._

## Description

The analyzer produces this diagnostic when a doc-import is found where
the URI refers to a file that doesn't exist.

## Examples

If the file `lib.dart` doesn't exist, the following code produces this
diagnostic:

```dart
/// @docImport [!'lib.dart'!];
library;
```

## Common fixes

If the URI was mistyped or invalid, then correct the URI.

If the URI is correct, then create the file.
