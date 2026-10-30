---
title: JS interop usage
breadcrumb: Usage
description: How to declare and use JS interop members.
prevpage:
  url: /interop/js-interop/
  title: JS interop
nextpage:
  url: /interop/js-interop/js-types
  title: JS types
---

The `dart:js_interop` library lets you call JavaScript APIs and interact with
JS values by using idiomatic Dart syntax.
To access a JavaScript API from Dart, expose it in the [global JS scope][] and
use the following mechanisms:

- Declare [`external` interop members](#interop-members) to call JS APIs and
  receive JS values.
- Use or declare [interop types](#interop-types) to provide Dart types and
  interfaces for JS values.
- Use [conversion functions][] to convert values between Dart and JS, unless an
  interop signature uses [allowed primitive types][contains a primitive type].

[global JS scope]: https://developer.mozilla.org/docs/Glossary/Global_scope
[conversion functions]: /interop/js-interop/js-types#conversions
[contains a primitive type]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

## Interop types

When interacting with a JS value, you need to provide a Dart type for it.
You can do this by using or declaring an interop type.
Interop types are either a [JS type][] provided by Dart or
an [extension type][] wrapping an interop type.

Interop types allow you to provide an interface for a JS value and
let you declare interop APIs for its members.
You also use them in the signatures of other interop APIs:

```dart
extension type Window(JSObject _) implements JSObject {}
```

The `Window` extension type is an interop type for an arbitrary `JSObject`
instance.
The compiler doesn't provide a [runtime guarantee][] that a `Window` value is
actually a JS [`Window`][] object,
and defining multiple interop interfaces for the same underlying JS value
doesn't cause a conflict.
If you want to verify that a `Window` value is actually a JS `Window` object,
you can [check the type of the JS value through interop][].

You can also declare your own interop type for the JS types that
Dart provides by wrapping them:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external Array();
}
```

In most cases, declare an interop type by using
the `JSObject` type as the [representation type][] when
interacting with JS objects that don't have an interop type provided by Dart.

Also, make interop types [implement][] their representation type so
that you can use them where an API expects the representation type,
like in many APIs provided by [`package:web`][].

[JS type]: /interop/js-interop/js-types
[extension type]: /language/extension-types
[`Window`]: https://developer.mozilla.org/docs/Web/API/Window
[runtime guarantee]: /language/extension-types#type-considerations
[check the type of the JS value through interop]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[representation type]: /language/extension-types#declaration
[implement]: /language/extension-types#implements
[`package:web`]: {{site.pub-pkg}}/web

## Interop members

Interop members declared with the [`external`][] keyword provide an idiomatic
syntax for JS members, letting you write a Dart type signature for their
arguments and return values.
The compiler places [restrictions][] on the types that you can use in the
signature of these members.
The combination of where you declare an interop member, its name,
what kind of Dart member it is, and any [renames](#js) determines
which JS API it corresponds to.

[`external`]: /language/functions#external
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

### Top-level interop members

Consider the following JS members:

```js
globalThis.name = 'global';
globalThis.isNameEmpty = function() {
  return globalThis.name.length == 0;
}
```

You can write interop members for them as shown in the following example:

```dart
@JS()
external String get name;

@JS()
external set name(String value);

@JS()
external bool isNameEmpty();
```

Here, the global scope exposes the `name` property and `isNameEmpty` function.
To access them, you use top-level interop members.
To get and set the `name` property, declare and use
an interop getter and setter with the same name.
To use the `isNameEmpty` function, declare and call
an interop function with the same name.
You can declare top-level interop getters, setters, methods, and fields.
Interop fields are equivalent to getter and setter pairs.

Declare top-level interop members with the [`@JS()`](#js) annotation to
distinguish them from other `external` top-level members,
such as those that use the `dart:ffi` library.

### Interop type members

Consider the following JS `Time` class:

```js
class Time {
  constructor(hours, minutes) {
    this._hours = Math.abs(hours) % 24;
    this._minutes = arguments.length == 1 ? 0 : Math.abs(minutes) % 60;
  }

  static dinnerTime = new Time(18, 0);

  static getTimeDifference(t1, t2) {
    return new Time(t1.hours - t2.hours, t1.minutes - t2.minutes);
  }

  get hours() {
    return this._hours;
  }

  set hours(value) {
    this._hours = Math.abs(value) % 24;
  }

  get minutes() {
    return this._minutes;
  }

  set minutes(value) {
    this._minutes = Math.abs(value) % 60;
  }

  isDinnerTime() {
    return this.hours == Time.dinnerTime.hours && this.minutes == Time.dinnerTime.minutes;
  }
}
// Need to expose the type to the global scope.
globalThis.Time = Time;
```

You can write an interop interface for the `Time` class as shown in the
following example:

```dart
extension type Time._(JSObject _) implements JSObject {
  external Time(int hours, int minutes);
  external factory Time.onlyHours(int hours);

  external static Time dinnerTime;
  external static Time getTimeDifference(Time t1, Time t2);

  external int hours;
  external int minutes;
  external bool isDinnerTime();

  bool isMidnight() => hours == 0 && minutes == 0;
}
```

Within an interop type, you can declare several different types of
`external` interop members.

### Constructors

Positional constructors create a new JS object by calling `new` on the
extension type's JS name:

```dart
final time = Time(0, 0); // Calls `new Time(0, 0)`
final midnight = Time.onlyHours(0); // Calls `new Time(0)`
```

Unnamed constructors, named constructors, and `factory` constructors with
positional parameters all follow the same JS invocation semantics.

### Object literal constructors

To create a JS [object literal][] with specific properties, declare a
constructor (with or without the `factory` keyword) that takes only named
parameters matching the JS property names:

```dart
extension type Options._(JSObject o) implements JSObject {
  external Options({int a, int b});
  external int get a;
  external int get b;
}

final full = Options(a: 0, b: 1); // Creates `{a: 0, b: 1}`
final partial = Options(a: 0); // Creates `{a: 0}`
```

Only the arguments you pass are included as properties on the created JS
object. You can then read or modify those properties through `external`
instance members.

:::note
Unlike legacy `package:js`, object literal constructors in `dart:js_interop`
don't require `@anonymous` or [`@JS`](#js) annotations.
:::

### Static members

Like constructors, `static` methods, getters, setters, and fields use the
extension type's JS name:

```dart
final dinner = Time.dinnerTime; // Gets `Time.dinnerTime`
final diff = Time.getTimeDifference(t1, t2); // Calls `Time.getTimeDifference(t1, t2)`
```

### Instance members

Instance methods, getters, setters, and fields get, set, or invoke properties
on a JS object instance:

```dart
final time = Time(0, 0);
print(time.isDinnerTime()); // Calls `time.isDinnerTime()` -> false
final dinnerTime = Time.dinnerTime;
time.hours = dinnerTime.hours; // Gets `dinnerTime.hours` and sets `time.hours`
time.minutes = dinnerTime.minutes;
print(time.isDinnerTime()); // true
```

### Operators

Interop types support only two `external` interop operators: `[]` and `[]=`,
which map to JavaScript's [property accessors][]:

```dart
extension type Array(JSArray<JSNumber> _) implements JSArray<JSNumber> {
  external JSNumber operator [](int index);
  external void operator []=(int index, JSNumber value);
}

final first = array[0]; // Reads `array[0]`
array[0] = 42.toJS; // Sets `array[0] = 42`
```

The `dart:js_interop` library exposes other JS operators through
[utility functions][].

Interop types can also declare [non-`external` members][], such as the
`isMidnight` method in the `Time` example.

[object literal]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Object_initializer
[property accessors]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation
[utility functions]: {{site.dart-api}}/dart-js_interop/JSAnyOperatorExtension.html
[non-`external` members]: /language/extension-types#members

### Extension members on interop types

You can also write `external` members in [extensions][] of interop types,
including extensions on a generic type parameter bounded by an interop type,
as shown in the following example:

```dart
extension on Array {
  external int push(JSAny? any);
}

extension <T extends JSObject> on T {
  external T clone();
}
```

Calling the `push` method behaves the same as if
you declared it directly in the `Array` extension type.
Similarly, calling the `clone` method on any subtype of the `JSObject` type
invokes the JS `clone` method
and preserves the receiver's static type `T`.
Extensions can have `external` instance members and operators but
can't have `external` `static` members or constructors.
Like with interop types, you can
write any non-`external` members in the extension.
Extensions are useful when an interop type doesn't
expose the `external` member you need and you don't want to
create a new interop type.

[extensions]: /language/extension-methods

### Parameters

An `external` interop method can contain only positional and optional
arguments.
This restriction exists because JS members take only positional arguments.
The only exception is object literal constructors,
which accept only named arguments.

Unlike with non-`external` methods, the compiler omits optional arguments
instead of replacing them with their default values.
For example, consider the following method:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Calling `array.push(0.toJS)` in Dart results in
a JS invocation of `array.push(0.toJS)` rather than `array.push(0.toJS, null)`.
This behavior avoids having to write multiple interop members for
the same JS API to omit `null` arguments.
If you declare a parameter with an explicit default value,
the compiler warns you that it ignores the value.

## `@JS()`

[`@JS()`][] tells the compiler that a declaration is
a JS interop member or type, and optionally renames or namespaces it in JS:

- On top-level declarations, `@JS()` is required (with or without a string
  value) to distinguish them from other `external` declarations like
  `dart:ffi`.
- On interop types and extension members, `@JS()` is optional when the Dart
  name matches the JS name, because the compiler infers JS interop from the
  representation type or `on` type.

### Rename interop members and types

Pass a constant string to the `@JS()` annotation when the Dart name needs to
differ from the JS name. For example, you might overload a JS method with
multiple Dart signatures, define multiple interop types for the same JS
interface, or bind a JS identifier like `$a` that isn't a valid Dart name:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

Both `push` and `pushString` invoke `push` in JS.

You can also rename an interop type:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate(); // Calls `new Date()`
  external static int now(); // Calls `Date.now()`
}
```

Because constructors always invoke the enclosing extension type's JS name,
you can't place a `@JS()` annotation on an `external` constructor or factory
of an interop extension type. Annotate the extension type declaration instead.

### Namespace a library

Place `@JS()` on a `library` directive to add a namespace prefix to all
top-level interop members, interop types, and `static` interop members in that
library. You can also use `.`-delimited namespaces on libraries, top-level
members, and interop types:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method(); // Calls `library1.library2.library3.method()`

@JS('library3.JSType')
extension type JSType._(JSObject _) implements JSObject {
  external JSType(); // Calls `new library1.library2.library3.JSType()`
  external static int get staticMember; // Gets `library1.library2.library3.JSType.staticMember`
}
```

Keep these namespacing rules in mind:

- A Dart `library` name (such as `library interop_library;`) is never used as a
  JS namespace unless you provide a non-empty string in `@JS('...')`.
- You can't use `.`-delimited names in `@JS()` annotations on interop type
  members or extension members.
- If you omit the value in `@JS()` or pass an empty string, the compiler uses
  the declaration's Dart name.

[`@JS()`]: {{site.dart-api}}/dart-js_interop/JS-class.html

<a id="exporting-dart-functions-and-objects-to-js" aria-hidden="true"></a>
## Export Dart functions and objects to JS {:#export}

The preceding sections show how to call JS members from Dart.
It's also useful to export Dart code so that you can call it from JS.
To export a Dart function to JS, first convert it by using the
[`Function.toJS`][] getter, or by using the `toJSVarArgs` getter for variadic
callbacks.
This conversion wraps the Dart function in a JS function and automatically
converts any returned `Future` instance into a `JSPromise` object.
Then, pass the wrapped function to JS through an interop member.
At that point, JS code can call the function.

For example, the following code exports synchronous, asynchronous, and variadic
Dart functions to global JS properties and calls them from JS:

```dart
import 'dart:js_interop';

@JS()
external set exportedFunction(JSFunction value);

@JS()
external set asyncFunction(JSFunction value);

@JS()
external set logAll(JSFunction value);

void printString(JSString string) {
  print(string.toDart);
}

Future<JSString> fetchGreeting(JSString name) async =>
    'Hello, ${name.toDart}!'.toJS;

void printArgs(JSArray<JSString> args) {
  print(args.toDartStringList.join(', '));
}

void main() {
  exportedFunction = printString.toJS;
  asyncFunction = fetchGreeting.toJS;
  logAll = printArgs.toJSVarArgs;
}
```

```js
globalThis.exportedFunction('hello world');
await globalThis.asyncFunction('Dash');
globalThis.logAll('a', 'b', 'c');
```

Functions that you export this way have type [restrictions][] similar to
those of interop members.

Sometimes it's useful to export an entire Dart interface so that
JS can interact with a Dart object.
To do this, mark the Dart class as exportable by using the [`@JSExport`][]
annotation and wrap instances of that class by using the
[`createJSInteropWrapper`][] function.
For a more detailed explanation of this technique, including how to
mock JS values, refer to [How to mock JavaScript interop objects][].

[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[How to mock JavaScript interop objects]: /interop/js-interop/mock

## `dart:js_interop` and `dart:js_interop_unsafe`

The [`dart:js_interop`][] library contains the core members you need,
including the `@JS()` annotation, JS types, conversion functions, and various
utility functions.
Utility functions include the following:

- [`globalContext`][]: Represents the global scope that
  the compilers use to find interop members and types.
- [Helpers to inspect the type of JS values][]: Examine the underlying
  JavaScript value of an interop type.
- [JS operators][utility functions]: Expose JavaScript operators as utility
  members.
- [`dartify`][] and [`jsify`][]: Check the type of certain JS values and
  convert them from JS values to Dart values or from Dart values to JS values.
  Prefer using the specific conversion when you know the type of the JS value,
  as the extra type checking might be expensive.
- [`importModule`][]: Imports modules dynamically as a `JSObject` instance.
- [`isA`][]: Checks whether a JS interop value is
  an instance of the JS type specified by the type argument.
- `jsIdentical`: Checks whether two JS values are identical
  by using JavaScript's `===` strict equality semantics.

The [`dart:js_interop_unsafe`][] library contains members that allow
you to look up properties dynamically.
For example, you can access the `log` property on `console` by using a string:

```dart
JSFunction f = console['log'];
```

Instead of declaring an interop member named `log`,
you can use a string to access the property.
The `dart:js_interop_unsafe` library also provides functions to
dynamically check for, get, set, and call properties.

:::tip
Avoid using `dart:js_interop_unsafe` if possible.
It makes security compliance more difficult to guarantee and
might lead to violations, which is why it can be "unsafe".
:::

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`globalContext`]: {{site.dart-api}}/dart-js_interop/globalContext.html
[Helpers to inspect the type of JS values]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension.html
[`dartify`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/dartify.html
[`jsify`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/jsify.html
[`importModule`]: {{site.dart-api}}/dart-js_interop/importModule.html
[`isA`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/isA.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
