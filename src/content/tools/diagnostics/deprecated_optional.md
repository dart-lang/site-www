---
title: deprecated_optional
description: >-
  Details about the deprecated_optional
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Omitting an argument for the '{0}' parameter is deprecated._

## Description

The analyzer produces this diagnostic when an argument is omitted for an
optional parameter annotated with `@Deprecated.optional`. This annotation
indicates that omitting an argument for the parameter is deprecated, and
the parameter will soon become required.

## Example

Given a library `p` that defines a function with an optional parameter
annotated with `@Deprecated.optional`:

```dart
void f({@Deprecated.optional() int a = 0}) {}
```

The following code produces this diagnostic, because the invocation
doesn't pass a value for the parameter `a`:

```dart
import 'package:p/p.dart';

void g() {
  [!f!]();
}
```

## Common fixes

Follow any specific instructions provided in the `@Deprecated.optional`
annotation.

If no instructions are present, pass an appropriate argument for the
corresponding parameter:


```dart
import 'package:p/p.dart';

void g() {
  f(a: 0);
}
```

Using the default value will preserve the current behavior of the code.
