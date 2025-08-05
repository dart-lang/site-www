---
title: invalid_non_virtual_annotation
description: >-
  Details about the invalid_non_virtual_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The annotation '@nonVirtual' can only be applied to a concrete instance member._

## Description

The analyzer produces this diagnostic when the `nonVirtual` annotation is
found on a declaration other than a member of a class, mixin, or enum, or
if the member isn't a concrete instance member.

## Examples

The following code produces this diagnostic because the annotation is on a
class declaration rather than a member inside the class:

```dart
import 'package:meta/meta.dart';

@[!nonVirtual!]
class C {}
```

The following code produces this diagnostic because the method `m` is an
abstract method:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  void m();
}
```

The following code produces this diagnostic because the method `m` is a
static method:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @[!nonVirtual!]
  static void m() {}
}
```

## Common fixes

If the declaration isn't a member of a class, mixin, or enum, then remove
the annotation:

```dart
class C {}
```

If the member is intended to be a concrete instance member, then make it
so:

```dart
import 'package:meta/meta.dart';

abstract class C {
  @nonVirtual
  void m() {}
}
```

If the member is not intended to be a concrete instance member, then
remove the annotation:

```dart
abstract class C {
  static void m() {}
}
```
