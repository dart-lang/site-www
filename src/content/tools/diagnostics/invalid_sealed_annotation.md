---
title: invalid_sealed_annotation
description: >-
  Details about the invalid_sealed_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The annotation '@sealed' can only be applied to classes._

## Description

The analyzer produces this diagnostic when a declaration other than a
class declaration has the `@sealed` annotation on it.

## Example

The following code produces this diagnostic because the `@sealed`
annotation is on a method declaration:

```dart
import 'package:meta/meta.dart';

class A {
  @[!sealed!]
  void m() {}
}
```

## Common fixes

Remove the annotation:

```dart
class A {
  void m() {}
}
```
