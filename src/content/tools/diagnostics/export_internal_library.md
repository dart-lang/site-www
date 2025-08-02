---
title: export_internal_library
description: >-
  Details about the export_internal_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The library '{0}' is internal and can't be exported._

## Description

The analyzer produces this diagnostic when it finds an export whose `dart:`
URI references an internal library.

## Example

The following code produces this diagnostic because `_interceptors` is an
internal library:

```dart
export [!'dart:_interceptors'!];
```

## Common fixes

Remove the export directive.
