---
title: non_const_generative_enum_constructor
description: >-
  Details about the non_const_generative_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Generative enum constructors must be 'const'._

## Description

The analyzer produces this diagnostic when an enum declaration contains a
generative constructor that isn't marked as `const`.

## Example

The following code produces this diagnostic because the constructor in `E`
isn't marked as being `const`:

```dart
enum E {
  e;

  [!E!]();
}
```

## Common fixes

Add the `const` keyword before the constructor:

```dart
enum E {
  e;

  const E();
}
```
