---
title: use_string_buffers
description: >-
  Details about the use_string_buffers
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_string_buffers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a string buffer rather than '+' to compose strings._

## Description

The analyzer produces this diagnostic when values are concatenated to a
string inside a loop without using a `StringBuffer` to do the
concatenation.

## Example

The following code produces this diagnostic because the string `result` is
computed by repeated concatenation within the `for` loop:

```dart
String f() {
  var result = '';
  for (int i = 0; i < 10; i++) {
    [!result += 'a'!];
  }
  return result;
}
```

## Common fixes

Use a `StringBuffer` to compute the result:

```dart
String f() {
  var buffer = StringBuffer();
  for (int i = 0; i < 10; i++) {
    buffer.write('a');
  }
  return buffer.toString();
}
```
