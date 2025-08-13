---
title: ambiguous_import
description: >-
  Details about the ambiguous_import
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The name '{0}' is defined in the libraries {1}._

## Description

The analyzer produces this diagnostic when a name is referenced that is
declared in two or more imported libraries.

## Example

Given a library (`a.dart`) that defines a class (`C` in this example):

```dart
class A {}
class C {}
```

And a library (`b.dart`) that defines a different class with the same name:

```dart
class B {}
class C {}
```

The following code produces this diagnostic:

```dart
import 'a.dart';
import 'b.dart';

void f([!C!] c1, [!C!] c2) {}
```

## Common fixes

If any of the libraries aren't needed, then remove the import directives
for them:

```dart
import 'a.dart';

void f(C c1, C c2) {}
```

If the name is still defined by more than one library, then add a `hide`
clause to the import directives for all except one library:

```dart
import 'a.dart' hide C;
import 'b.dart';

void f(C c1, C c2) {}
```

If you must be able to reference more than one of these types, then add a
prefix to each of the import directives, and qualify the references with
the appropriate prefix:

```dart
import 'a.dart' as a;
import 'b.dart' as b;

void f(a.C c1, b.C c2) {}
```
