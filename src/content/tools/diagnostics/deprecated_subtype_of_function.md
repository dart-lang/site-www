---
title: deprecated_subtype_of_function
description: >-
  Details about the deprecated_subtype_of_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Extending 'Function' is deprecated._

_Implementing 'Function' has no effect._

_Mixing in 'Function' is deprecated._

## Description

The analyzer produces this diagnostic when the class `Function` is used in
either the `extends`, `implements`, or `with` clause of a class or mixin.
Using the class `Function` in this way has no semantic value, so it's
effectively dead code.

## Example

The following code produces this diagnostic because `Function` is used as
the superclass of `F`:

```dart
class F extends [!Function!] {}
```

## Common fixes

Remove the class `Function` from whichever clause it's in, and remove the
whole clause if `Function` is the only type in the clause:

```dart
class F {}
```
