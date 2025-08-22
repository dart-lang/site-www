---
title: inference_failure_on_collection_literal
description: >-
  Details about the inference_failure_on_collection_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type argument(s) of '{0}' can't be inferred._

## Description

The analyzer produces this diagnostic when
- the language option `strict-inference` has been enabled in the analysis options file,
- a list, map or set literal doesn't have type arguments, and
- the values for the type arguments can't be inferred from the elements.

## Example

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

The following code produces this diagnostic because the type of the
elements of the list literal can't be inferred by the analyzer:

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
