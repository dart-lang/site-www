---
title: instantiate_enum
description: >-
  Details about the instantiate_enum
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Enums can't be instantiated._

## Description

The analyzer produces this diagnostic when an enum is instantiated. It's
invalid to create an instance of an enum by invoking a constructor; only
the instances named in the declaration of the enum can exist.

## Example

The following code produces this diagnostic because the enum `E` is being
instantiated:

```dart
// @dart = 2.16
enum E {a}

var e = [!E!]();
```

## Common fixes

If you intend to use an instance of the enum, then reference one of the
constants defined in the enum:

```dart
// @dart = 2.16
enum E {a}

var e = E.a;
```

If you intend to use an instance of a class, then use the name of that class in place of the name of the enum.
