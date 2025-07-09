---
title: invalid_reopen_annotation
description: >-
  Details about the invalid_reopen_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The annotation '@reopen' can only be applied to a class that opens capabilities
that the supertype intentionally disallows._

## Description

The analyzer produces this diagnostic when a `@reopen` annotation has been
placed on a class or mixin that does not remove restrictions placed on the
superclass.

## Example

The following code produces this diagnostic because the class `B` is
annotated with `@reopen` even though it doesn't expand the ability of `A`
to be subclassed:

```dart
import 'package:meta/meta.dart';

sealed class A {}

@[!reopen!]
class B extends A {}
```

## Common fixes

If the superclass should be restricted in a way that the subclass would
change, then modify the superclass to reflect those restrictions:

```dart
import 'package:meta/meta.dart';

interface class A {}

@reopen
class B extends A {}
```

If the superclass is correct, then remove the annotation:

```dart
sealed class A {}

class B extends A {}
```
