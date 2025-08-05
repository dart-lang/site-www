---
title: abi_specific_integer_mapping_missing
description: >-
  Details about the abi_specific_integer_mapping_missing
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

## Description

The analyzer produces this diagnostic when a class that extends
`AbiSpecificInteger` doesn't have an `AbiSpecificIntegerMapping`
annotation.

## Example

The following code produces this diagnostic because there's no
`AbiSpecificIntegerMapping` annotation on the class `C`:

```dart
import 'dart:ffi';

final class [!C!] extends AbiSpecificInteger {
  const C();
}
```

## Common fixes

Add an `AbiSpecificIntegerMapping` annotation to the class:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
