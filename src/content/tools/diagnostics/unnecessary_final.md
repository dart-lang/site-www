---
title: unnecessary_final
description: >-
  Details about the unnecessary_final
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_final"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Local variables should not be marked as 'final'._

## Description

The analyzer produces this diagnostic when a local variable is marked as
being `final`.

## Example

The following code produces this diagnostic because the local variable `c`
is marked as being `final`:

```dart
void f(int a, int b) {
  [!final!] c = a + b;
  print(c);
}
```

## Common fixes

If the variable doesn't have a type annotation, then replace the `final`
with `var`:

```dart
void f(int a, int b) {
  var c = a + b;
  print(c);
}
```

If the variable has a type annotation, then remove the `final`
modifier:

```dart
void f(int a, int b) {
  int c = a + b;
  print(c);
}
```
