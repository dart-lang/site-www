---
title: avoid_function_literals_in_foreach_calls
description: >-
  Details about the avoid_function_literals_in_foreach_calls
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_function_literals_in_foreach_calls"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Function literals shouldn't be passed to 'forEach'._

## Description

The analyzer produces this diagnostic when the argument to
`Iterable.forEach` is a closure.

## Example

The following code produces this diagnostic because the argument to the
invocation of `forEach` is a closure:

```dart
void f(Iterable<String> s) {
  s.[!forEach!]((e) => print(e));
}
```

## Common fixes

If the closure can be replaced by a tear-off, then replace the closure:

```dart
void f(Iterable<String> s) {
  s.forEach(print);
}
```

If the closure can't be replaced by a tear-off, then use a `for` loop to
iterate over the elements:

```dart
void f(Iterable<String> s) {
  for (var e in s) {
    print(e);
  }
}
```
