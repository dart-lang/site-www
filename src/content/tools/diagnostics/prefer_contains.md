---
title: prefer_contains
description: >-
  Details about the prefer_contains
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_contains"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Always 'false' because 'indexOf' is always greater than or equal to -1._

_Always 'true' because 'indexOf' is always greater than or equal to -1._

_Unnecessary use of 'indexOf' to test for containment._

## Description

The analyzer produces this diagnostic when the method `indexOf` is used and
the result is only compared with `-1` or `0` in a way where the semantics
are equivalent to using `contains`.

## Example

The following code produces this diagnostic because the condition in the
`if` statement is checking to see whether the list contains the string:

```dart
void f(List<String> l, String s) {
  if ([!l.indexOf(s) < 0!]) {
    // ...
  }
}
```

## Common fixes

Use `contains` instead, negating the condition when necessary:

```dart
void f(List<String> l, String s) {
  if (l.contains(s)) {
    // ...
  }
}
```
