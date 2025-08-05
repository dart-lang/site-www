---
title: invalid_await_not_required_annotation
description: >-
  Details about the invalid_await_not_required_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The annotation 'awaitNotRequired' can only be applied to a Future-returning function, or a Future-typed field._

## Description

The analyzer produces this diagnostic when anything other than a
`Future`-returning function or a `Future`-typed field or top-level
variable is annotated with [`awaitNotRequired`][meta-awaitNotRequired].

## Example

The following code produces this diagnostic because the annotation is on a
`void`-returning function:

```dart
import 'package:meta/meta.dart';

@[!awaitNotRequired!]
void f() {}
```

## Common fixes

Remove the annotation:

```dart
void f() {}
```

[meta-awaitNotRequired]: https://pub.dev/documentation/meta/latest/meta/awaitNotRequired-constant.html
