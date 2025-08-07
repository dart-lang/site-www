---
title: invalid_use_of_visible_for_overriding_member
description: >-
  Details about the invalid_use_of_visible_for_overriding_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The member '{0}' can only be used for overriding._

## Description

The analyzer produces this diagnostic when an instance member that is
annotated with [`visibleForOverriding`][meta-visibleForOverriding] is
referenced outside the library in which it's declared for any reason other
than to override it.

## Example

Given a file `a.dart` containing the following declaration:

```dart
import 'package:meta/meta.dart';

class A {
  @visibleForOverriding
  void a() {}
}
```

The following code produces this diagnostic because the method `m` is being
invoked even though the only reason it's public is to allow it to be
overridden:

```dart
import 'a.dart';

class B extends A {
  void b() {
    [!a!]();
  }
}
```

## Common fixes

Remove the invalid use of the member.

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
