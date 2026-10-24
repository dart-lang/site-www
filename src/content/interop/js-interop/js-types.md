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
[Wasm][], they execute in separate *runtimes* as well. As such, you should treat JS
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
  - Primitives: `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - `JSObject`, which is any JS object
    - `JSFunction`
      - `JSExportedDartFunction`, which represents a Dart callback that was
      converted to a JS function
    - `JSArray`, which implements `JSIterable`
    - `JSIterable` (and `JSIterableProtocol`),
      which represents a JS object that implements the [JS iterable protocol][]
      (such as `JSArray` and `JSString`)
    - `JSIterator` (and `JSIteratorProtocol` / `JSIteratorResult`),
      which represents a JS iterator
    - `JSDisposableProtocol`,
      which represents a JS object that implements the
      explicit resource management (`Symbol.dispose`) protocol
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - JS typed arrays like `JSUint8Array`
    - `JSBoxedDartObject`, which allows users to box and pass Dart values
      opaquely within the same Dart runtime
      - From Dart 3.4 onwards, the type `ExternalDartReference` in
      `dart:js_interop` also allows users to pass Dart values opaquely, but is
      *not* a JS type. Learn more about the tradeoffs between each option
      [here](#jsboxeddartobject-vs-externaldartreference).

You can find the definition of each type in the [`dart:js_interop` API docs].

### Built-in type helpers

Several built-in JS types expose static and instance members
for common JavaScript operations:

- **`JSPromise`**: Use `JSPromise.resolve(value)` and `JSPromise.reject(reason)`
  to create resolved or rejected promises directly,
  without constructing a Dart `Future` first.
- **`JSArray`**: Use `JSArray.from(arrayLike)` to create a shallow-copied
  `JSArray` from a JS iterable or array-like object,
  and `JSArray.fromAsync(arrayLike)` to asynchronously create a
  `JSPromise<JSArray<T>>` from an async iterable or an array-like object
  that contains promises.
- **`JSFunction`**: Use the `JSFunction.length` (`int`) and
  `JSFunction.name` (`String`) getters
  to inspect a JS function's declared parameter count and name.
- **`JSSymbol`**: Construct unique symbols with `JSSymbol([description])`,
  look up or register shared symbols in the global symbol registry with
  `JSSymbol.forKey(key)`,
  inspect `description` and `key`,
  and access standard well-known symbols through static getters
  such as `JSSymbol.iterator`, `JSSymbol.asyncIterator`,
  `JSSymbol.toPrimitive`, and `JSSymbol.toStringTag`.

{% comment %}
TODO (srujzs): Should we add a tree diagram instead for JS types?
{% endcomment %}

## Conversions

To use a value from one domain to another, you will likely want to *convert* the
value to the corresponding type of the other domain. For example, you might want
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
| `JSIterable<T extends JSAny?>`                                 | `Iterable<T extends JSAny?>`                                           |
| `JSIterator<T extends JSAny?>`                                 | `Iterator<T extends JSAny?>`                                           |
| `JSPromise<T extends JSAny?>`                                  | `Future<T extends JSAny?>`                                             |
| `JSAny?` (`JSPromise` or value)                                | `FutureOr<T extends JSAny?>`                                           |
| Typed arrays like `JSUint8Array`                               | Typed lists from `dart:typed_data`                                     |
| `JSBoxedDartObject`                                            | Opaque Dart value                                                      |
| `ExternalDartReference`                                        | Opaque Dart value                                                      |

{:.table .table-striped}

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

### Primitive list and `JSArray` conversions

In addition to converting between `List<T extends JSAny?>` and `JSArray<T>`
with `.toJS` and `.toDart`,
you can convert directly between primitive Dart lists and `JSArray`:

- **Dart to JS**: Call `.toJS` on `List<num>`, `List<String>`, or `List<bool>`
  (as well as lists with nullable elements:
  `List<num?>`, `List<String?>`, and `List<bool?>`).
- **JS to Dart**: Call `.toDartDoubleList` or `.toDartIntList` on
  `JSArray<JSNumber>`,
  `.toDartStringList` on `JSArray<JSString>`,
  or `.toDartBoolList` on `JSArray<JSBoolean>`
  (as well as arrays with nullable elements like `JSArray<JSNumber?>`).

```dart
final JSArray<JSNumber> jsNums = <int>[1, 2, 3].toJS;
final List<int> dartInts = jsNums.toDartIntList;

