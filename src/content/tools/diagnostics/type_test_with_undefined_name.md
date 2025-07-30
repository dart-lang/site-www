---
title: type_test_with_undefined_name
description: >-
  Details about the type_test_with_undefined_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The name '{0}' isn't defined, so it can't be used in an 'is' expression._

## Description

The analyzer produces this diagnostic when the name following the `is` in a
type test expression isn't defined.

## Example

The following code produces this diagnostic because the name `Srting` isn't
defined:

```dart
void f(Object o) {
  if (o is [!Srting!]) {
    // ...
  }
}
```

## Common fixes

Replace the name with the name of a type:

```dart
void f(Object o) {
  if (o is String) {
    // ...
  }
}
```
