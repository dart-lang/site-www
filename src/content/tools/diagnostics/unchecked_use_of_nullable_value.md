---
title: unchecked_use_of_nullable_value
description: >-
  Details about the unchecked_use_of_nullable_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A nullable expression can't be used as a condition._

_A nullable expression can't be used as an iterator in a for-in loop._

_A nullable expression can't be used in a spread._

_A nullable expression can't be used in a yield-each statement._

_The function can't be unconditionally invoked because it can be 'null'._

_The method '{0}' can't be unconditionally invoked because the receiver can be
'null'._

_The operator '{0}' can't be unconditionally invoked because the receiver can be
'null'._

_The property '{0}' can't be unconditionally accessed because the receiver can
be 'null'._

## Description

The analyzer produces this diagnostic when an expression whose type is
[potentially non-nullable][] is dereferenced without first verifying that
the value isn't `null`.

## Example

The following code produces this diagnostic because `s` can be `null` at
the point where it's referenced:

```dart
void f(String? s) {
  if (s.[!length!] > 3) {
    // ...
  }
}
```

## Common fixes

If the value really can be `null`, then add a test to ensure that members
are only accessed when the value isn't `null`:

```dart
void f(String? s) {
  if (s != null && s.length > 3) {
    // ...
  }
}
```

If the expression is a variable and the value should never be `null`, then
change the type of the variable to be non-nullable:

```dart
void f(String s) {
  if (s.length > 3) {
    // ...
  }
}
```

If you believe that the value of the expression should never be `null`, but
you can't change the type of the variable, and you're willing to risk
having an exception thrown at runtime if you're wrong, then you can assert
that the value isn't null:

```dart
void f(String? s) {
  if (s!.length > 3) {
    // ...
  }
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
