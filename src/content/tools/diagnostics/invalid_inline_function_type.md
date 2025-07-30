---
title: invalid_inline_function_type
description: >-
  Details about the invalid_inline_function_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Inline function types can't be used for parameters in a generic function type._

## Description

The analyzer produces this diagnostic when a generic function type has a
function-valued parameter that is written using the older inline function
type syntax.

## Example

The following code produces this diagnostic because the parameter `f`, in
the generic function type used to define `F`, uses the inline function
type syntax:

```dart
typedef F = int Function(int f[!(!]String s));
```

## Common fixes

Use the generic function syntax for the parameter's type:

```dart
typedef F = int Function(int Function(String));
```
