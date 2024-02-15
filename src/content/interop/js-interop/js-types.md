---
title: JS types
description: Usage information about the core types in JS interop.
---

Dart values and JS values belong to separate language domains. When compiling to
Wasm, they execute in separate *runtimes* as well. As such, you should treat JS
values as foreign types. To provide Dart types for JS values,
[`dart:js_interop`] exposes a set of types prefixed with `JS` called "JS types".
These types are used to distinguish between Dart values and JS values at
compile-time.

Importantly, these types are reified differently based on whether you compile to
Wasm or JS. This means that their runtime type will differ, and therefore you
[can't use `is` checks and `as` casts](#compatibility-type-checks-and-casts).
In order to interact with and examine these JS values, you should use
[`external`] interop members or [conversions](#conversions).

## Type hierarchy

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
      - JS typed arrays like `JSUint8Array`
    - `JSBoxedDartObject`, which allows users to box and pass Dart values
      opaquely within the same Dart runtime

You can find the definition of each type in the [`dart:js_interop` API docs].

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversions

To use a value from one domain to another, you will likely want to *convert* the
value to the corresponding type of the other domain. For example, you may want
to convert a Dart `List<JSString>` into a JS array of strings, which is
represented by the JS type `JSArray<JSString>`, so that you can pass the array
to a JS interop API.

Dart supplies a number of conversion members on various Dart types and JS types
to convert the values between the domains for you.

Members that convert values from Dart to JS usually start with `toJS`:

```dart
String str = 'hello world';
JSString jsStr = str.toJS;
```

Members that convert values from JS to Dart usually start with `toDart`:

```dart
JSNumber jsNum = ...;
int integer = jsNum.toDartInt;
```

Not all JS types have a conversion, and not all Dart types have a conversion.
Generally, the conversion table looks like the following:

<div class="table-wrapper" markdown="1">

| JS type                             | Dart type                                |
|-------------------------------------|------------------------------------------|
| `JSNumber`, `JSBoolean`, `JSString` | `num`, `int`, `double`, `bool`, `String` |
| `JSExportedDartFunction`            | `Function`                               |
| `JSArray<T extends JSAny?>`         | `List<T extends JSAny?>`                 |
| `JSPromise<T extends JSAny?>`       | `Future<T extends JSAny?>`               |
| Typed arrays like `JSUint8Array`    | Typed lists from `dart:typed_data`       |
| `JSBoxedDartObject`                 | Opaque Dart value                        |

{:.table .table-striped}
</div>

:::warning
Compiling to JavaScript vs Wasm can introduce inconsistencies in both
performance and semantics for conversions. Conversions may have different costs
depending on the compiler, so prefer to only convert values if you need to.

Conversions also may or may not produce a new value. This doesn’t matter for
immutable values like numbers, but does matter for types like `List`. Depending
on the implementation, a conversion to `JSArray` may return a reference, a
proxy, or a clone of the original list. To avoid this, do not rely on any
relation between the `List` and `JSArray` and only rely on their contents being
the same. Typed array conversions have a similar limitation. Look up the
specific conversion function for more details.
:::

## Requirements on `external` declarations and `Function.toJS`

In order to ensure type safety and consistency, the compiler places requirements
on what types can flow into and out of JS. Passing arbitrary Dart values into JS
is not allowed. Instead, the compiler requires users to use a compatible interop
type or a primitive, which would then be implicitly converted by the compiler.
For example, these would be allowed:

```dart tag=good
@JS()
external void primitives(String a, int b, double c, num d, bool e);
```

```dart tag=good
@JS()
external JSArray jsTypes(JSObject _, JSString __);
```

```dart tag=good
extension type InteropType(JSObject _) implements JSObject {}

@JS()
external InteropType get interopType;
```

Whereas these would return an error:

```dart tag=bad
@JS()
external Function get function;
```

```dart tag=bad
@JS()
external set list(List _);
```

These same requirements exist when you use [`Function.toJS`] to make a Dart
function callable in JS. The values that flow into and out of this callback must
be a compatible interop type or a primitive.

If you use a Dart primitive like `String`, an implicit conversion happens in the
compiler to convert that value from a JS value to a Dart value. If performance
is critical and you don’t need to examine the contents of the string, then using
`JSString` instead to avoid the conversion cost may make sense like in the
second example.

## Compatibility, type checks, and casts

The runtime type of JS types may differ based on the compiler. This affects
runtime type-checking and casts. Therefore, almost always avoid `is` checks
where the value is an interop type or where the target type is an interop type:

```dart tag=bad
void f(JSAny a) {
  if (a is String) { … }
}
```

```dart tag=bad
void f(JSAny a) {
  if (a is JSObject) { … }
}
```

Also, avoid casts between Dart types and interop types:

```dart tag=bad
void f(JSString s) {
  s as String;
}
```

To type-check a JS value, use an interop member like [`typeofEquals`] or
[`instanceOfString`] that examines the JS value itself:

```dart tag=good
void f(JSAny a) {
  // Here `a` is verified to be a JS function, so the cast is okay.
  if (a.typeofEquals('function')) {
    a as JSFunction;
  }
}
```

From Dart 3.4 onwards, you can use the [`isA`] helper function to check whether
a value is any interop type:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `instanceOfString('Array')`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Depending on the type parameter, it'll transform the call into the appropriate
type-check for that type.

{% comment %}
TODO: Add a link to and an example using `isA` once it's in a dev release. Users
should prefer that method if it's available.
{% endcomment %}

Dart may add lints to make runtime checks with JS interop types easier to avoid.
See issue [#4841] for more details.

## `null` vs `undefined`

JS has both a `null` and an `undefined` value. This is in contrast with Dart,
which only has `null`. In order to make JS values more ergonomic to use, if an
interop member were to return either JS `null` or `undefined`, the compiler maps
these values to Dart `null`. Therefore a member like `value` in the following
example can be interpreted as returning a JS object, JS `null`, or `undefined`:

```dart
@JS()
external JSObject? get value;
```

If the return type was not declared as nullable, then the program will throw an
error if the value returned was JS `null` or `undefined` to ensure soundness.

:::warning
There is a subtle inconsistency with regards to `undefined` between compiling to
JS and Wasm. While compiling to JS *treats* `undefined` values as if they were
Dart `null`, it doesn’t actually *change* the value itself. If an interop member
returns `undefined` and you pass that value back into JS, JS will see
`undefined`, *not* `null`, when compiling to JS.

However, when compiling to Wasm, this is not the case,
and the value will be `null` in JS. This is because
the compiler implicitly *converts* the value to Dart `null` when compiling to
Wasm, thereby losing information on whether the original value was JS `null` or
`undefined`. Avoid writing code where this distinction matters by explicitly
passing Dart `null` instead to an interop member.

Currently, there's no platform-consistent way to provide `undefined`
to interop members or distinguish between JS `null` and `undefined` values,
but this will likely change in the future. See [#54025] for more details.
:::

{% comment %}
TODO: add links (with stable) when ready:
{% endcomment %}

[`dart:js_interop`]: https://api.dart.dev/dev/dart-js_interop/dart-js_interop-library.html
[`external`]: https://dart.dev/language/functions#external
[`Function.toJS`]: https://api.dart.dev/dev/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop` API docs]: https://api.dart.dev/dev/dart-js_interop/dart-js_interop-library.html#extension-types
[`typeofEquals`]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension/typeofEquals.html
[`instanceOfString`]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension/instanceOfString.html
[`isA`]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension/isA.html
[#4841]: https://github.com/dart-lang/linter/issues/4841
[#54025]: https://github.com/dart-lang/sdk/issues/54025