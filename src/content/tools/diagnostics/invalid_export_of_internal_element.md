---
title: invalid_export_of_internal_element
description: >-
  Details about the invalid_export_of_internal_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The member '{0}' can't be exported as a part of a package's public API._

## Description

The analyzer produces this diagnostic when a [public library][] exports a
declaration that is marked with the [`internal`][meta-internal]
annotation.

## Example

Given a file `a.dart` in the `src` directory that contains:

```dart
import 'package:meta/meta.dart';

@internal class One {}
```

The following code, when found in a [public library][] produces this
diagnostic because the `export` directive is exporting a name that is only
intended to be used internally:

```dart
[!export 'src/a.dart';!]
```

## Common fixes

If the export is needed, then add a `hide` clause to hide the internal
names:

```dart
export 'src/a.dart' hide One;
```

If the export isn't needed, then remove it.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
