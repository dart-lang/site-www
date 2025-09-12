---
title: native_field_not_static
description: >-
  Details about the native_field_not_static
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Native fields must be static._

## Description

The analyzer produces this diagnostic when an instance field in a class
has been annotated with `@Native`.
Native fields refer to global variables in C, C++ or other native
languages, whereas instance fields in Dart are specific to an instance of
that class. Hence, native fields must be static.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `f` in the
class `C` is `@Native`, but not `static`:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external int [!f!];
}
```

## Common fixes

Either make the field static:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external static int f;
}
```

Or move it out of a class, in which case no explicit `static` modifier is
required:

```dart
import 'dart:ffi';

class C {
}

@Native<Int>()
external int f;
```

If you meant to annotate an instance field that should be part of a
struct, omit the `@Native` annotation:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int()
  external int f;
}
```

[ffi]: /interop/c-interop
