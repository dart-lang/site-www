---
title: always_put_control_body_on_new_line
description: >-
  Details about the always_put_control_body_on_new_line
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_put_control_body_on_new_line"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Statement should be on a separate line._

## Description

The analyzer produces this diagnostic when the code being controlled by a
control flow statement (`if`, `for`, `while`, or `do`) is on the same line
as the control flow statement.

## Example

The following code produces this diagnostic because the `return` statement
is on the same line as the `if` that controls whether the `return` will be
executed:

```dart
void f(bool b) {
  if (b) [!return!];
}
```

## Common fixes

Put the controlled statement onto a separate, indented, line:

```dart
void f(bool b) {
  if (b)
    return;
}
```
