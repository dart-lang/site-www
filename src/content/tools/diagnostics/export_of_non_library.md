---
title: export_of_non_library
description: >-
  Details about the export_of_non_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The exported library '{0}' can't have a part-of directive._

## Description

The analyzer produces this diagnostic when an export directive references a
part rather than a library.

## Example

Given a file `part.dart` containing

```dart
part of lib;
```

The following code produces this diagnostic because the file `part.dart` is
a part, and only libraries can be exported:

```dart
library lib;

export [!'part.dart'!];
```

## Common fixes

Either remove the export directive, or change the URI to be the URI of the
library containing the part.
