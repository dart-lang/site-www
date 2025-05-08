---
title: part_of_different_library
description: >-
  Details about the part_of_different_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Expected this library to be part of '{0}', not '{1}'._

## Description

The analyzer produces this diagnostic when a library attempts to include a
file as a part of itself when the other file is a part of a different
library.

## Example

Given a file `part.dart` containing

```dart
part of 'library.dart';
```

The following code, in any file other than `library.dart`, produces this
diagnostic because it attempts to include `part.dart` as a part of itself
when `part.dart` is a part of a different library:

```dart
part [!'package:a/part.dart'!];
```

## Common fixes

If the library should be using a different file as a part, then change the
URI in the part directive to be the URI of the other file.

If the [part file][] should be a part of this library, then update the URI
(or library name) in the part-of directive to be the URI (or name) of the
correct library.

[part file]: /resources/glossary#part-file
