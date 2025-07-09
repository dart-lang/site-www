---
title: invalid_use_of_internal_member
description: >-
  Details about the invalid_use_of_internal_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The member '{0}' can only be used within its package._

## Description

The analyzer produces this diagnostic when a reference to a declaration
that is annotated with the [`internal`][meta-internal] annotation is found
outside the package containing the declaration.

## Example

Given a package `p` that defines a library containing a declaration marked
with the [`internal`][meta-internal] annotation:

```dart
import 'package:meta/meta.dart';

@internal
class C {}
```

The following code produces this diagnostic because it's referencing the
class `C`, which isn't intended to be used outside the package `p`:

```dart
import 'package:p/src/p.dart';

void f([!C!] c) {}
```

## Common fixes

Remove the reference to the internal declaration.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
