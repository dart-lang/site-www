---
title: sdk_version_async_exported_from_core
description: >-
  Details about the sdk_version_async_exported_from_core
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The class '{0}' wasn't exported from 'dart:core' until version 2.1, but this
code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when either the class `Future` or
`Stream` is referenced in a library that doesn't import `dart:async` in
code that has an SDK constraint whose lower bound is less than 2.1.0. In
earlier versions, these classes weren't defined in `dart:core`, so the
import was necessary.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.1.0:

```yaml
environment:
  sdk: '>=2.0.0 <2.4.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
void f([!Future!] f) {}
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the classes to be referenced:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

If you need to support older versions of the SDK, then import the
`dart:async` library.

```dart
import 'dart:async';

void f(Future f) {}
```
