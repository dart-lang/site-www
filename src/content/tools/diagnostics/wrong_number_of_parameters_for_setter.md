---
title: wrong_number_of_parameters_for_setter
description: >-
  Details about the wrong_number_of_parameters_for_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Setters must declare exactly one required positional parameter._

## Description

The analyzer produces this diagnostic when a setter is found that doesn't
declare exactly one required positional parameter.

## Examples

The following code produces this diagnostic because the setter `s` declares
two required parameters:

```dart
class C {
  set [!s!](int x, int y) {}
}
```

The following code produces this diagnostic because the setter `s` declares
one optional parameter:

```dart
class C {
  set [!s!]([int? x]) {}
}
```

## Common fixes

Change the declaration so that there's exactly one required positional
parameter:

```dart
class C {
  set s(int x) {}
}
```
