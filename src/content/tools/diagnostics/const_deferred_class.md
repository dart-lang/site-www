---
title: const_deferred_class
description: >-
  Details about the const_deferred_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Deferred classes can't be created with 'const'._

## Description

The analyzer produces this diagnostic when a class from a library that is
imported using a deferred import is used to create a `const` object.
Constants are evaluated at compile time, and classes from deferred
libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

The following code produces this diagnostic because it attempts to create a
`const` instance of a class from a deferred library:

```dart
import 'dart:convert' deferred as convert;

const json2 = [!convert.JsonCodec()!];
```

## Common fixes

If the object isn't required to be a constant, then change the code so that
a non-constant instance is created:

```dart
import 'dart:convert' deferred as convert;

final json2 = convert.JsonCodec();
```

If the object must be a constant, then remove `deferred` from the import
directive:

```dart
import 'dart:convert' as convert;

const json2 = convert.JsonCodec();
```
