---
title: deprecated_extend
description: >-
  Details about the deprecated_extend
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Extending '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a class annotated with
`@Deprecated.extend` is used in the `extends` clause of a class
declaration.

This annotation indicates that the ability for classes to extend the
annotated class is deprecated, and will soon be removed, perhaps by
marking the annotated class with `interface`, `final`, or `sealed`.

## Example

If the library `p` defines a class annotated with `@Deprecated.extend`:

```dart
@Deprecated.extend()
class C {}
```

Then, the following code, when in a library other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Common fixes

Follow any directions found in the `Deprecation.extend` annotation, or
just remove the `extends` clause.

```dart
class D {}
```
