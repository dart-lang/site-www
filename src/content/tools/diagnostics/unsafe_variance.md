---
title: unsafe_variance
description: >-
  Details about the unsafe_variance
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unsafe_variance"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_This type is unsafe: a type parameter occurs in a non-covariant position._

## Description

The analyzer produces this diagnostic when an instance member has a result
type which is [contravariant or invariant](https://dart.dev/resources/glossary#variance)
in a type parameter of the enclosing declaration. The result type of a
variable is its type, and the result type of a getter or method is its
return type. This lint warns against such members because they are likely
to cause a failing type check at run time, with no static warning or error
at the call site.

## Example

The following code produces this diagnostic because `X` occurs
as a parameter type in the type of `f`, which is a
contravariant occurrence of this type parameter:

```dart
class C<X> {
  bool Function([!X!]) f;
  C(this.f);
}
```

This is unsafe: If `c` has static type `C<num>` and run-time type `C<int>`
then `c.f` will throw. Hence, every invocation `c.f(a)` will also throw,
even in the case where `a` has a correct type as an argument to `c.f`.

## Common fixes

If the linted member is or can be private then you may be able
to enforce that it is never accessed on any other receiver than `this`.
This is sufficient to ensure that that the run-time type error does not
occur. For example:

```dart
class C<X> {
  // NB: Ensure manually that `_f` is only accessed on `this`.
  // ignore: unsafe_variance
  bool Function(X) _f;

  C(this._f);

  // We can write a forwarding method to allow clients to call `_f`.
  bool f(X x) => _f(x);
}
```

You can eliminate the unsafe variance by using a more general type for
the linted member. In this case you may need to check the run-time type
and perform a downcast at call sites.

```dart
class C<X> {
  bool Function(Never) f;
  C(this.f);
}
```

If `c` has static type `C<num>` then you may test the type. For example,
`c.f is bool Function(num)`. You may safely call it with an argument of
type `num` if it has that type.

You can also eliminate the unsafe variance by using a much more general
type like `Function`, which is essentially the type `dynamic` for
functions.

```dart
class C<X> {
  Function f;
  C(this.f);
}
```

This will make `c.f(a)` dynamically safe: It will throw if and only if the
argument `a` does not have the type required by the function. This is
better than the original version because it will not throw because of a
mismatched static type. It only throws when it _must_ throw for soundness
reasons.
