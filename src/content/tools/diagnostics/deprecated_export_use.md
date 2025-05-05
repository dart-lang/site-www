---
title: deprecated_export_use
description: >-
  Details about the deprecated_export_use
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The ability to import '{0}' indirectly is deprecated._

## Description

The analyzer produces this diagnostic when one library imports a name from
a second library, and the second library exports the name from a third
library but has indicated that it won't export the third library in the
future.

## Example

Given a library `a.dart` defining the class `A`:

```dart
class A {}
```

And a second library `b.dart` that exports `a.dart` but has marked the
export as being deprecated:

```dart
import 'a.dart';

@deprecated
export 'a.dart';
```

The following code produces this diagnostic because the class `A` won't be
exported from `b.dart` in some future version:

```dart
import 'b.dart';

[!A!]? a;
```

## Common fixes

If the name is available from a different library that you can import,
then replace the existing import with an import for that library (or add
an import for the defining library if you still need the old import):

```dart
import 'a.dart';

A? a;
```

If the name isn't available, then look for instructions from the library
author or contact them directly to find out how to update your code.
