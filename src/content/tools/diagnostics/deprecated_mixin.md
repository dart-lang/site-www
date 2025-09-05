---
title: deprecated_mixin
description: >-
  Details about the deprecated_mixin
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Mixing in '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a mixin class annotated with
`@Deprecated.mixin` is used in the `with` clause of a class or enum
declaration. This annotation indicates that the ability for classes
to mixin the annotated mixin class is deprecated, and will soon be
removed, perhaps by removing the `mixin` class modifier.

## Example

If the library `p` defines a class annotated with `@Deprecated.mixin`:

```dart
@Deprecated.mixin()
mixin class C {}
```

Then, the following code, when in a library other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D with [!C!] {}
```

## Common fixes

Follow any directions found in the `Deprecation.mixin` annotation, or
just remove the mixin class name from the `with` clause.

```dart
class D {}
```
