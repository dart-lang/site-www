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

JS interop provides the mechanisms to interact with JavaScript APIs from Dart.
It allows you to invoke these APIs and interact with the values that
you get from them using an explicit, idiomatic syntax.

Typically, you access a JavaScript API by making it available
somewhere within the [global JS scope][].
To call and receive JS values from this API,
you use [`external` interop members](#interop-members).
To construct and provide types for JS values, you use and declare
[interop types](#interop-types), which also contain interop members.
To pass Dart values like a `List` or `Function` to interop members or
convert from JS values to Dart values, you use [conversion functions][] unless
the interop member [contains a primitive type][].

[global JS scope]: https://developer.mozilla.org/docs/Glossary/Global_scope
[conversion functions]: /interop/js-interop/js-types#conversions
[contains a primitive type]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

## Interop types

When interacting with a JS value, you need to provide a Dart type for it.
You can do this by either using or declaring an interop type.
Interop types are either a ["JS type"][] provided by Dart or
an [extension type][] wrapping an interop type.

Interop types allow you to provide an interface for a JS value and
let you declare interop APIs for its members.
They're also used in the signature of other interop APIs.

```dart
extension type Window(JSObject _) implements JSObject {}
```

`Window` is an interop type for an arbitrary `JSObject`.
There's no [runtime guarantee][] that `Window` is actually a JS [`Window`][].
There also is no conflict with any other interop interface that
is defined for the same value.
If you want to check that `Window` is actually a JS `Window`,
you can [check the type of the JS value through interop][].

You can also declare your own interop type for the JS types that
Dart provides by wrapping them:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external Array();
}
```

In most cases, you'll likely declare an interop type using
`JSObject` as the [representation type][], because you're likely
interacting with JS objects which don't have an interop type provided by Dart.

Interop types should also generally [implement][] their representation type so
that they can be used where the representation type is expected,
like in many APIs provided by [`package:web`][].

["JS type"]: /interop/js-interop/js-types
[extension type]: /language/extension-types
[`Window`]: https://developer.mozilla.org/docs/Web/API/Window
[runtime guarantee]: /language/extension-types#type-considerations
[check the type of the JS value through interop]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[representation type]: /language/extension-types#declaration
[implement]: /language/extension-types#implements
[`package:web`]: {{site.pub-pkg}}/web

## Interop members

[`external`][] interop members provide an idiomatic syntax for JS members.
They allow you to write a Dart type signature for its
arguments and return value.
The types that can be written in the signature of
these members have [restrictions][].
The JS API the interop member corresponds to is determined by a combination of
where it's declared, its name, what kind of Dart member it is, and any
[renames](#js).

[`external`]: /language/functions#external
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs

### Top-level interop members

Given the following JS members:

```js
globalThis.name = 'global';
globalThis.isNameEmpty = function() {
  return globalThis.name.length == 0;
}
```

You can write interop members for them like so:

```dart
@JS()
external String get name;

@JS()
external set name(String value);

@JS()
external bool isNameEmpty();
```

Here, there exists a property `name` and a function `isNameEmpty` that
are exposed in the global scope. 
To access them, you use top-level interop members.
To get and set `name`, declare and use
an interop getter and setter with the same name.
To use `isNameEmpty`, declare and call an interop function with the same name.
You can declare top-level interop getters, setters, methods, and fields.
Interop fields are equivalent to getter and setter pairs.

Top-level interop members must be declared with a [`@JS()`](#js) annotation to
distinguish them from other `external` top-level members,
like those that can be written using `dart:ffi`.

### Interop type members

Given a JS interface like the following:

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

You can write an interop interface for it like so:

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
`external` interop members:

- **Constructors**. When called, constructors with only positional parameters
  create a new JS object whose constructor is defined by the name of the
  extension type using `new`.
  For example, calling `Time(0, 0)` in Dart generates a JS invocation that
  looks like `new Time(0, 0)`. Similarly, calling
  `Time.onlyHours(0)` generates a JS invocation that looks like `new Time(0)`.
  Note that the JS invocations of the two constructors follow the
  same semantics, regardless of whether they're
  given a Dart name or if they're a factory.

  - **Object literal constructors**. It's sometimes useful to
    create a JS [object literal][] that simply contains a
    number of properties and their values.
    In order to do this, declare a constructor with only named
    parameters, where the names of the parameters match the property names:

    ```dart
    extension type Options._(JSObject o) implements JSObject {
      external Options({int a, int b});
      external int get a;
      external int get b;
    }
    ```

    A call to `Options(a: 0, b: 1)` results in
    creating the JS object `{a: 0, b: 1}`.
    The object is defined by the invocation arguments, so
    calling `Options(a: 0)` results in `{a: 0}`.
    You can get or set the properties of the object through
    `external` instance members.

    :::warning
    Before Dart 3.3.1, object literal constructors required a
    [`@JS`](#js) annotation on the library to compile.
    To learn more, check out [`dart-lang/sdk#54801`][54801].
    :::

- **`static` members**. Like constructors, static members use
  the name of the extension type to generate the JS code. For example,
  calling `Time.getTimeDifference(t1, t2)` generates a JS invocation that
  looks like `Time.getTimeDifference(t1, t2)`.
  Similarly, calling `Time.dinnerTime` results in a JS invocation that
  looks like `Time.dinnerTime`. Like top-levels,
  you can declare `static` methods, getters, setters, and fields.

- **Instance members**. Like with other Dart types, instance members require
  an instance to be used. These members get, set, or invoke properties on
  the instance. For example:

  ```dart
    final time = Time(0, 0);
    print(time.isDinnerTime()); // false
    final dinnerTime = Time.dinnerTime;
    time.hours = dinnerTime.hours;
    time.minutes = dinnerTime.minutes;
    print(time.isDinnerTime()); // true
  ```

  The call to `dinnerTime.hours` gets the value of
  the `hours` property of `dinnerTime`.
  Similarly, the call to `time.minutes=` sets the value of
  the `minutes` property of time.
  The call to `time.isDinnerTime()` calls the function in
  the `isDinnerTime` property of `time` and returns the value.
  Like top-levels and `static` members, you can declare
  instance methods, getters, setters, and fields.

- **Operators**. There are only two `external` interop operators
  allowed in interop types: `[]` and `[]=`.
  These are instance members that
  match the semantics of JS' [property accessors][].
  For example, you can declare them like:

  ```dart
  extension type Array(JSArray<JSNumber> _) implements JSArray<JSNumber> {
    external JSNumber operator [](int index);
    external void operator []=(int index, JSNumber value);
  }
  ```

  Calling `array[i]` gets the value in the `i`th slot of `array`, and
  `array[i] = i.toJS` sets the value in that slot to `i.toJS`.
  Other JS operators are exposed by [utility functions][] in `dart:js_interop`.

Lastly, like any other extension type, you're allowed to declare any
[non-`external` members][] in the interop type.
A boolean getter `isMidnight` that uses the interop values is one such example.

[object literal]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Object_initializer
[54801]: {{site.repo.dart.sdk}}/issues/54801
[property accessors]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation
[utility functions]: {{site.dart-api}}/dart-js_interop/JSAnyOperatorExtension.html
[non-`external` members]: /language/extension-types#members

### Extension members on interop types

You can also write `external` members in [extensions][] of interop types.
For example:

```dart
extension on Array {
  external int push(JSAny? any);
}
```

The semantics of calling `push` are identical to what it would have been if
it was in the definition of `Array` instead.
Extensions can have `external` instance members and operators, but
can't have `external` `static` members or constructors.
Like with interop types, you can
write any non-`external` members in the extension.
These extensions are useful for when an interop type doesn't
expose the `external` member you need, and you don't want to
create a new interop type.

[extensions]: /language/extension-methods

### Parameters

`external` interop methods can only contain positional and optional arguments.
This is because JS members only take positional arguments.
The one exception is object literal constructors,
where they can contain only named arguments.

Unlike with non-`external` methods, optional arguments don't get
replaced with their default value, but are instead omitted.
For example:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Calling `array.push(0.toJS)` in Dart results in
a JS invocation of `array.push(0.toJS)` and *not* `array.push(0.toJS, null)`.
This allows users to not have to write multiple interop members for
the same JS API to avoid passing in `null`s.
If you declare a parameter with an explicit default value, you
get a warning that the value will be ignored.

## `@JS()`

It's sometimes useful to refer to a JS property with
a different name than the one written.
For example, if you want to write two `external` APIs that
point to the same JS property, you'd need to
write a different name for at least one of them.
Similarly, if you want to define multiple interop types that
refer to the same JS interface, you need to rename at least one of them.
Another example is if the JS name can't be written in Dart, such as `$a`.

To do this, you can use the [`@JS()`][] annotation with
a constant string value.
For example:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

Calling either `push` or `pushString` results in JS code that uses `push`.

You can also rename interop types:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate();

  external static int now();
}
```

Calling `JSDate()` results in a JS invocation of `new Date()`.
Similarly, calling `JSDate.now()` results in a JS invocation of `Date.now()`.

Furthermore, you can namespace an entire library,
adding a prefix to all interop top-level members, interop types,
and `static` interop members within those types.
This is useful if you want to avoid adding
too many members to the global JS scope.

```dart
@JS('library1')
library;

