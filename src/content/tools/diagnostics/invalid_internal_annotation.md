---
title: invalid_internal_annotation
description: >-
  Details about the invalid_internal_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Only public elements in a package's private API can be annotated as being internal._

## Description

The analyzer produces this diagnostic when a declaration is annotated with
the [`internal`][meta-internal] annotation and that declaration is either
in a [public library][] or has a private name.

## Example

The following code, when in a [public library][], produces this diagnostic
because the [`internal`][meta-internal] annotation can't be applied to
declarations in a [public library][]:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class C {}
```

The following code, whether in a public or internal library, produces this
diagnostic because the [`internal`][meta-internal] annotation can't be
applied to declarations with private names:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class _C {}

void f(_C c) {}
```

## Common fixes

If the declaration has a private name, then remove the annotation:

```dart
class _C {}

void f(_C c) {}
```

If the declaration has a public name and is intended to be internal to the
package, then move the annotated declaration into an internal library (in
other words, a library inside the `src` directory).

Otherwise, remove the use of the annotation:

```dart
class C {}
```

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
