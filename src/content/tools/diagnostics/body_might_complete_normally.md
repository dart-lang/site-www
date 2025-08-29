---
title: body_might_complete_normally
description: >-
  Details about the body_might_complete_normally
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The body might complete normally, causing 'null' to be returned, but the return type, '{0}', is a potentially non-nullable type._

## Description

The analyzer produces this diagnostic when a method or function has a
return type that's [potentially non-nullable][] but would implicitly return
`null` if control reached the end of the function.

## Examples

The following code produces this diagnostic because the method `m` has an
implicit return of `null` inserted at the end of the method, but the method
is declared to not return `null`:

```dart
class C {
  int [!m!](int t) {
    print(t);
  }
}
```

The following code produces this diagnostic because the method `m` has an
implicit return of `null` inserted at the end of the method, but because
the class `C` can be instantiated with a non-nullable type argument, the
method is effectively declared to not return `null`:

```dart
class C<T> {
  T [!m!](T t) {
    print(t);
  }
}
```

## Common fixes

If there's a reasonable value that can be returned, then add a `return`
statement at the end of the method:

```dart
class C<T> {
  T m(T t) {
    print(t);
    return t;
  }
}
```

If the method won't reach the implicit return, then add a `throw` at the
end of the method:

```dart
class C<T> {
  T m(T t) {
    print(t);
    throw '';
  }
}
```

If the method intentionally returns `null` at the end, then add an
explicit return of `null` at the end of the method and change the
return type so that it's valid to return `null`:

```dart
class C<T> {
  T? m(T t) {
    print(t);
    return null;
  }
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
