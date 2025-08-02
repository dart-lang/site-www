---
title: sdk_version_constructor_tearoffs
description: >-
  Details about the sdk_version_constructor_tearoffs
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Tearing off a constructor requires the 'constructor-tearoffs' language
feature._

## Description

The analyzer produces this diagnostic when a constructor tear-off is found
in code that has an SDK constraint whose lower bound is less than 2.15.
Constructor tear-offs weren't supported in earlier versions, so this code
won't be able to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.15:

```yaml
environment:
  sdk: '>=2.9.0 <2.15.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
var setConstructor = [!Set.identity!];
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the operator to be used:

```yaml
environment:
  sdk: '>=2.15.0 <2.16.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not use constructor tear-offs:

```dart
var setConstructor = () => Set.identity();
```
