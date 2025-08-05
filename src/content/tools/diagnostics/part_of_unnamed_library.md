---
title: part_of_unnamed_library
description: >-
  Details about the part_of_unnamed_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The library is unnamed. A URI is expected, not a library name '{0}', in the part-of directive._

## Description

The analyzer produces this diagnostic when a library that doesn't have a
`library` directive (and hence has no name) contains a `part` directive
and the `part of` directive in the [part file][] uses a name to specify
the library that it's a part of.

## Example

Given a [part file][] named `part_file.dart` containing the following
code:

```dart
part of lib;
```

The following code produces this diagnostic because the library including
the [part file][] doesn't have a name even though the [part file][] uses a
name to specify which library it's a part of:

```dart
part [!'part_file.dart'!];
```

## Common fixes

Change the `part of` directive in the [part file][] to specify its library
by URI:

```dart
part of 'test.dart';
```

[part file]: /resources/glossary#part-file
