---
title: inference_failure_on_untyped_parameter
description: >-
  Details about the inference_failure_on_untyped_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type of {0} can't be inferred; a type must be explicitly provided._

## Description

The analyzer produces this diagnostic when
- the language option `strict-inference` has been enabled in the analysis options file,
- the declaration of a formal parameter doesn't have a type, and
- the type of the parameter can't be inferred.

The type of a parameter of a method can be inferred if the method
overrides an inherited method.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the formal parameter
`p` doesn't have an explicit type and the type can't be inferred:

```dart
void f([!p!]) => print(p);
```

## Common fixes

Add an explicit type:

```dart
void f(int p) => print(p);
```
