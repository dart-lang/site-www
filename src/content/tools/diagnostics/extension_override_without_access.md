---
title: extension_override_without_access
description: >-
  Details about the extension_override_without_access
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_An extension override can only be used to access instance members._

## Description

The analyzer produces this diagnostic when an extension override is found
that isn't being used to access one of the members of the extension. The
extension override syntax doesn't have any runtime semantics; it only
controls which member is selected at compile time.

## Example

The following code produces this diagnostic because `E(i)` isn't an
expression:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print([!E(i)!]);
}
```

## Common fixes

If you want to invoke one of the members of the extension, then add the
invocation:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(E(i).a);
}
```

If you don't want to invoke a member, then unwrap the argument:

```dart
extension E on int {
  int get a => 0;
}

void f(int i) {
  print(i);
}
```
