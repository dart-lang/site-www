---
title: prefer_inlined_adds
description: >-
  Details about the prefer_inlined_adds
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_inlined_adds"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The addition of a list item could be inlined._

_The addition of multiple list items could be inlined._

## Description

The analyzer produces this diagnostic when the methods `add` and `addAll`
are invoked on a list literal where the elements being added could be
included in the list literal.

## Example

The following code produces this diagnostic because the `add` method is
being used to add `b`, when it could have been included directly in the
list literal:

```dart
List<String> f(String a, String b) {
  return [a]..[!add!](b);
}
```

The following code produces this diagnostic because the `addAll` method is
being used to add the elements of `b`, when it could have been included
directly in the list literal:

```dart
List<String> f(String a, List<String> b) {
  return [a]..[!addAll!](b);
}
```

## Common fixes

If the `add` method is being used, then make the argument an element of
the list and remove the invocation:

```dart
List<String> f(String a, String b) {
  return [a, b];
}
```

If the `addAll` method is being used, then use the spread operator on the
argument to add its elements to the list and remove the invocation:

```dart
List<String> f(String a, List<String> b) {
  return [a, ...b];
}
```
