---
title: no_wildcard_variable_uses
description: >-
  Details about the no_wildcard_variable_uses
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_wildcard_variable_uses"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The referenced identifier is a wildcard._

## Description

The analyzer produces this diagnostic when either a parameter or local
variable whose name consists of only underscores is referenced. Such
names will become non-binding in a future version of the Dart language,
making the reference illegal.

## Example

The following code produces this diagnostic because the name of the
parameter consists of two underscores:

```dart
// @dart = 3.6
void f(int __) {
  print([!__!]);
}
```

The following code produces this diagnostic because the name of the
local variable consists of a single underscore:

```dart
// @dart = 3.6
void f() {
  int _ = 0;
  print([!_!]);
}
```

## Common fixes

If the variable or parameter is intended to be referenced, then give it a
name that has at least one non-underscore character:

```dart
void f(int p) {
  print(p);
}
```

If the variable or parameter is not intended to be referenced, then
replace the reference with a different expression:

```dart
void f() {
  print(0);
}
```
