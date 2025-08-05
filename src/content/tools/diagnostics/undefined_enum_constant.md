---
title: undefined_enum_constant
description: >-
  Details about the undefined_enum_constant
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_There's no constant named '{0}' in '{1}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier
that appears to be the name of an enum value, and the name either isn't
defined or isn't visible in the scope in which it's being referenced.

## Example

The following code produces this diagnostic because `E` doesn't define a
constant named `c`:

```dart
enum E {a, b}

var e = E.[!c!];
```

## Common fixes

If the constant should be defined, then add it to the declaration of the
enum:

```dart
enum E {a, b, c}

var e = E.c;
```

If the constant shouldn't be defined, then change the name to the name of
an existing constant:

```dart
enum E {a, b}

var e = E.b;
```
