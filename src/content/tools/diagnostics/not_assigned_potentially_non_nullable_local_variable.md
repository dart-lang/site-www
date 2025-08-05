---
title: not_assigned_potentially_non_nullable_local_variable
description: >-
  Details about the not_assigned_potentially_non_nullable_local_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The non-nullable local variable '{0}' must be assigned before it can be used._

## Description

The analyzer produces this diagnostic when a local variable is referenced
and has all these characteristics:
- Has a type that's [potentially non-nullable][].
- Doesn't have an initializer.
- Isn't marked as `late`.
- The analyzer can't prove that the local variable will be assigned before
  the reference based on the specification of [definite assignment][].

## Examples

The following code produces this diagnostic because `x` can't have a value
of `null`, but is referenced before a value was assigned to it:

```dart
String f() {
  int x;
  return [!x!].toString();
}
```

The following code produces this diagnostic because the assignment to `x`
might not be executed, so it might have a value of `null`:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  return [!x!] * 2;
}
```

The following code produces this diagnostic because the analyzer can't
prove, based on definite assignment analysis, that `x` won't be referenced
without having a value assigned to it:

```dart
int h(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return [!x!] * 2;
  }
  return 0;
}
```

## Common fixes

If `null` is a valid value, then make the variable nullable:

```dart
String f() {
  int? x;
  return x!.toString();
}
```

If `null` isn't a valid value, and there's a reasonable default value, then
add an initializer:

```dart
int g(bool b) {
  int x = 2;
  if (b) {
    x = 1;
  }
  return x * 2;
}
```

Otherwise, ensure that a value was assigned on every possible code path
before the value is accessed:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  } else {
    x = 2;
  }
  return x * 2;
}
```

You can also mark the variable as `late`, which removes the diagnostic, but
if the variable isn't assigned a value before it's accessed, then it
results in an exception being thrown at runtime. This approach should only
be used if you're sure that the variable will always be assigned, even
though the analyzer can't prove it based on definite assignment analysis.

```dart
int h(bool b) {
  late int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return x * 2;
  }
  return 0;
}
```

[definite assignment]: /resources/glossary#definite-assignment
[potentially non-nullable]: /resources/glossary#potentially-non-nullable
