---
title: unnecessary_lambdas
description: >-
  Details about the unnecessary_lambdas
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_lambdas"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Closure should be a tearoff._

## Description

The analyzer produces this diagnostic when a closure (lambda) could be
replaced by a tear-off.

## Example

The following code produces this diagnostic because the closure passed to
`forEach` contains only an invocation of the function `print` with the
parameter of the closure:

```dart
void f(List<String> strings) {
  strings.forEach([!(string) {!]
    [!print(string);!]
  [!}!]);
}
```

## Common fixes

Replace the closure with a tear-off of the function or method being
invoked with the closure:

```dart
void f(List<String> strings) {
  strings.forEach(print);
}
```
