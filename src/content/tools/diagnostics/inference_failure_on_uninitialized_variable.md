---
title: inference_failure_on_uninitialized_variable
description: >-
  Details about the inference_failure_on_uninitialized_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type of {0} can't be inferred without either a type or initializer._

## Description

The analyzer produces this diagnostic when
- the language option `strict-inference` has been enabled in the analysis options file,
- the declaration of a variable doesn't have a type, and
- the type of the variable can't be inferred.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the variable `s`
doesn't have an explicit type and the type can't be inferred because
there's no initializer:

```dart
var [!s!];
```

## Common fixes

Add an explicit type:

```dart
String? s;
```
