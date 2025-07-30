---
title: non_void_return_for_setter
description: >-
  Details about the non_void_return_for_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The return type of the setter must be 'void' or absent._

## Description

The analyzer produces this diagnostic when a setter is defined with a
return type other than `void`.

## Example

The following code produces this diagnostic because the setter `p` has a
return type of `int`:

```dart
class C {
  [!int!] set p(int i) => 0;
}
```

## Common fixes

Change the return type to `void` or omit the return type:

```dart
class C {
  set p(int i) => 0;
}
```
