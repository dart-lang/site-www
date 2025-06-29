---
title: empty_catches
description: >-
  Details about the empty_catches
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_catches"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Empty catch block._

## Description

The analyzer produces this diagnostic when the block in a `catch` clause
is empty.

## Example

The following code produces this diagnostic because the catch block is
empty:

```dart
void f() {
  try {
    print('Hello');
  } catch (exception) [!{}!]
}
```

## Common fixes

If the exception shouldn't be ignored, then add code to handle the
exception:

```dart
void f() {
  try {
    print('We can print.');
  } catch (exception) {
    print("We can't print.");
  }
}
```

If the exception is intended to be ignored, then add a comment explaining
why:

```dart
void f() {
  try {
    print('We can print.');
  } catch (exception) {
    // Nothing to do.
  }
}
```

If the exception is intended to be ignored and there isn't any good
explanation for why, then rename the exception parameter:

```dart
void f() {
  try {
    print('We can print.');
  } catch (_) {}
}
```
