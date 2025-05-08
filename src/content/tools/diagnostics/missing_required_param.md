---
title: missing_required_param
description: >-
  Details about the missing_required_param
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The parameter '{0}' is required._

_The parameter '{0}' is required. {1}._

## Description

The analyzer produces this diagnostic when a method or function with a
named parameter that is annotated as being required is invoked without
providing a value for the parameter.

## Example

The following code produces this diagnostic because the named parameter `x`
is required:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  [!f!]();
}
```

## Common fixes

Provide the required value:

```dart
import 'package:meta/meta.dart';

void f({@required int? x}) {}

void g() {
  f(x: 2);
}
```
