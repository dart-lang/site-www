---
title: JS types
breadcrumb: Types
description: Usage information about the core types in JS interop.
prevpage:
  url: /interop/js-interop/usage
  title: Usage
nextpage:
  url: /interop/js-interop/tutorials
  title: JS interop tutorials
---

Dart values and JS values belong to separate language domains. When compiling to
[Wasm][], they execute in separate *runtimes* as well. Treat JS
values as foreign types. To provide Dart types for JS values,
[`dart:js_interop`] exposes a set of types prefixed with `JS` called "JS types".
These types are used to distinguish between Dart values and JS values at
compile-time.

Importantly, these types are reified differently based on whether you compile to
Wasm or JS. This means that their runtime types differ, so you
[can't use `is` checks or `as` casts](#compatibility-type-checks-and-casts).
To interact with and examine JS values, use
[`external`] interop members or [conversions](#conversions).

## Type hierarchy

JS types form a natural type hierarchy:

- Top type: `JSAny`, which is any non-nullish JS value
  - Primitives: `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - `JSObject`, which is any JS object
    - `JSFunction`
      - `JSExportedDartFunction`, which represents a Dart callback that was
      converted to a JS function
    - `JSArray`
    - `JSIterable` and `JSIterator`
    - `JSDisposableProtocol`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - JS typed arrays like `JSUint8Array`
    - `JSBoxedDartObject`, which boxes Dart values so you can pass them
      opaquely within the same Dart runtime
      - `ExternalDartReference` in `dart:js_interop` also passes Dart values
      opaquely, but is *not* a JS type. To compare the two options, see
      [`JSBoxedDartObject` vs `ExternalDartReference`](#jsboxeddartobject-vs-externaldartreference).

You can find the definition of each type and its built-in helpers
(such as `JSPromise.resolve` and `JSPromise.reject`, `JSArray.fromAsync`,
`JSFunction.length` and `JSFunction.name`,
and well-known `JSSymbol` constants) in the [`dart:js_interop` API docs].

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversions

To use a value from one domain in the other, *convert* it
to the corresponding type. For example, you might want
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

| `dart:js_interop` type                                         | Dart type                                                              |
| -------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `JSNumber`, `JSBoolean`, `JSString`                            | `num`, `int`, `double`, `bool`, `String`                               |
| `JSExportedDartFunction`                                       | `Function`                                                             |
| `JSArray<T extends JSAny?>`                                    | `List<T extends JSAny?>`                                               |
| `JSArray<JSNumber>`, `JSArray<JSBoolean>`, `JSArray<JSString>` | `List<num>`, `List<int>`, `List<double>`, `List<bool>`, `List<String>` |
| `JSIterable<T extends JSAny?>`, `JSIterator<T extends JSAny?>` | `Iterable<T extends JSAny?>`, `Iterator<T extends JSAny?>`             |
| `JSPromise<T extends JSAny?>`                                  | `Future<T extends JSAny?>`                                             |
| `JSAny?` (`JSPromise` or value)                                | `FutureOr<T extends JSAny?>`                                           |
| Typed arrays like `JSUint8Array`                               | Typed lists from `dart:typed_data`                                     |
| `JSBoxedDartObject`                                            | Opaque Dart value                                                      |
| `ExternalDartReference`                                        | Opaque Dart value                                                      |

{:.table .table-striped}

While most conversions use `.toJS` and `.toDart`, some types provide
more specific conversion members:

- Convert a primitive `List` (`num`, `int`, `double`, `bool`, or `String`,
  including nullable elements) to a `JSArray` with `.toJS`, and convert back
  to a typed Dart list using `toDartDoubleList`, `toDartIntList`,
  `toDartBoolList`, or `toDartStringList`.
- Iterate lazily across the JS boundary without copying into a `List` or
  `JSArray` using `toJSIterable`, `toDartIterable`, `toJSIterator`, and
  `toDartIterator`.
- Convert between `FutureOr<T>` and `JSAny?` (when a JS API accepts or
  returns either a synchronous value or a `Promise`) using
  `toJSPromiseOrValue` and `toDartFutureOr`. When a `Future` converted with
  `.toJS` fails, `JSAny` errors reject the `JSPromise` directly, while other
  Dart errors are wrapped in a JS `Error` with `error`
  ([`JSBoxedDartObject`]) and `stack` properties.
- Export Dart callbacks with [`Function.toJS`] or
  [`Function.toJSCaptureThis`] (including `async` callbacks returning
  `Future<T>`), or export variadic callbacks that take up to four fixed
  parameters and a trailing `JSArray` rest parameter using `toJSVarArgs` or
  `toJSCaptureThisVarArgs`.

:::warning
Compiling to JavaScript versus [Wasm][] can introduce inconsistencies in
both performance and semantics for conversions.
Conversions might have different costs depending on the compiler,
so prefer to only convert values if you need to.

Conversions also might or might not produce a new value. This doesn't matter for
immutable values like numbers, but does matter for types like `List`. Depending
on the implementation, a conversion to `JSArray` might return a reference, a
proxy, or a clone of the original list. To avoid this, do not rely on any
relation between the `List` and `JSArray` and only rely on their contents being
the same. Typed array conversions have a similar limitation. Look up the
specific conversion function for more details.
:::

## Requirements on `external` declarations and `Function.toJS`

To ensure type safety and consistency, the compiler restricts
which types can flow into and out of JS. You can't pass arbitrary Dart values
into JS; instead, use a compatible interop
type, `ExternalDartReference`, or a primitive, which the compiler implicitly
converts. For example, these declarations are allowed:

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

```dart tag=good
@JS()
external void externalDartReference(ExternalDartReference _);
```

Whereas these declarations return an error:

```dart tag=bad
@JS()
external Function get function;
```

```dart tag=bad
@JS()
external set list(List _);
```

These same requirements exist when you use [`Function.toJS`],
[`Function.toJSCaptureThis`], `toJSVarArgs`, or `toJSCaptureThisVarArgs`
to make a Dart function callable in JS.
The values that flow into and out of the callback
must meet the same requirements
(additionally, functions converted with `toJS` or `toJSCaptureThis`
without optional positional parameters can return `Future<T>`,
where `T` is `void` or a subtype of `JSAny?`).

If you use a Dart primitive like `String`, an implicit conversion happens in the
compiler to convert that value from a JS value to a Dart value. If performance
is critical and you don't need to examine the string's contents, use
`JSString` instead (as in the second example) to avoid the conversion cost.

## Compatibility, type checks, and casts

The runtime type of JS types might differ based on the compiler. This affects
runtime type-checking and casts. Therefore, almost always avoid `is` checks
where the value is an interop type or where the target type is an interop type:

On WebAssembly, all JS interop types
(such as `JSString`, `JSArray`, and user-defined extension types)
share a single underlying runtime representation (typically `externref`).
Because Dart's extension types are erased at compile time,
a runtime check like `value is JSString` cannot distinguish
a string from any other JS value,
and will evaluate to `true` for almost any JS value,
leading to silent bugs.

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

You can also use the [`isA`] helper function to check whether
a value is any interop type:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `Array.isArray(a)`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Depending on the type parameter,
the compiler transforms the call into the appropriate type-check for that type.

To avoid invalid type checks with JS interop types,
enable the [`invalid_runtime_check_with_js_interop_types`][] lint rule.

[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types

## `null` vs `undefined`

JS has both a `null` and an `undefined` value. This is in contrast with Dart,
which only has `null`. To make JS values more ergonomic to use, when an
interop member returns either JS `null` or `undefined`, the compiler maps
the value to Dart `null`. Therefore a member like `value` in the following
example can be interpreted as returning a JS object, JS `null`, or `undefined`:

```dart
@JS()
external JSObject? get value;
```

To ensure soundness, if a non-nullable interop member returns JS `null` or
`undefined`, the program throws an error.

:::warning
There is a subtle inconsistency with regards to `undefined` between compiling to
JS and [Wasm][]. While compiling to JS *treats* `undefined` values as if they were
Dart `null`, it doesn't actually *change* the value itself. If an interop member
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

## `JSBoxedDartObject` vs `ExternalDartReference`

Both [`JSBoxedDartObject`] and [`ExternalDartReference`]
can be used to pass opaque references to Dart `Object`s through JavaScript.
However, `JSBoxedDartObject` wraps the opaque reference in a JavaScript object,
while `ExternalDartReference` is the reference itself and therefore is not a JS
type.

Use `JSBoxedDartObject` if you need a JS type or if you need extra checks to
make sure Dart values don't get passed to another Dart runtime. For example, if
the Dart object needs to be placed in a `JSArray` or passed to an API that
accepts a `JSAny`, use `JSBoxedDartObject`. Otherwise, use
`ExternalDartReference` because it's faster.

See [`toExternalReference`] and [`toDartObject`] to convert to and from an
`ExternalDartReference`.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`external`]: /language/functions#external
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`Function.toJSCaptureThis`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJSCaptureThis.html
[`dart:js_interop` API docs]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html#extension-types
[`typeofEquals`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/typeofEquals.html
[`instanceOfString`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/instanceOfString.html
[`isA`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/isA.html
[#54025]: {{site.repo.dart.sdk}}/issues/54025
[`JSBoxedDartObject`]: {{site.dart-api}}/dart-js_interop/JSBoxedDartObject-extension-type.html
[`ExternalDartReference`]: {{site.dart-api}}/dart-js_interop/ExternalDartReference-extension-type.html
[`toExternalReference`]: {{site.dart-api}}/dart-js_interop/ObjectToExternalDartReference/toExternalReference.html
[`toDartObject`]: {{site.dart-api}}/dart-js_interop/ExternalDartReferenceToObject/toDartObject.html
[Wasm]: /web/wasm