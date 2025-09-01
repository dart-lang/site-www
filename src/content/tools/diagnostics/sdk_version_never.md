---
title: sdk_version_never
description: >-
  Details about the sdk_version_never
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type 'Never' wasn't supported until version 2.12.0, but this code is
required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when a reference to the class `Never`
is found in code that has an SDK constraint whose lower bound is less than
2.12.0. This class wasn't defined in earlier versions, so this code won't
be able to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.12.0:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
[!Never!] n;
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the type to be used:

```yaml
environment:
  sdk: '>=2.12.0 <2.13.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not reference this class:

```dart
dynamic x;
```