final JSArray<JSString?> jsStrings = <String?>['a', null, 'b'].toJS;
final List<String?> dartStrings = jsStrings.toDartStringList;
```

When compiling to JavaScript,
these conversions return a lazy cast-list view
backed by the original list or array.
When compiling to [Wasm][],
they eagerly copy the elements into a new `JSArray` or `List`.

### Iterable and iterator conversions

To iterate lazily across the JS boundary
without copying elements into a `List` or `JSArray`,
convert between Dart and JS iterables and iterators:

- Use `Iterable<T>.toJSIterable` and `JSIterable<T>.toDartIterable`
  to convert between `Iterable<T>` and `JSIterable<T>`.
- Use `Iterator<T>.toJSIterator` and `JSIterator<T>.toDartIterator`
  to convert between `Iterator<T>` and `JSIterator<T>`.

### `Future`, `JSPromise`, and `FutureOr` conversions

Use `Future.toJS` and `JSPromise.toDart`
to convert between Dart `Future`s and JS `Promise`s.

When a `Future` converted with `.toJS` fails:

- If the error is already a JS value (`JSAny`),
  the resulting `JSPromise` rejects directly with that unwrapped JS value.
- Otherwise, the `JSPromise` rejects with a JS `Error`
  that wraps the Dart error.
  The rejected `Error` exposes the original Dart error
  as a [`JSBoxedDartObject`][] on its `error` property,
  and the Dart stack trace as a `String` on its `stack` property.

When working with JS APIs that accept or return
either a synchronous value or a `Promise` (a `thenable`),
use the `FutureOr` conversion helpers:

- `FutureOr<T>.toJSPromiseOrValue` converts a `Future<T>` to a `JSPromise<T>`
  using `.toJS`,
  or returns a synchronous `T` value directly as `JSAny?`.
- `JSAny?.toDartFutureOr` converts a `JSPromise` to a `Future<JSAny?>`
  using `.toDart`,
  or returns any other JS value synchronously.

### Function conversions: async and variadic callbacks

Use [`Function.toJS`][]
(or [`Function.toJSCaptureThis`][] when you need to capture
the JS `this` binding as the first parameter)
to wrap a Dart function as a [`JSExportedDartFunction`][].

#### Async callbacks

As of Dart 3.14, `Function.toJS` and `Function.toJSCaptureThis`
support Dart functions without optional positional parameters
that return `Future<T>`,
where `T` is `void` or a subtype of `JSAny?`.
The exported JS function automatically converts
the returned `Future` into a `JSPromise`:

```dart
Future<JSString> fetchGreeting(JSString name) async {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  return 'Hello, ${name.toDart}!'.toJS;
}

// Produces a JS function `(name) => Promise<string>`.
final JSExportedDartFunction jsFetchGreeting = fetchGreeting.toJS;
```

#### Variadic callbacks

Standard `Function.toJS` supports functions with up to five fixed parameters.
To export a Dart callback that accepts a variable number of arguments in JS,
use `toJSVarArgs` (or `toJSCaptureThisVarArgs`).
The Dart function can take up to four fixed leading parameters,
followed by a trailing `JSArray<E>` parameter
that receives all remaining arguments:

```dart
void logItems(JSString prefix, JSArray<JSAny?> rest) {
  print('${prefix.toDart}: ${rest.toDart}');
}

// Produces a JS function `(prefix, ...rest) => logItems(prefix, rest)`.
final JSExportedDartFunction jsLogItems = logItems.toJSVarArgs;
```

## Requirements on `external` declarations and `Function.toJS`

In order to ensure type safety and consistency, the compiler places requirements
on what types can flow into and out of JS. Passing arbitrary Dart values into JS
is not allowed. Instead, the compiler requires users to use a compatible interop
type, `ExternalDartReference`, or a primitive, which is then implicitly
converted by the compiler. For example, these declarations are allowed:

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
must be a compatible interop type, `ExternalDartReference`, or a primitive
(or, for `toJS` and `toJSCaptureThis` without optional positional parameters,
a return type of `Future<T>` where `T` is `void` or a subtype of `JSAny?`).

If you use a Dart primitive like `String`, an implicit conversion happens in the
compiler to convert that value from a JS value to a Dart value. If performance
is critical and you don’t need to examine the contents of the string, then using
`JSString` instead to avoid the conversion cost might make sense like in the
second example.

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

From Dart 3.4 onwards, you can use the [`isA`] helper function to check whether
a value is any interop type:

```dart tag=good
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `Array.isArray(a)` or `instanceOfString('Array')`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Depending on the type parameter,
the compiler transforms the call into the appropriate type-check for that type.
For `JSArray`, `isA<JSArray>()` checks both `Array.isArray` and
`instanceof Array`,
so it also recognizes arrays created across different JS realms
(such as an `iframe`).

To avoid invalid type checks with JS interop types,
enable the [`invalid_runtime_check_with_js_interop_types`][] lint rule.

[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types

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

From Dart 3.4 onwards, both [`JSBoxedDartObject`] and [`ExternalDartReference`]
can be used to pass opaque references to Dart `Object`s through JavaScript.
However, `JSBoxedDartObject` wraps the opaque reference in a JavaScript object,
while `ExternalDartReference` is the reference itself and therefore is not a JS
type.

Use `JSBoxedDartObject` if you need a JS type or if you need extra checks to
make sure Dart values don't get passed to another Dart runtime. For example, if
the Dart object needs to be placed in a `JSArray` or passed to an API that
accepts a `JSAny`, use `JSBoxedDartObject`. Use `ExternalDartReference`
otherwise as it will be faster.

See [`toExternalReference`] and [`toDartObject`] to convert to and from an
`ExternalDartReference`.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`external`]: /language/functions#external
[JS iterable protocol]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Iteration_protocols#the_iterable_protocol
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`Function.toJSCaptureThis`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJSCaptureThis.html
[`JSExportedDartFunction`]: {{site.dart-api}}/dart-js_interop/JSExportedDartFunction-extension-type.html
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