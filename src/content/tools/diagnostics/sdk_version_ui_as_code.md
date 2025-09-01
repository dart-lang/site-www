---
title: sdk_version_ui_as_code
description: >-
  Details about the sdk_version_ui_as_code
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The for, if, and spread elements weren't supported until version 2.3.0, but
this code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when a for, if, or spread element is
found in code that has an SDK constraint whose lower bound is less than
2.3.0. Using a for, if, or spread element wasn't supported in earlier
versions, so this code won't be able to run against earlier versions of the
SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.3.0:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

In the package that has that pubspec, code like the following produces
this diagnostic:

```dart
var digits = [[!for (int i = 0; i < 10; i++) i!]];
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the syntax to be used:

```yaml
environment:
  sdk: '>=2.3.0 <2.4.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not make use of those elements:

```dart
var digits = _initializeDigits();

List<int> _initializeDigits() {
  var digits = <int>[];
  for (int i = 0; i < 10; i++) {
    digits.add(i);
  }
  return digits;
}
```
