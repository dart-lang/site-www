---
title: implementation_imports
description: >-
  Details about the implementation_imports
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/implementation_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Import of a library in the 'lib/src' directory of another package._

## Description

The analyzer produces this diagnostic when an import references a library
that's inside the `lib/src` directory of a different package, which
violates [the convention for pub
packages](https://dart.dev/tools/pub/package-layout#implementation-files).

## Example

The following code, assuming that it isn't part of the `ffi` package,
produces this diagnostic because the library being imported is inside the
top-level `src` directory:

```dart
import [!'package:ffi/src/allocation.dart'!];
```

## Common fixes

If the library being imported contains code that's part of the public API,
then import the public library that exports the public API:

```dart
import 'package:ffi/ffi.dart';
```

If the library being imported isn't part of the public API of the package,
then either find a different way to accomplish your goal, assuming that
it's possible, or open an issue asking the package authors to make it part
of the public API.
