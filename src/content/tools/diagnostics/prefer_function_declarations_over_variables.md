---
title: prefer_function_declarations_over_variables
description: >-
  Details about the prefer_function_declarations_over_variables
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_function_declarations_over_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a function declaration rather than a variable assignment to bind a function
to a name._

## Description

The analyzer produces this diagnostic when a closure is assigned to a
local variable and the local variable is not re-assigned anywhere.

## Example

The following code produces this diagnostic because the local variable `f`
is initialized to be a closure and isn't assigned any other value:

```dart
void g() {
  var [!f = (int i) => i * 2!];
  f(1);
}
```

## Common fixes

Replace the local variable with a local function:

```dart
void g() {
  int f(int i) => i * 2;
  f(1);
}
```
