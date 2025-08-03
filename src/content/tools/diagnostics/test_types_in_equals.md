---
title: test_types_in_equals
description: >-
  Details about the test_types_in_equals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/test_types_in_equals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing type test for '{0}' in '=='._

## Description

The analyzer produces this diagnostic when an override of the `==`
operator doesn't include a type test on the value of the parameter.

## Example

The following code produces this diagnostic because `other` is not type
tested:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return ([!other as C!]).f == f;
  }
}
```

## Common fixes

Perform an `is` test as part of computing the return value:

```dart
class C {
  final int f;

  C(this.f);

  @override
  bool operator ==(Object other) {
    return other is C && other.f == f;
  }
}
```
