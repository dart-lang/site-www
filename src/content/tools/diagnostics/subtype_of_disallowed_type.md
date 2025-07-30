---
title: subtype_of_disallowed_type
description: >-
  Details about the subtype_of_disallowed_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_'{0}' can't be used as a superclass constraint._

_Classes and mixins can't implement '{0}'._

_Classes can't extend '{0}'._

_Classes can't mixin '{0}'._

## Description

The analyzer produces this diagnostic when one of the restricted classes is
used in either an `extends`, `implements`, `with`, or `on` clause. The
classes `bool`, `double`, `FutureOr`, `int`, `Null`, `num`, and `String`
are all restricted in this way, to allow for more efficient
implementations.

## Examples

The following code produces this diagnostic because `String` is used in an
`extends` clause:

```dart
class A extends [!String!] {}
```

The following code produces this diagnostic because `String` is used in an
`implements` clause:

```dart
class B implements [!String!] {}
```

The following code produces this diagnostic because `String` is used in a
`with` clause:

```dart
class C with [!String!] {}
```

The following code produces this diagnostic because `String` is used in an
`on` clause:

```dart
mixin M on [!String!] {}
```

## Common fixes

If a different type should be specified, then replace the type:

```dart
class A extends Object {}
```

If there isn't a different type that would be appropriate, then remove the
type, and possibly the whole clause:

```dart
class B {}
```
