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

This annotation indicates that extending or implementing the annotated
class is deprecated and will soon be removed. This change will likely be
enforced by marking the class with `final` or `sealed`.

## Example

If the library `p` defines a class annotated with `@Deprecated.subclass`:

```dart
@Deprecated.subclass()
class C {}
```

Then, in any library other than `p`, the following code produces this
diagnostic:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Common fixes

Follow any specific instructions provided in the `@Deprecated.subclass`
annotation. Otherwise, remove the relevant `extends` clause or remove the
class name from the `implements` clause:

```dart
class D {}
```
