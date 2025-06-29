---
title: mixin_super_class_constraint_deferred_class
description: >-
  Details about the mixin_super_class_constraint_deferred_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Deferred classes can't be used as superclass constraints._

## Description

The analyzer produces this diagnostic when a superclass constraint of a
mixin is imported from a deferred library.

## Example

The following code produces this diagnostic because the superclass
constraint of `math.Random` is imported from a deferred library:

```dart
import 'dart:async' deferred as async;

mixin M<T> on [!async.Stream<T>!] {}
```

## Common fixes

If the import doesn't need to be deferred, then remove the `deferred`
keyword:

```dart
import 'dart:async' as async;

mixin M<T> on async.Stream<T> {}
```

If the import does need to be deferred, then remove the superclass
constraint:

```dart
mixin M<T> {}
```
