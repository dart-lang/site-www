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

Dart values and JS values belong to separate language domains.
When compiling to [Wasm][], they execute in separate runtimes as well.
Treat JS values as foreign types.
To provide Dart types for JS values, the [`dart:js_interop`] library exposes
a set of types prefixed with `JS` called JS types.
These types distinguish between Dart values and JS values at compile time.

The compiler represents these types differently
based on whether you compile to Wasm or JS.
Because of this difference, their runtime types differ, so you
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
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - JS typed arrays like `JSUint8Array`
    - `JSBoxedDartObject`, which boxes Dart values so you can pass them
      opaquely within the same Dart runtime
  - `JSIterable` and `JSIterator`

The `ExternalDartReference` type in the `dart:js_interop` library also passes
Dart values opaquely, but it isn't a JS type.
To compare the two options, refer to the
[`JSBoxedDartObject` versus `ExternalDartReference`](#jsboxeddartobject-vs-externaldartreference)
section on this page.

You can find the definition of each type and its built-in helpers in the
[`dart:js_interop` API documentation][`dart:js_interop` API docs].
These helpers include `JSPromise.resolve`, `JSPromise.reject`,
`JSArray.fromAsync`, `JSFunction.length`, `JSFunction.name`,
and well-known `JSSymbol` constants.

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversions

To use a value from one domain in the other, convert it
to the corresponding type.
For example, to pass a Dart `List<String>` to a JS interop API that expects a
JS array of strings, convert the list to the `JSArray<JSString>` type.

Members that convert values from Dart to JS usually start with `toJS`, and
members that convert values from JS to Dart usually start with `toDart`:

```dart
// Dart to JS
JSString jsStr = 'hello world'.toJS;
JSArray<JSString> jsArr = ['a', 'b'].toJS;

// JS to Dart
String dartStr = jsStr.toDart;
List<String> dartList = jsArr.toDartStringList;
JSAny? resolved = await jsPromise.toDart;
for (final item in jsIterable.toDartIterable) { … }
```

Not all JS types have a conversion, and not all Dart types have a conversion.
The following table lists the supported conversions between `dart:js_interop`
types and Dart types:

| `dart:js_interop` type                                         | Dart type                                                                                     | Dart to JS                                                           | JS to Dart                                                                |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `JSNumber`, `JSBoolean`, `JSString`                            | `num`, `int`, `double`, `bool`, `String`                                                      | `toJS`                                                               | `toDartDouble`, `toDartInt`, `toDart`                                     |
| `JSExportedDartFunction`                                       | `Function`                                                                                    | `toJS`, `toJSCaptureThis`, `toJSVarArgs`, `toJSCaptureThisVarArgs`   | `toDart`                                                                  |
| `JSArray<T extends JSAny?>`                                    | `List<T extends JSAny?>`                                                                      | `toJS`                                                               | `toDart`                                                                  |
| `JSArray<JSNumber?>`, `JSArray<JSBoolean?>`, `JSArray<JSString?>` | `List<num?>`, `List<int?>`, `List<double?>`, `List<bool?>`, `List<String?>` (and non-nullable) | `toJS`                                                               | `toDartDoubleList`, `toDartIntList`, `toDartBoolList`, `toDartStringList` |
| `JSIterable<T extends JSAny?>`, `JSIterator<T extends JSAny?>` | `Iterable<T extends JSAny?>`, `Iterator<T extends JSAny?>` (lazy, without copying)            | `toJSIterable`, `toJSIterator`                                       | `toDartIterable`, `toDartIterator`                                        |
| `JSPromise<T extends JSAny?>`                                  | `Future<T extends JSAny?>`                                                                    | `toJS`                                                               | `toDart`                                                                  |
| `JSAny?` (`JSPromise` or value)                                | `FutureOr<T extends JSAny?>`                                                                  | `toJSPromiseOrValue`                                                 | `toDartFutureOr`                                                          |
| Typed arrays like `JSUint8Array`                               | Typed lists from `dart:typed_data`                                                            | `toJS`                                                               | `toDart`                                                                  |
| `JSBoxedDartObject`                                            | Opaque Dart `Object`                                                                          | `toJSBox`                                                            | `toDart`                                                                  |
| `ExternalDartReference`                                        | Opaque Dart `Object?`                                                                         | `toExternalReference`                                                | `toDartObject`                                                            |

{:.table .table-striped}

When converting `Function` or `Future` values:

- Use [`Function.toJS`] for fixed-arity callbacks, or `toJSVarArgs` for variadic
  callbacks that receive all arguments in a `JSArray`. Use
  [`Function.toJSCaptureThis`] or `toJSCaptureThisVarArgs` to pass JavaScript's
  `this` value as the callback's first parameter.
- When a `Future` converted with `toJS` or `toJSPromiseOrValue` fails, `JSAny`
  errors reject the `JSPromise` directly, while other Dart errors reject with a
  JS `Error` containing `error` ([`JSBoxedDartObject`]) and `stack` properties.

:::warning
Conversion costs and semantics vary between JavaScript and [Wasm][] targets, so
convert values only when necessary. Converting a mutable collection like a
`List` or typed list might return a reference, a proxy, or a copy. Don't rely
on mutations to one affecting the other.
:::

## Requirements on `external` declarations and `Function.toJS`

To ensure type safety, the compiler restricts which types can flow into and out
of JS. Parameter and return types in `external` declarations must be one of the
following:

- A JS type from `dart:js_interop` (such as `JSString` or `JSArray`) or a
  custom interop extension type.
- An `ExternalDartReference` value.
- A Dart primitive (`bool`, `num`, `int`, `double`, `String`, or `void`), which
  the compiler implicitly converts.

```dart tag=good
extension type InteropType(JSObject _) implements JSObject {}

@JS()
external void primitives(String a, int b, double c, num d, bool e);

@JS()
external JSArray jsTypes(JSObject a, JSString b);

@JS()
external InteropType get interopType;

@JS()
external void externalReference(ExternalDartReference ref);
```

Arbitrary Dart types like `Function` or `List` aren't allowed directly in
`external` declarations and cause a compile-time error:

```dart tag=bad
@JS()
external Function get function;

@JS()
external set list(List value);
```

The same type restrictions apply to parameters and return values of Dart
callbacks converted with [`Function.toJS`], [`Function.toJSCaptureThis`],
`toJSVarArgs`, or `toJSCaptureThisVarArgs`. Callbacks without optional
positional parameters that you convert with `toJS` or `toJSCaptureThis` can
also be `async` and return `Future<T>`, where `T` is `void` or a subtype of
`JSAny?`.

:::tip
Dart primitives like `String` incur an implicit conversion cost. If performance
is critical and you don't need to inspect the string's contents in Dart, accept
or return `JSString` instead.
:::

## Compatibility, type checks, and casts

Because JS interop types are extension types that erase to a single runtime
representation (`externref`) on WebAssembly, standard Dart `is` checks and `as`
casts can't distinguish between JS types at runtime and might silently succeed
on the wrong type.

Avoid `is` checks and `as` casts involving interop types:

```dart tag=bad
void f(JSAny a, JSString s) {
  if (a is String) { … }
  if (a is JSObject) { … }
  var str = s as String;
}
```

Instead, use the [`isA`] helper to check whether a JS value matches a specific
JS type or custom interop type:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // Checks `typeof a === 'string'`
  if (a.isA<JSArray>()) {} // Checks `Array.isArray(a)`
  if (a.isA<CustomInteropType>()) {} // Checks `a instanceof CustomInteropType`
}
```

You can also inspect the underlying JS value with [`typeofEquals`] or
[`instanceOfString`] before casting between interop types:

```dart tag=good
void f(JSAny a) {
  if (a.typeofEquals('function')) {
    var fn = a as JSFunction;
  }
}
```

To catch invalid runtime checks at compile time, enable the
[`invalid_runtime_check_with_js_interop_types`][] lint rule.

[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types

## `null` versus `undefined` {:#null-vs-undefined}

JavaScript has both `null` and `undefined`, whereas Dart has only `null`.
When an interop member returns either JS `null` or `undefined`, the compiler
maps the result to Dart `null`:

```dart
@JS()
external JSObject? get value; // Can return a JSObject, JS null, or undefined.
```

If a non-nullable interop member returns JS `null` or `undefined`, the program
throws a runtime error.

:::warning
JavaScript and [Wasm][] targets handle `undefined` round-tripping differently.
When compiling to JS, Dart treats `undefined` as `null` without changing the
underlying value, so passing it back to JS preserves `undefined`. When
compiling to Wasm, the compiler converts both JS `null` and `undefined` to Dart
`null`, so passing it back to JS always produces `null`. Pass Dart `null`
explicitly instead of relying on `undefined` round-tripping. For details, refer
to issue [#54025].
:::

## `JSBoxedDartObject` versus `ExternalDartReference` {:#jsboxeddartobject-vs-externaldartreference}

Both [`JSBoxedDartObject`] and [`ExternalDartReference`] pass opaque references
to Dart `Object` instances through JavaScript:

| Type | Representation | When to use |
| --- | --- | --- |
| [`ExternalDartReference`] ([`toExternalReference`] / [`toDartObject`]) | Direct opaque reference (not a subtype of `JSAny`; supports nullable `Object?`) | Default choice for performance when passing a Dart object to and from JS. |
| [`JSBoxedDartObject`] (`toJSBox` / `toDart`) | Wrapped in a JS object (subtype of `JSObject` and `JSAny`) | When an API requires a `JSAny` subtype (such as storing in a `JSArray`) or when you need runtime checks preventing access across different Dart runtimes. |

{:.table .table-striped}

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`external`]: /language/functions#external
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`Function.toJSCaptureThis`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJSCaptureThis.html
[`dart:js_interop` API docs]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html#extension-types
[`typeofEquals`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/typeofEquals.html
[`instanceOfString`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/instanceOfString.html
[`isA`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/isA.html
[#54025]: {{site.repo.dart.sdk}}/issues/54025
[`JSBoxedDartObject`]: {{site.dart-api}}/dart-js_interop/JSBoxedDartObject-extension-type.html
[`ExternalDartReference`]: {{site.dart-api}}/dart-js_interop/ExternalDartReference-extension-type.html
[`toExternalReference`]: {{site.dart-api}}/dart-js_interop/ObjectToExternalDartReference/toExternalReference.html
[`toDartObject`]: {{site.dart-api}}/dart-js_interop/ExternalDartReferenceToObject/toDartObject.html
[Wasm]: /web/wasm