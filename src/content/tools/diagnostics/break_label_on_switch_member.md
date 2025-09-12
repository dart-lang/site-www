---
title: break_label_on_switch_member
description: >-
  Details about the break_label_on_switch_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A break label resolves to the 'case' or 'default' statement._

## Description

The analyzer produces this diagnostic when a break in a case clause inside
a switch statement has a label that is associated with another case clause.

## Example

The following code produces this diagnostic because the label `l` is
associated with the case clause for `0`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      break [!l!];
  }
}
```

## Common fixes

If the intent is to transfer control to the statement after the switch,
then remove the label from the break statement:

```dart
void f(int i) {
  switch (i) {
    case 0:
      break;
    case 1:
      break;
  }
}
```

If the intent is to transfer control to a different case block, then use
`continue` rather than `break`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      continue l;
  }
}
```
