---
title: invalid_pattern_variable_in_shared_case_scope
description: >-
  Details about the invalid_pattern_variable_in_shared_case_scope
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The variable '{0}' doesn't have the same type and/or finality in all cases that
share this body._

_The variable '{0}' is available in some, but not all cases that share this
body._

_The variable '{0}' is not available because there is a label or 'default'
case._

## Description

The analyzer produces this diagnostic when multiple case clauses in a
switch statement share a body, and at least one of them declares a
variable that is referenced in the shared statements, but the variable is
either not declared in all of the case clauses or it is declared in
inconsistent ways.

If the variable isn't declared in all of the case clauses, then it won't
have a value if one of the clauses that doesn't declare the variable is
the one that matches and executes the body. This includes the situation
where one of the case clauses is the `default` clause.

If the variable is declared in inconsistent ways, either being `final` in
some cases and not `final` in others or having a different type in
different cases, then the semantics of what the type or finality of the
variable should be are not defined.

## Examples

The following code produces this diagnostic because the variable `a` is
only declared in one of the case clauses, and won't have a value if the
second clause is the one that matched `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case 0:
      [!a!];
  }
}
```

The following code produces this diagnostic because the variable `a` isn't
declared in the `default` clause, and won't have a value if the body is
executed because none of the other clauses matched `x`:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    default:
      [!a!];
  }
}
```

The following code produces this diagnostic because the variable `a` won't
have a value if the body is executed because a different group of cases
caused control to continue at the label:

```dart
void f(Object? x) {
  switch (x) {
    someLabel:
    case int a when a > 0:
      [!a!];
    case int b when b < 0:
      continue someLabel;
  }
}
```

The following code produces this diagnostic because the variable `a`,
while being assigned in all of the case clauses, doesn't have then same
type associated with it in every clause:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a < 0:
    case num a when a > 0:
      [!a!];
  }
}
```

The following code produces this diagnostic because the variable `a` is
`final` in the first case clause and isn't `final` in the second case
clause:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case int a when a > 0:
      [!a!];
  }
}
```

## Common fixes

If the variable isn't declared in all of the cases, and you need to
reference it in the statements, then declare it in the other cases:

```dart
void f(Object? x) {
  switch (x) {
    case int a when a > 0:
    case int a when a == 0:
      a;
  }
}
```

If the variable isn't declared in all of the cases, and you don't need to
reference it in the statements, then remove the references to it and
remove the declarations from the other cases:

```dart
void f(int x) {
  switch (x) {
    case > 0:
    case 0:
  }
}
```

If the type of the variable is different, decide the type the variable
should have and make the cases consistent:

```dart
void f(Object? x) {
  switch (x) {
    case num a when a < 0:
    case num a when a > 0:
      a;
  }
}
```

If the finality of the variable is different, decide whether it should be
`final` or not `final` and make the cases consistent:

```dart
void f(Object? x) {
  switch (x) {
    case final int a when a < 0:
    case final int a when a > 0:
      a;
  }
}
```
