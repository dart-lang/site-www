---
title: deprecated_subclass
description: >-
  Details about the deprecated_subclass
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Subclassing '{0}' is deprecated._

## Description

The analyzer produces this diagnostic when a class annotated with
`@Deprecated.subclass` is used in the `extends` clause of a class
declaration, or the `implements` clause of a class or enum declaration.

This annotation indicates that the ability for classes or enums to extend
or implement the annotated class is deprecated, and will soon be removed,
perhaps by marking the annotated class with `final` or `sealed`.

## Example

If the library `p` defines a class annotated with `@Deprecated.subclass`:

```dart
@Deprecated.subclass()
class C {}
```

Then, the following code, when in a library other than `p`, produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Common fixes

If the annotation contains a description of how to deal with not being
able to subclass the class, then try following those directions.

If the annotation doesn't contain a description, or if the described
approach isn't appropriate for your case, then remove the relevant
`extends` clause or remove the class name from the `implements` clause:

```dart
class D {}
```
