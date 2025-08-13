---
title: uri_with_interpolation
description: >-
  Details about the uri_with_interpolation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_URIs can't use string interpolation._

## Description

The analyzer produces this diagnostic when the string literal in an
`import`, `export`, or `part` directive contains an interpolation. The
resolution of the URIs in directives must happen before the declarations
are compiled, so expressions can't be  evaluated  while determining the
values of the URIs.

## Example

The following code produces this diagnostic because the string in the
`import` directive contains an interpolation:

```dart
import [!'dart:$m'!];

const m = 'math';
```

## Common fixes

Remove the interpolation from the URI:

```dart
import 'dart:math';

var zero = min(0, 0);
```
