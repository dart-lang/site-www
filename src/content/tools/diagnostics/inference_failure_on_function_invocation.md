---
title: inference_failure_on_function_invocation
description: >-
  Details about the inference_failure_on_function_invocation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type argument(s) of the function '{0}' can't be inferred._

## Description

The analyzer produces this diagnostic when
- the language option `strict-inference` has been enabled in the analysis options file,
- the invocation of a method or function doesn't have type arguments, and
- the values for the type arguments can't be inferred.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the invocation of the
method `m` doesn't have type arguments and the type arguments can't be
inferred:

```dart
abstract class C {
  void m<T>();
}

void f(C c) {
  c.[!m!]();
}
```

## Common fixes

Provide explicit type arguments for the invocation:

```dart
abstract class C {
  void m<T>();
}

void f(C c) {
  c.m<int>();
}
```
