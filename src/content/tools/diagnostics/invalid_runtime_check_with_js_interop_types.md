---
title: invalid_runtime_check_with_js_interop_types
description: >-
  Details about the invalid_runtime_check_with_js_interop_types
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/invalid_runtime_check_with_js_interop_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Cast from '{0}' to '{1}' casts a Dart value to a JS interop type, which might not be platform-consistent._
_Cast from '{0}' to '{1}' casts a JS interop value to a Dart type, which might not be platform-consistent._
_Cast from '{0}' to '{1}' casts a JS interop value to an incompatible JS interop type, which might not be platform-consistent._
_Runtime check between '{0}' and '{1}' checks whether a Dart value is a JS interop type, which might not be platform-consistent._
_Runtime check between '{0}' and '{1}' checks whether a JS interop value is a Dart type, which might not be platform-consistent._
_Runtime check between '{0}' and '{1}' involves a non-trivial runtime check between two JS interop types that might not be platform-consistent._
_Runtime check between '{0}' and '{1}' involves a runtime check between a JS interop value and an unrelated JS interop type that will always be true and won't check the underlying type._

## Description

The analyzer produces this diagnostic when an `is` test has either:
- a JS interop type on the right-hand side, whether directly or as a type
  argument to another type, or
- a JS interop value on the left-hand side.

## Examples

The following code produces this diagnostic because the JS interop type
`JSBoolean` is on the right-hand side of an `is` test:

```dart
import 'dart:js_interop';

bool f(Object b) => [!b is JSBoolean!];
```

The following code produces this diagnostic because the JS interop type
`JSString` is used as a type argument on the right-hand side of an `is`
test:

```dart
import 'dart:js_interop';

bool f(List<Object> l) => [!l is List<JSString>!];
```

The following code produces this diagnostic because the JS interop value
`a` is on the left-hand side of an `is` test:

```dart
import 'dart:js_interop';

bool f(JSAny a) => [!a is String!];
```

## Common fixes

Use a JS interop helper, such as `isA`, to check the underlying type of
JS interop values:

```dart
import 'dart:js_interop';

void f(Object b) => b.jsify()?.isA<JSBoolean>();
```
