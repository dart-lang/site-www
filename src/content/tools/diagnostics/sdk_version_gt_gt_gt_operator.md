---
title: sdk_version_gt_gt_gt_operator
description: >-
  Details about the sdk_version_gt_gt_gt_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The operator '>>>' wasn't supported until version 2.14.0, but this code is
required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when the operator `>>>` is used in
code that has an SDK constraint whose lower bound is less than 2.14.0. This
operator wasn't supported in earlier versions, so this code won't be able
to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.14.0:

```yaml
environment:
 sdk: '>=2.0.0 <2.15.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
int x = 3 [!>>>!] 4;
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the operator to be used:

```yaml
environment:
  sdk: '>=2.14.0 <2.15.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not use the `>>>` operator:

```dart
int x = logicalShiftRight(3, 4);

int logicalShiftRight(int leftOperand, int rightOperand) {
  int divisor = 1 << rightOperand;
  if (divisor == 0) {
    return 0;
  }
  return leftOperand ~/ divisor;
}
```
