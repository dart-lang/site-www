---
title: sdk_version_set_literal
description: >-
  Details about the sdk_version_set_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Set literals weren't supported until version 2.2, but this code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when a set literal is found in code
that has an SDK constraint whose lower bound is less than 2.2.0. Set
literals weren't supported in earlier versions, so this code won't be able
to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.2.0:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
var s = [!<int>{}!];
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the syntax to be used:

```yaml
environment:
  sdk: '>=2.2.0 <2.4.0'
```

If you do need to support older versions of the SDK, then replace the set
literal with code that creates the set without the use of a literal:

```dart
var s = new Set<int>();
```
