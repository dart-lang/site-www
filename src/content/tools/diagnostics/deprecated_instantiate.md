---
title: deprecated_instantiate
description: >-
  Details about the deprecated_instantiate
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Instantiating '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a class annotated with
`@Deprecated.instantiate` is instantiated. This annotation indicates that
the ability to instantiate the class is deprecated, and will soon be removed,
perhaps by marking the annotated class with `abstract`, or `sealed`.

## Example

If the library `p` defines a class annotated with
`@Deprecated.instantiate`:

```dart
@Deprecated.instantiate()
class C {}
```

Then, the following code, when in a library other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

var c = [!C!]();
```

## Common fixes

Follow any directions found in the `Deprecation.instantiate` annotation.
