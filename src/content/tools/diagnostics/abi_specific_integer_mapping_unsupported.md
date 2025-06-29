---
title: abi_specific_integer_mapping_unsupported
description: >-
  Details about the abi_specific_integer_mapping_unsupported
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Invalid mapping to '{0}'; only mappings to 'Int8', 'Int16', 'Int32', 'Int64',
'Uint8', 'Uint16', 'UInt32', and 'Uint64' are supported._

## Description

The analyzer produces this diagnostic when a value in the map argument of
an `AbiSpecificIntegerMapping` annotation is anything other than one of
the following integer types:
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `Uint8`
- `Uint16`
- `UInt32`
- `Uint64`

## Example

The following code produces this diagnostic because the value of the map
entry is `Array<Uint8>`, which isn't a valid integer type:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : [!Array<Uint8>(4)!]})
final class C extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Use one of the valid types as a value in the map:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
