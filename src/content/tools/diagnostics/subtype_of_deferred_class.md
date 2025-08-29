---
title: subtype_of_deferred_class
description: >-
  Details about the subtype_of_deferred_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes and mixins can't implement deferred classes._
_Classes can't extend deferred classes._
_Classes can't mixin deferred classes._

## Description

The analyzer produces this diagnostic when a type (class or mixin) is a
subtype of a class from a library being imported using a deferred import.
The supertypes of a type must be compiled at the same time as the type, and
classes from deferred libraries aren't compiled until the library is
loaded.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines the class `A`:

```dart
class A {}
```

The following code produces this diagnostic because the superclass of `B`
is declared in a deferred library:

```dart
import 'a.dart' deferred as a;

class B extends [!a.A!] {}
```

## Common fixes

If you need to create a subtype of a type from the deferred library, then
remove the `deferred` keyword:

```dart
import 'a.dart' as a;

class B extends a.A {}
```
