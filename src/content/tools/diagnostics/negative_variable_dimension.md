---
title: negative_variable_dimension
description: >-
  Details about the negative_variable_dimension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The variable dimension of a variable-length array must be non-negative._

## Description

The analyzer produces this diagnostic in two cases.

The first is when the variable dimension given in an
`Array.variableWithVariableDimension` annotation is negative. The variable
dimension is the first argument in the annotation.

The second is when the variable dimension given in an
`Array.variableMulti` annotation is negative. The variable dimension is
specified in the `variableDimension` argument of the annotation.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Examples

The following code produces this diagnostic because a variable dimension
of `-1` was provided in the `Array.variableWithVariableDimension`
annotation:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension([!-1!])
  external Array<Uint8> a0;
}
```

The following code produces this diagnostic because a variable dimension
of `-1` was provided in the `Array.variableMulti` annotation:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: [!-1!], [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```

## Common fixes

Change the variable dimension with zero (`0`) or a positive number:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variableWithVariableDimension(1)
  external Array<Uint8> a0;
}
```

Change the variable dimension with zero (`0`) or a positive number:

```dart
import 'dart:ffi';

final class MyStruct2 extends Struct {
  @Array.variableMulti(variableDimension: 1, [1, 2])
  external Array<Array<Array<Uint8>>> a0;
}
```

[ffi]: /interop/c-interop
