---
title: unused_import
description: >-
  Details about the unused_import
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Unused import: '{0}'._

## Description

The analyzer produces this diagnostic when an import isn't needed because
none of the names that are imported are referenced within the importing
library.

## Example

The following code produces this diagnostic because nothing defined in
`dart:async` is referenced in the library:

```dart
import [!'dart:async'!];

void main() {}
```

## Common fixes

If the import isn't needed, then remove it.

If some of the imported names are intended to be used, then add the missing
code.
