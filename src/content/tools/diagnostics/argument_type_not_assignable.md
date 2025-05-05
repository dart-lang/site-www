---
title: argument_type_not_assignable
description: >-
  Details about the argument_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The argument type '{0}' can't be assigned to the parameter type '{1}'. {2}_

## Description

The analyzer produces this diagnostic when the static type of an argument
can't be assigned to the static type of the corresponding parameter.

## Example

The following code produces this diagnostic because a `num` can't be
assigned to a `String`:

```dart
String f(String x) => x;
String g(num y) => f([!y!]);
```

## Common fixes

If possible, rewrite the code so that the static type is assignable. In the
example above you might be able to change the type of the parameter `y`:

```dart
String f(String x) => x;
String g(String y) => f(y);
```

If that fix isn't possible, then add code to handle the case where the
argument value isn't the required type. One approach is to coerce other
types to the required type:

```dart
String f(String x) => x;
String g(num y) => f(y.toString());
```

Another approach is to add explicit type tests and fallback code:

```dart
String f(String x) => x;
String g(Object y) => f(y is String ? y : '');
```

If you believe that the runtime type of the argument will always be the
same as the static type of the parameter, and you're willing to risk having
an exception thrown at runtime if you're wrong, then add an explicit cast:

```dart
String f(String x) => x;
String g(num y) => f(y as String);
```
