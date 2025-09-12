---
title: undefined_class
description: >-
  Details about the undefined_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Undefined class '{0}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
appears to be the name of a class but either isn't defined or isn't visible
in the scope in which it's being referenced.

## Example

The following code produces this diagnostic because `Piont` isn't defined:

```dart
class Point {}

void f([!Piont!] p) {}
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
the name of a class that is defined. The example above can be corrected by
fixing the spelling of the class:

```dart
class Point {}

void f(Point p) {}
```

If the class is defined but isn't visible, then you probably need to add an
import.
