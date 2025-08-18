---
title: deprecated_implement
description: >-
  Details about the deprecated_implement
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Implementing '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a class annotated with
`@Deprecated.implement` is used in the `implements` clause of a class or
enum declaration. This annotation indicates that the ability for classes
to implement the annotated class is deprecated, and will soon be removed,
perhaps by marking the annotated class with `interface`, `final`, or
`sealed`.

## Example

If the library `p` defines a class annotated with `@Deprecated.implement`:

```dart
@Deprecated.implement()
class C {}
```

Then, the following code, when in a library other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D implements [!C!] {}
```

## Common fixes

Follow any directions found in the `Deprecation.implement` annotation, or
just remove the class name from the `implements` clause.

```dart
class D {}
```
