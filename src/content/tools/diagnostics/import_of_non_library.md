---
title: import_of_non_library
description: >-
  Details about the import_of_non_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The imported library '{0}' can't have a part-of directive._

## Description

The analyzer produces this diagnostic when a [part file][] is imported
into a library.

## Example

Given a [part file][] named `part.dart` containing the following:

```dart
part of lib;
```

The following code produces this diagnostic because imported files can't
have a part-of directive:

```dart
library lib;

import [!'part.dart'!];
```

## Common fixes

Import the library that contains the [part file][] rather than the
[part file][] itself.

[part file]: /resources/glossary#part-file
