---
title: inference_failure_on_function_return_type
description: >-
  Details about the inference_failure_on_function_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The return type of '{0}' can't be inferred._

## Description

The analyzer produces this diagnostic when
- the language option `strict-inference` has been enabled in the analysis options file,
- the declaration of a method or function doesn't have a return type, and
- the return type can't be inferred.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the method `m` doesn't
have a return type:

```dart
class C {
  [!m!]() => 7;
}
```

## Common fixes

Add a return type to the method or function:

```dart
class C {
  int m() => 7;
}
```