import 'dart:js_interop';

@JS()
external void method();

extension type JSType._(JSObject _) implements JSObject {
  external JSType();

  external static int get staticMember;
}
```

Calling `method()` results in a JS invocation of `library1.method()`,
calling `JSType()` results in a JS invocation of `new library1.JSType()`,
and calling `JSType.staticMember` results in
a JS invocation of `library1.JSType.staticMember`.

Unlike interop members and interop types, Dart only ever adds a library name in
the JS invocation if you provide a non-empty value in
the `@JS()` annotation on the library.
It doesn't use the Dart name of the library as the default.

```dart
library interop_library;

import 'dart:js_interop';

@JS()
external void method();
```

Calling `method()` results in a JS invocation of `method()` and not
`interop_library.method()`.

You can also write multiple namespaces delimited by a `.` for
libraries, top-level members, and interop types:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method();

@JS('library3.JSType')
extension type JSType._(JSObject _) implements JSObject {
  external JSType();
}
```

Calling `method()` results in
a JS invocation of `library1.library2.library3.method()`,
calling `JSType()` results in
a JS invocation of `new library1.library2.library3.JSType()`, and so forth.

However, you can't use `@JS()` annotations with `.` in
the value on interop type members or extension members of interop types.

If there's no value provided to `@JS()` or the value is empty,
no renaming occurs.

