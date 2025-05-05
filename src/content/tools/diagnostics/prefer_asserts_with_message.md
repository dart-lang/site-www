---
title: prefer_asserts_with_message
description: >-
  Details about the prefer_asserts_with_message
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_asserts_with_message"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing a message in an assert._

## Description

The analyzer produces this diagnostic when an assert statement doesn't
have a message.

## Example

The following code produces this diagnostic because there's no message
in the assert statement:

```dart
void f(String s) {
  [!assert(s.isNotEmpty);!]
}
```

## Common fixes

Add a message to the assert statement:

```dart
void f(String s) {
  assert(s.isNotEmpty, 'The argument must not be empty.');
}
```
