---
title: part_of_non_part
description: >-
  Details about the part_of_non_part
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The included part '{0}' must have a part-of directive._

## Description

The analyzer produces this diagnostic when a part directive is found and
the referenced file doesn't have a part-of directive.

## Example

Given a file `a.dart` containing:

```dart
class A {}
```

The following code produces this diagnostic because `a.dart` doesn't
contain a part-of directive:

```dart
part [!'a.dart'!];
```

## Common fixes

If the referenced file is intended to be a part of another library, then
add a part-of directive to the file:

```dart
part of 'test.dart';

class A {}
```

If the referenced file is intended to be a library, then replace the part
directive with an import directive:

```dart
import 'a.dart';
```
