---
title: prefer_is_not_operator
description: >-
  Details about the prefer_is_not_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_not_operator"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the 'is!' operator rather than negating the value of the 'is' operator._

## Description

The analyzer produces this diagnostic when the prefix `!` operator is used
to negate the result of an `is` test.

## Example

The following code produces this diagnostic because the result of testing
to see whether `o` is a `String` is negated using the prefix `!` operator:

```dart
String f(Object o) {
  if ([!!(o is String)!]) {
    return o.toString();
  }
  return o;
}
```

## Common fixes

Use the `is!` operator instead:

```dart
String f(Object o) {
  if (o is! String) {
    return o.toString();
  }
  return o;
}
```
