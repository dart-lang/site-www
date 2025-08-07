---
title: empty_struct
description: >-
  Details about the empty_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The class '{0}' can't be empty because it's a subclass of '{1}'._

## Description

The analyzer produces this diagnostic when a subclass of `Struct` or
`Union` doesn't have any fields. Having an empty `Struct` or `Union`
isn't supported.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the class `C`, which
extends `Struct`, doesn't declare any fields:

```dart
import 'dart:ffi';

final class [!C!] extends Struct {}
```

## Common fixes

If the class is intended to be a struct, then declare one or more fields:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

If the class is intended to be used as a type argument to `Pointer`, then
make it a subclass of `Opaque`:

```dart
import 'dart:ffi';

final class C extends Opaque {}
```

If the class isn't intended to be a struct, then remove or change the
extends clause:

```dart
class C {}
```

[ffi]: /interop/c-interop
