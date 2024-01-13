---
title: JS Types
description: Usage information about the core types in JS interop.
---

## Motivation

Dart values and JS values belong to separate domains. When compiling to Wasm,
they belong in separate *runtimes* as well. As such, users should treat JS
values as foreign types. In order to provide types for JS values, we use the set
of JS types available in `dart:js_interop`. These are extension types prefixed
with `JS` and are called "JS types".

Importantly, these types have compiler-specific representation types. This means
that their runtime type will differ based on whether code is compiled to Wasm or
JS. In order to interact with and examine these JS values, we use `external`
interop members.

## Type Hierarchy

JS types form a natural type hierarchy:

- Top type: `JSAny`, which is any non-nullish JS value
  - Primitives: `JSNumber`, `JSBoolean`, `JSString`
  - `JSSymbol`
  - `JSBigInt`
  - `JSObject`, which is any JS object
    - `JSFunction`
      - `JSExportedDartFunction`, which represents a Dart callback that was
      converted to a JS function
    - `JSArray`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - JS typed arrays e.g. `JSUint8Array`
    - `JSBoxedDartObject`, which allows users to box and pass Dart values
      opaquely within the same Dart runtime

Note that these JS types are *also* interop types. As such, users can and should
use them as representation types of other interface types. Users will likely
want to use `JSObject` for this purpose.

// TODO(srujzs): Add a link to the interop type section in the syntax.
// TODO(srujzs): Should we link the type to the definition? It might be a bit
// annoying to do everywhere a JS type is mentioned.

## Conversions

Since we have separate domains, we will likely want to *convert* values between
one domain to the other. For example, we may want to convert a Dart `String`
into a JS string, which is represented by the JS type JSString. To do this, we
supply a number of `extension` members on various Dart types that will do the
conversion for you, usually labeled as or prefixed with `toJS`. Similarly, we
can convert JS values to Dart types. We supply a number of members on various JS
types to enable this conversion, usually labeled as or prefixed with `toDart`.
They are often marked `external`, and their implementation is usually
platform-dependent. Note that not all JS types have a conversion, and not all
Dart types have a conversion.

In general, the conversion table looks like the following:

| JS type                             | Dart type                                |
| ----------------------------------- | ---------------------------------------- |
| `JSNumber`, `JSBoolean`, `JSString` | `num`, `int`, `double`, `bool`, `String` |
| `JSExportedFunction`                | `JSFunction`                             |
| `JSArray<T extends JSAny?>`         | `List<T extends JSAny?>`                 |
| `JSPromise<T extends JSAny?>`       | `Future<T extends JSAny?>`               |
| Typed arrays e.g. `JSUint8Array`    | `dart:typed_data`                        |
| `JSBoxedDartObject`                 | Opaque Dart value                        |

**Important**: Conversions may have different costs depending on the compiler.
Prefer to only convert when you need to. Furthermore, conversions may or may not
produce a new value. This doesn’t matter for immutable values like numbers, but
does matter for types like `List`s. A conversion to a `JSArray` may produce a
new value by copying or may not, so do not rely on modifications to the
`JSArray` affecting the `List`. Typed array conversions have a similar
limitation. Look at the specific conversion function for more details.

## Requirements on `external` declarations and `Function.toJS`

In order to ensure type safety and consistency, we place requirements on what
types can flow into and out of JS. Passing arbitrary Dart values into JS is not
allowed. Instead, we require users to use a compatible interop type like a JS
type or a primitive, which would then be implicitly converted by the compiler.
For example, these would be allowed:

```dart
@JS()
external void usePrimitives(String a, int b, double c, num d, bool e);
```
```dart
@JS()
external JSArray useJsTypes(JSObject _, JSString __);
```
```dart
extension type InteropType(JSObject _) {}

@JS()
external InteropType get interopType;
```

whereas these would return an error:

```dart
@JS()
external Function get function;
```

```dart
@JS()
external set list(List _);
```

These same requirements exist when we use `Function.toJS` to make a Dart
function callable in JS. The values that flow into and out of this callback must
be a compatible interop type or a primitive.

If you use a Dart primitive e.g. `String`, an implicit conversion happens in the
compiler to convert that value from a JS value to a Dart value. If performance
is critical and you don’t need to examine the contents of the string, then maybe
using `JSString` instead makes sense to avoid the conversion cost.

## Compatibility/type checks and casts

As mentioned above, the representation type of JS types may differ based on the
compiler. This affects runtime type-checking and casts. Therefore, almost always
avoid `is` checks where the value is an interop type or where the target type is
an interop type. Avoid casts between Dart types and interop types. In order to
type-check a JS value, use an interop member like `typeofEquals` or
`instanceOfString` that examines the JS value itself.

Bad:

```dart
void f(JSAny a) {
  if (a is String) { … }
}
```

```dart
void f(JSObject o) {
  if (o is JSObject) { … }
}
```

```dart
void f(JSString s) {
  l as String;
}
```

Okay:

```dart
void f(JSAny a) {
  // Here we verify that `a` is a JS function, so the cast is okay.
  if (a.typeofEquals('function')) {
    a as JSFunction;
  }
}
```

We may add lints to make runtime checks with JS interop types easier to avoid.

## `null` vs `undefined`

JS has both a `null` and an `undefined` value. This is in contrast with Dart,
which only has `null`. In order to make JS values more ergonomic to use, if an
interop member were to return either JS `null` or `undefined`, we map these
values to Dart `null`. Therefore a member like:

```dart
@JS()
external JSObject? get value;
```

can be interpreted as returning a JS object, JS `null`, or `undefined`.

**Important**: There is a subtle inconsistency with regards to `undefined`
between compiling to JS and Wasm. While compiling to JS treats `undefined`
values like Dart `null`, it doesn’t actually *change* the value itself. If you
an interop member returns `undefined` and you pass it back into JS, JS will see
`undefined` and not `null` when compiling to JS. When compiling to Wasm, this is
not the case, because we convert the value to Dart `null`, thereby losing
information on whether the original value was JS `null` or `undefined`. Avoid
writing code where this distinction matters by explicitly passing Dart `null`
instead to an interop member. Currently, there’s no platform-consistent way to
provide `undefined` to interop members or distinguish between JS `null` and
`undefined` values, but this will likely change in the future.