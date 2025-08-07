---
title: abi_specific_integer_invalid
description: >-
  Details about the abi_specific_integer_invalid
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Classes extending 'AbiSpecificInteger' must have exactly one const constructor,
no other members, and no type parameters._

## Description

The analyzer produces this diagnostic when a class that extends
`AbiSpecificInteger` doesn't meet all of the following requirements:
- there must be exactly one constructor
- the constructor must be marked `const`
- there must not be any members of other than the one constructor
- there must not be any type parameters

## Examples

The following code produces this diagnostic because the class `C` doesn't
define a const constructor:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
}
```

The following code produces this diagnostic because the constructor isn't
a `const` constructor:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  C();
}
```

The following code produces this diagnostic because the class `C` defines
multiple constructors:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  const C.zero();
  const C.one();
}
```

The following code produces this diagnostic because the class `C` defines
a field:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!] extends AbiSpecificInteger {
  final int i;

  const C(this.i);
}
```

The following code produces this diagnostic because the class `C` has a
type parameter:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class [!C!]<T> extends AbiSpecificInteger { // type parameters
  const C();
}
```

## Common fixes

Change the class so that it meets the requirements of having no type
parameters and a single member that is a `const` constructor:

```dart
import 'dart:ffi';

@AbiSpecificIntegerMapping({Abi.macosX64 : Int8()})
final class C extends AbiSpecificInteger {
  const C();
}
```