`@JS()` also tells the compiler that a member or type is
intended to be treated as a JS interop member or type.
It is required (with or without a value) for all top-level members to
distinguish them from other `external` top-level members, but
can often be elided on and within interop types and on extension members as
the compiler can tell it is a JS interop type from
the representation type and on-type.

[`@JS()`]: {{site.dart-api}}/dart-js_interop/JS-class.html

<a id="exporting-dart-functions-and-objects-to-js" aria-hidden="true"></a>
## Export Dart functions and objects to JS {:#export}

The preceding sections show how to call JS members from Dart.
It's also useful to *export* Dart code so that it can be used in JS.
To export a Dart function to JS, first convert it using [`Function.toJS`][],
which wraps the Dart function with a JS function.
Then, pass the wrapped function to JS through an interop member.
At that point, it's ready to be called by other JS code.

For example, this code converts a Dart function and uses interop to
set it in a global property, which is then called in JS:

```dart
import 'dart:js_interop';

@JS()
external set exportedFunction(JSFunction value);

void printString(JSString string) {
  print(string.toDart);
}

void main() {
  exportedFunction = printString.toJS;
}
```

```js
globalThis.exportedFunction('hello world');
```

Functions that are exported this way have type [restrictions][] similar to
those of interop members.

Sometimes it's useful to export an entire Dart interface so that
JS can interact with a Dart object.
To do this, mark the Dart class as exportable using [`@JSExport`][] and
wrap instances of that class using [`createJSInteropWrapper`][].
For a more detailed explanation of this technique, including how to
mock JS values, check out [How to mock JavaScript interop objects][].

[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[restrictions]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[`@JSExport`]: {{site.dart-api}}/dart-js_interop/JSExport-class.html
[`createJSInteropWrapper`]: {{site.dart-api}}/dart-js_interop/createJSInteropWrapper.html
[How to mock JavaScript interop objects]: /interop/js-interop/mock

## `dart:js_interop` and `dart:js_interop_unsafe`

[`dart:js_interop`][] contains all the necessary members you should need,
including `@JS`, JS types, conversion functions, and various utility functions.
Utility functions include:

- [`globalContext`][], which represents the global scope that
  the compilers use to find interop members and types.
- [Helpers to inspect the type of JS values][]
- JS operators
- [`dartify`][] and [`jsify`][], which check the type of certain JS values and
  convert them to Dart values and vice versa.
  Prefer using the specific conversion when you know the type of the JS value,
  as the extra type-checking might be expensive.
- [`importModule`][], which allows you to
  import modules dynamically as a `JSObject`.
- [`isA`][], which allows you to check if a JS-interop value is
  an instance of the JS type specified by the type argument.

More utilities might be added to this library in the future.

[`dart:js_interop_unsafe`][] contains members that allow
you to look up properties dynamically. For example:

```dart
JSFunction f = console['log'];
```

Instead of declaring an interop member named `log`,
a string can be used to access the property.
`dart:js_interop_unsafe` also provides functions to
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
[`isA`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/isA.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
