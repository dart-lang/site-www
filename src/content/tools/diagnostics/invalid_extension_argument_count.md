---
title: invalid_extension_argument_count
description: >-
  Details about the invalid_extension_argument_count
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension overrides must have exactly one argument: the value of 'this' in the extension method._

## Description

The analyzer produces this diagnostic when an extension override doesn't
have exactly one argument. The argument is the expression used to compute
the value of `this` within the extension method, so there must be one
argument.

## Examples

The following code produces this diagnostic because there are no arguments:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!()!].join('b');
}
```

And, the following code produces this diagnostic because there's more than
one argument:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E[!('a', 'b')!].join('c');
}
```

## Common fixes

Provide one argument for the extension override:

```dart
extension E on String {
  String join(String other) => '$this $other';
}

void f() {
  E('a').join('b');
}
```
