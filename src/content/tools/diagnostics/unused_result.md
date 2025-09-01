---
title: unused_result
description: >-
  Details about the unused_result
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' should be used. {1}._

_The value of '{0}' should be used._

## Description

The analyzer produces this diagnostic when a function annotated with
[`useResult`][meta-useResult] is invoked, and the value returned by that
function isn't used. The value is considered to be used if a member of the
value is invoked, if the value is passed to another function, or if the
value is assigned to a variable or field.

## Example

The following code produces this diagnostic because the invocation of
`c.a()` isn't used, even though the method `a` is annotated with
[`useResult`][meta-useResult]:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.[!a!]();
}
```

## Common fixes

If you intended to invoke the annotated function, then use the value that
was returned:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  print(c.a());
}
```

If you intended to invoke a different function, then correct the name of
the function being invoked:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.b();
}
```

[meta-useResult]: https://pub.dev/documentation/meta/latest/meta/useResult-constant.html
