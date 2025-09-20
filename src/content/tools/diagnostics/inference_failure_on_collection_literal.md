---
title: inference_failure_on_collection_literal
description: >-
  Details about the inference_failure_on_collection_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type argument(s) of '{0}' can't be inferred._

## Description

The analyzer produces this diagnostic when:
- the language option `strict-inference` is enabled in the analysis options file,
- a list, map, or set literal has no type arguments, and
- the values for the type arguments can't be inferred from the elements.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the type of the list
literal's elements can't be inferred:

```dart
void f() {
  var list = [![]!];
  print(list);
}
```

## Common fixes

Provide explicit type arguments for the literal:

```dart
void f() {
  var list = <int>[];
  print(list);
}
```
