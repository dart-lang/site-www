---
title: field_initializer_outside_constructor
description: >-
  Details about the field_initializer_outside_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Field formal parameters can only be used in a constructor._

_Initializing formal parameters can only be used in constructors._

## Description

The analyzer produces this diagnostic when an initializing formal
parameter is used in the parameter list for anything other than a
constructor.

## Example

The following code produces this diagnostic because the initializing
formal parameter `this.x` is being used in the method `m`:

```dart
class A {
  int x = 0;

  m([[!this.x!] = 0]) {}
}
```

## Common fixes

Replace the initializing formal parameter with a normal parameter and
assign the field within the body of the method:

```dart
class A {
  int x = 0;

  m([int x = 0]) {
    this.x = x;
  }
}
```
