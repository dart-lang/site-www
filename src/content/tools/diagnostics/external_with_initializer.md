---
title: external_with_initializer
description: >-
  Details about the external_with_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_External fields can't have initializers._
_External variables can't have initializers._

## Description

The analyzer produces this diagnostic when a field or variable marked with
the keyword `external` has an initializer, or when an external field is
initialized in a constructor.

## Examples

The following code produces this diagnostic because the external field `x`
is assigned a value in an initializer:

```dart
class C {
  external int x;
  C() : [!x!] = 0;
}
```

The following code produces this diagnostic because the external field `x`
has an initializer:

```dart
class C {
  external final int [!x!] = 0;
}
```

The following code produces this diagnostic because the external top level
variable `x` has an initializer:

```dart
external final int [!x!] = 0;
```

## Common fixes

Remove the initializer:

```dart
class C {
  external final int x;
}
```
