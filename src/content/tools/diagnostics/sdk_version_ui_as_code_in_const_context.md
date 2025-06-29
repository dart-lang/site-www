---
title: sdk_version_ui_as_code_in_const_context
description: >-
  Details about the sdk_version_ui_as_code_in_const_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The if and spread elements weren't supported in constant expressions until
version 2.5.0, but this code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when an if or spread element inside
a [constant context][] is found in code that has an SDK constraint whose
lower bound is less than 2.5.0. Using an if or spread element inside a
[constant context][] wasn't supported in earlier versions, so this code
won't be able to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.5.0:

```yaml
environment:
  sdk: '>=2.4.0 <2.6.0'
```

In the package that has that pubspec, code like the following produces
this diagnostic:

```dart
const a = [1, 2];
const b = [[!...a!]];
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the syntax to be used:

```yaml
environment:
  sdk: '>=2.5.0 <2.6.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not make use of those elements:

```dart
const a = [1, 2];
const b = [1, 2];
```

If that isn't possible, change the code so that the element isn't in a
[constant context][]:

```dart
const a = [1, 2];
var b = [...a];
```

[constant context]: /resources/glossary#constant-context
