---
title: import_internal_library
description: >-
  Details about the import_internal_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The library '{0}' is internal and can't be imported._

## Description

The analyzer produces this diagnostic when it finds an import whose `dart:`
URI references an internal library.

## Example

The following code produces this diagnostic because `_interceptors` is an
internal library:

```dart
import [!'dart:_interceptors'!];
```

## Common fixes

Remove the import directive.
