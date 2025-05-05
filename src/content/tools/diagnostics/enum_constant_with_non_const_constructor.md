---
title: enum_constant_with_non_const_constructor
description: >-
  Details about the enum_constant_with_non_const_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The invoked constructor isn't a 'const' constructor._

## Description

The analyzer produces this diagnostic when an enum value is being created
using either a factory constructor or a generative constructor that isn't
marked as being `const`.

## Example

The following code produces this diagnostic because the enum value `e` is
being initialized by a factory constructor:

```dart
enum E {
  [!e!]();

  factory E() => e;
}
```

## Common fixes

Use a generative constructor marked as `const`:

```dart
enum E {
  e._();

  factory E() => e;

  const E._();
}
```
