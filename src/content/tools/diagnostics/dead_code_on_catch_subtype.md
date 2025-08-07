---
title: dead_code_on_catch_subtype
description: >-
  Details about the dead_code_on_catch_subtype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Dead code: This on-catch block won't be executed because '{0}' is a subtype of
'{1}' and hence will have been caught already._

## Description

The analyzer produces this diagnostic when a `catch` clause is found that
can't be executed because it is after a `catch` clause that catches either
the same type or a supertype of the clause's type. The first `catch` clause
that matches the thrown object is selected, and the earlier clause always
matches anything matchable by the highlighted clause, so the highlighted
clause will never be selected.

## Example

The following code produces this diagnostic:

```dart
void f() {
  try {
  } on num {
  } [!on int {!]
  [!}!]
}
```

## Common fixes

If the clause should be selectable, then move the clause before the general
clause:

```dart
void f() {
  try {
  } on int {
  } on num {
  }
}
```

If the clause doesn't need to be selectable, then remove it:

```dart
void f() {
  try {
  } on num {
  }
}
```
