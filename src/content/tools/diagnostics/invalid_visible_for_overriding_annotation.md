---
title: invalid_visible_for_overriding_annotation
description: >-
  Details about the invalid_visible_for_overriding_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation 'visibleForOverriding' can only be applied to a public instance
member that can be overridden._

## Description

The analyzer produces this diagnostic when anything other than a public
instance member of a class is annotated with
[`visibleForOverriding`][meta-visibleForOverriding]. Because only public
instance members can be overridden outside the defining library, there's
no value to annotating any other declarations.

## Example

The following code produces this diagnostic because the annotation is on a
class, and classes can't be overridden:

```dart
import 'package:meta/meta.dart';

@[!visibleForOverriding!]
class C {}
```

## Common fixes

Remove the annotation:

```dart
class C {}
```

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
