---
title: non_void_return_for_operator
description: >-
  Details about the non_void_return_for_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The return type of the operator []= must be 'void'._

## Description

The analyzer produces this diagnostic when a declaration of the operator
`[]=` has a return type other than `void`.

## Example

The following code produces this diagnostic because the declaration of the
operator `[]=` has a return type of `int`:

```dart
class C {
  [!int!] operator []=(int index, int value) => 0;
}
```

## Common fixes

Change the return type to `void`:

```dart
class C {
  void operator []=(int index, int value) => 0;
}
```
