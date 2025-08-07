---
title: invalid_factory_method_decl
description: >-
  Details about the invalid_factory_method_decl
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Factory method '{0}' must have a return type._

## Description

The analyzer produces this diagnostic when a method that is annotated with
the [`factory`][meta-factory] annotation has a return type of `void`.

## Example

The following code produces this diagnostic because the method `createC`
is annotated with the [`factory`][meta-factory] annotation but doesn't
return any value:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  void [!createC!]() {}
}

class C {}
```

## Common fixes

Change the return type to something other than `void`:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
