---
title: default_value_in_function_type
description: >-
  Details about the default_value_in_function_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Parameters in a function type can't have default values._

## Description

The analyzer produces this diagnostic when a function type associated with
a parameter includes optional parameters that have a default value. This
isn't allowed because the default values of parameters aren't part of the
function's type, and therefore including them doesn't provide any value.

## Example

The following code produces this diagnostic because the parameter `p` has a
default value even though it's part of the type of the parameter `g`:

```dart
void f(void Function([int p [!=!] 0]) g) {
}
```

## Common fixes

Remove the default value from the function-type's parameter:

```dart
void f(void Function([int p]) g) {
}
```
