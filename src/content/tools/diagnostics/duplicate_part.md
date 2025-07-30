---
title: duplicate_part
description: >-
  Details about the duplicate_part
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The library already contains a part with the URI '{0}'._

## Description

The analyzer produces this diagnostic when a single file is referenced in
multiple part directives.

## Example

Given a file `part.dart` containing

```dart
part of 'test.dart';
```

The following code produces this diagnostic because the file `part.dart` is
included multiple times:

```dart
part 'part.dart';
part [!'part.dart'!];
```

## Common fixes

Remove all except the first of the duplicated part directives:

```dart
part 'part.dart';
```
