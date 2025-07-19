---
title: undefined_identifier_await
description: >-
  Details about the undefined_identifier_await
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Undefined name 'await' in function body not marked with 'async'._

## Description

The analyzer produces this diagnostic when the name `await` is used in a
method or function body without being declared, and the body isn't marked
with the `async` keyword. The name `await` only introduces an await
expression in an asynchronous function.

## Example

The following code produces this diagnostic because the name `await` is
used in the body of `f` even though the body of `f` isn't marked with the
`async` keyword:

```dart
void f(p) { [!await!] p; }
```

## Common fixes

Add the keyword `async` to the function body:

```dart
void f(p) async { await p; }
```
