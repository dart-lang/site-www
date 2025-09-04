---
title: sdk_version_eq_eq_operator_in_const_context
description: >-
  Details about the sdk_version_eq_eq_operator_in_const_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Using the operator '==' for non-primitive types wasn't supported until version 2.3.2, but this code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when the operator `==` is used on a
non-primitive type inside a [constant context][] is found in code that has
an SDK constraint whose lower bound is less than 2.3.2. Using this operator
in a [constant context][] wasn't supported in earlier versions, so this
code won't be able to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

In the package that has that pubspec, code like the following produces this
diagnostic:

```dart
class C {}
const C a = null;
const C b = null;
const bool same = a [!==!] b;
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the operator to be used:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

If you need to support older versions of the SDK, then either rewrite the
code to not use the `==` operator, or change the code so that the
expression isn't in a [constant context][]:

```dart
class C {}
const C a = null;
const C b = null;
bool same = a == b;
```

[constant context]: /resources/glossary#constant-context
