---
title: unnecessary_unawaited
description: >-
  Details about the unnecessary_unawaited
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Unnecessary use of 'unawaited'._

## Description

The analyzer produces this diagnostic when `unawaited` is used to mark a
call to a function, method, or operator, or a reference to a field,
getter, or top-level variable as safely not being awaited, but the called
member is also annotated with `@awaitNotRequired`. This annotation itself
signals that wrapping with `unawaited` is unnecessary at any call site.

## Example

The following code produces this diagnostic because `unawaited` is invoked
on a call to a function that's annotated with `@awaitNotRequired`:

```dart
import 'dart:async';
import 'package:meta/meta.dart';

@awaitNotRequired
Future<bool> log(String message) async => true;

void f() {
  [!unawaited!](log('Message.'));
}
```

## Common fixes

Remove the invocation of `unawaited`:

```dart
import 'package:meta/meta.dart';

@awaitNotRequired
Future<bool> log(String message) async => true;

void f() {
  log('Message.');
}
```
