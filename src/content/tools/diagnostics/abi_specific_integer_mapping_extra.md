---
title: abi_specific_integer_mapping_extra
description: >-
  Details about the abi_specific_integer_mapping_extra
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one
'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Description

The analyzer produces this diagnostic when a class that extends
`AbiSpecificInteger` has more than one `AbiSpecificIntegerMapping`
annotation.

## Example

The following code produces this diagnostic because there are two
`AbiSpecificIntegerMapping` annotations on the class `C`:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
@[!AbiSpecificIntegerMapping!]({Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Remove all but one of the annotations, merging the arguments as
appropriate:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8(), Abi.linuxX64 : Uint16()})
final class C extends AbiSpecificInteger {
  const C();
}
```
