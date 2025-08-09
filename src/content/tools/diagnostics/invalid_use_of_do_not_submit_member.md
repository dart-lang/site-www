---
title: invalid_use_of_do_not_submit_member
description: >-
  Details about the invalid_use_of_do_not_submit_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Uses of '{0}' should not be submitted to source control._

## Description

The analyzer produces this diagnostic when a member that is annotated with
[`@doNotSubmit`][meta-doNotSubmit] is referenced outside of a member
declaration that is also annotated with `@doNotSubmit`.

## Example

Given a file `a.dart` containing the following declaration:

```dart
import 'package:meta/meta.dart';

@doNotSubmit
void emulateCrash() { /* ... */ }
```

The following code produces this diagnostic because the declaration is
being referenced outside of a member that is also annotated with
`@doNotSubmit`:

```dart
import 'a.dart';

void f() {
  [!emulateCrash!]();
}
```

## Common fixes

Most commonly, when complete with local testing, the reference to the
member should be removed.

If building additional functionality on top of the member, annotate the
newly added member with `@doNotSubmit` as well:

```dart
import 'package:meta/meta.dart';

import 'a.dart';

@doNotSubmit
void emulateCrashWithOtherFunctionality() {
  emulateCrash();
  // do other things.
}
```

[meta-doNotSubmit]: https://pub.dev/documentation/meta/latest/meta/doNotSubmit-constant.html
