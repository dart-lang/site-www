---
title: invalid_literal_annotation
description: >-
  Details about the invalid_literal_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Only const constructors can have the `@literal` annotation._

## Description

The analyzer produces this diagnostic when the [`literal`][meta-literal]
annotation is applied to anything other than a const constructor.

## Examples

The following code produces this diagnostic because the constructor isn't
a `const` constructor:

```dart
import 'package:meta/meta.dart';

class C {
  @[!literal!]
  C();
}
```

The following code produces this diagnostic because `x` isn't a
constructor:

```dart
import 'package:meta/meta.dart';

@[!literal!]
var x;
```

## Common fixes

If the annotation is on a constructor and the constructor should always be
invoked with `const`, when possible, then mark the constructor with the
`const` keyword:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}
```

If the constructor can't be marked as `const`, then remove the annotation.

If the annotation is on anything other than a constructor, then remove the
annotation:

```dart
var x;
```

[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
