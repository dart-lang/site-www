---
title: ffi_native_invalid_duplicate_default_asset
description: >-
  Details about the ffi_native_invalid_duplicate_default_asset
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_There may be at most one @DefaultAsset annotation on a library._

## Description

The analyzer produces this diagnostic when a library directive has more
than one `DefaultAsset` annotation associated with it.

## Example

The following code produces this diagnostic because the library directive
has two `DefaultAsset` annotations associated with it:

```dart
@DefaultAsset('a')
@[!DefaultAsset!]('b')
library;

import 'dart:ffi';
```

## Common fixes

Remove all but one of the `DefaultAsset` annotations:

```dart
@DefaultAsset('a')
library;

import 'dart:ffi';
```
