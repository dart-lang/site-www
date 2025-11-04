---
title: deprecated_instantiate
description: >-
  Details about the deprecated_instantiate
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Instantiating '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a class annotated with
`@Deprecated.instantiate` is instantiated. This annotation indicates that
instantiating the class is deprecated and will soon be removed. This
change will likely be enforced by marking the class as `abstract` or
`sealed`.

## Example

If the library `p` defines a class annotated with
`@Deprecated.instantiate`:

```dart
@Deprecated.instantiate()
class C {}
```

Then, in any library other than `p`, the following code produces this
diagnostic:

```dart
import 'package:p/p.dart';

var c = [!C!]();
```

## Common fixes

Follow any directions found in the `Deprecation.instantiate` annotation.
