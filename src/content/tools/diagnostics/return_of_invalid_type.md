---
title: return_of_invalid_type
description: >-
  Details about the return_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A value of type '{0}' can't be returned from the constructor '{1}' because it has a return type of '{2}'._
_A value of type '{0}' can't be returned from the function '{1}' because it has a return type of '{2}'._
_A value of type '{0}' can't be returned from the method '{1}' because it has a return type of '{2}'._

## Description

The analyzer produces this diagnostic when a method or function returns a
value whose type isn't assignable to the declared return type.

## Example

The following code produces this diagnostic because `f` has a return type
of `String` but is returning an `int`:

```dart
String f() => [!3!];
```

## Common fixes

If the return type is correct, then replace the value being returned with a
value of the correct type, possibly by converting the existing value:

```dart
String f() => 3.toString();
```

If the value is correct, then change the return type to match:

```dart
int f() => 3;
```
