---
title: must_call_super
description: >-
  Details about the must_call_super
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_This method overrides a method annotated as '@mustCallSuper' in '{0}', but
doesn't invoke the overridden method._

## Description

The analyzer produces this diagnostic when a method that overrides a method
that is annotated as [`mustCallSuper`][meta-mustCallSuper] doesn't invoke
the overridden method as required.

## Example

The following code produces this diagnostic because the method `m` in `B`
doesn't invoke the overridden method `m` in `A`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  [!m!]() {}
}
```

## Common fixes

Add an invocation of the overridden method in the overriding method:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  m() {
    super.m();
  }
}
```

[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
