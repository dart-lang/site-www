---
title: variable_pattern_keyword_in_declaration_context
description: >-
  Details about the variable_pattern_keyword_in_declaration_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Variable patterns in declaration context can't specify 'var' or 'final'
keyword._

## Description

The analyzer produces this diagnostic when a variable pattern is used
within a declaration context.

## Example

The following code produces this diagnostic because the variable patterns
in the record pattern are in a declaration context:

```dart
void f((int, int) r) {
  var ([!var!] x, y) = r;
  print(x + y);
}
```

## Common fixes

Remove the `var` or `final` keyword(s) within the variable pattern:

```dart
void f((int, int) r) {
  var (x, y) = r;
  print(x + y);
}
```
