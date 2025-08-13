---
title: uri_does_not_exist
description: >-
  Details about the uri_does_not_exist
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Target of URI doesn't exist: '{0}'._

## Description

The analyzer produces this diagnostic when an import, export, or part
directive is found where the URI refers to a file that doesn't exist.

## Examples

If the file `lib.dart` doesn't exist, the following code produces this
diagnostic:

```dart
import [!'lib.dart'!];
```

## Common fixes

If the URI was mistyped or invalid, then correct the URI.

If the URI is correct, then create the file.
