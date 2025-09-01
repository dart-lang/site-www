---
title: address_receiver
description: >-
  Details about the address_receiver
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The receiver of '.address' must be a concrete 'TypedData', a concrete
'TypedData' '[]', an 'Array', an 'Array' '[]', a Struct field, or a Union field._

## Description

The analyzer produces this diagnostic when the `.address` getter is used
on a receiver whose static type isn't one of the allowed FFI types. The
`.address` getter is used to obtain a `Pointer` to the underlying memory
of an FFI data structure.

The receiver of `.address` must be one of the following:
- A concrete `TypedData` instance (e.g., `Uint8List`).
- An element of a concrete `TypedData` instance accessed via `[]`.
- An `Array<T>` instance (from `dart:ffi`).
- An element of an `Array<T>` instance accessed via `[]`.
- A field of a `Struct` or `Union` subclass, if that field's type is `Array<T>`, a nested `Struct`, or a nested `Union`.
- A `Struct` or `Union` instance.

## Example

The following code produces this diagnostic for various incorrect receivers:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Uint8()
  external int x;

  @Uint8()
  external int y;
}

@Native<Void Function(Pointer)>(isLeaf: true)
external void nativeLeafCall(Pointer ptr);

void main() {
  final struct = Struct.create<MyStruct>();
  final y = struct.y;
  // Incorrect: The receiver is not a struct field, but some integer.
  nativeLeafCall(y.[!address!]);
}
```

## Common fixes

Ensure that the receiver of the `.address` getter is one of the allowed
types.  The `.address` getter is for obtaining a `Pointer` to the memory
of `TypedData`, `Array`, `Struct`, or `Union` instances, or certain
fields/elements thereof.

```dart
import 'dart:ffi';

@Native<Void Function(Pointer)>(isLeaf: true)
external void nativeLeafCall(Pointer ptr);

final class MyStruct extends Struct {
  @Uint8()
  external int x;

  @Uint8()
  external int y;
}

void main() {
  final struct = Struct.create<MyStruct>();
  // Correct: The receiver is a struct field.
  nativeLeafCall(struct.y.address);
}
```
