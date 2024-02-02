---
title: Usage
description: How to declare and use JS interop members.
---

JS interop works by looking up properties in the [global JS scope]. In order to
interact with these properties, you use [`external`] interop members. In order
to provide types for these properties, you use interop types.

## Interop types

When interacting with a JS value, you need to provide a Dart type for it. In
order to do this, you either use or declare an interop type. Dart provides a set
of core interop types called ["JS types"] that you can use to add types to your
interop members. You can also declare an interop type using [extension types] by
making its representation type another interop type. "JS types" refer to the
interop types provided by Dart, and while all JS types are interop types, not
all interop types are JS types. For example:

```dart
extension type Console(JSObject _) implements JSObject {}
```

Both `Console` and `JSObject` are interop types, but only `JSObject` is a JS
type.

You can also use `Console` as a representation type of an interop type as it is
an interop type:

```dart
extension type Console2(Console _) implements Console {}
```

Because you're using extension types, both `Console` and `Console2` are still
`JSObject`s. You're just providing a Dart interface to view the `JSObject`
differently. There is no guarantee that they are a specific type of JS object.

Generally, you will likely use `JSObject` as the representation type for interop
types you declare because you're likely interacting with JS objects who don't
have a corresponding JS type like [`Window`].

Interop types should also generally implement their representation type so that
they can be subtypes of the representation type.

## Interop members

In order to get a JS value that you can provide a type for, you'll want to use
an `external` interop member. These members might take in arguments and return a
type. The types that can be used on these members have [restrictions]. There are
various ways you can declare interop members.

### Top-level interop members

```dart
@JS()
external Console get console;

@JS()
external set name(String value);

@JS()
external void close();
```

Here, `console`, `name`, and `close` are top-level interop members. When
`console` is called, the value in the `console` property in the global namespace
is retrieved and casted to `Console`. When `name` is set, the property `name` in
the global namespace is set to the given value. When `close` is called, the
function `close` in the global namespace is called with no arguments. You can
declare top-level interop getters, setters, methods, and fields, which are just
pairs of getters and setters.

### Interop type members

```dart
extension type Array._(JSObject _) implements JSObject {
  external Array();
  external factory Array.withLength(int length);

  external static bool isArray(JSObject o);

  external int length;
  external JSAny? at(int index);

  external operator [](int index);
  external operator []=(int index, JSAny? any);

  bool get isZeroLength => length == 0;
}
```

Here we are using `Array` to interop with JS' [`Array`] type.

Within an interop type, you can declare several different types of `external`
interop members:

- Constructors. When called, these members construct a new JS object whose
  constructor is defined by the name of the extension type using `new`. For
  example, calling `Array()` in Dart will generate a JS invocation that looks
  like `new Array()`. Similarly, calling `Array.withLength(10)` will generate a
  JS invocation that looks like `new Array(10)`. Note that the JS invocations of
  all `external` interop constructors follow the same semantics, regardless of
  whether they're given a name in Dart or if they are a factory.

- `static` members. Like constructors, these members use the name of the
  extension type to generate the JS code. For example, calling `Array.isArray()`
  will generate a JS invocation that looks like `Array.isArray()`. Like
  top-levels, you can declare `static` methods, getters, setters, and fields.

- Instance members. Like with other Dart types, these members require an
  instance in order to be used. These members get, set, or invoke properties on
  the instance. For example:

  ```dart
    final array = Array();
    array.length = 10;
    final length = array.length;
    for (final i = 0; i <= 10; i++) {
      array[i] = i.toJS;
      assert(array[i] == array.at(i));
    }
  ```

  The call to `array.length` gets the value of the `length` property of `array`.
  The call to `array.length = 10` sets the value of the `length` property. The
  call to `array.at(i)` calls the function in the `at` property of `array` with
  the given arguments and returns the value of that call. Like top-levels and
  `static` members, you can declare instance methods, getters, setters, and
  fields.

- Operators. There are only two `external` interop operators allowed in interop
  types: `[]` and `[]=`. These are instance members that match the semantics of
  JS' [property accessors]. In the above example, `array[i]` gets the value in
  the `i`th slot of `array`, and `array[i]` sets the value in that slot to
  `i.toJS`. We expose other JS operators through [utility functions] in
  `dart:js_interop`.

In the [JS types] section, you'll see that there exists a predefined JS type for
`Array` called `JSArray`. Here, we're writing another interop type for the same
JS type and just *viewing* it differently, so there is no conflict. If we
wanted, we could have made the representation type `JSArray`:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {}
```

Lastly, like any other extension type, you're allowed to declare any
non-`external` members in the interop type. `isZeroLength` is one such example.

#### Object literal constructors

It is useful sometimes to create a JS [object literal] that simply contains a
a number of properties and their values. In order to do this, we allow you to
use a constructor with only named arguments:

```dart
import ‘dart:js_interop’;

extension type Options._(JSObject o) {
  external Options({int a, int b});
  external int get a;
  external int get b;
}
```

A call to `Options(a: 0, b: 1)` will result in a JS invocation of
`{a: 0, b: 1}`. You can get or set these values through `external` instance
members.

### Extension members on interop types

You can also write `external` members in extensions of interop types. For
example:

```dart
extension on Array {
  external int push(JSAny? any);
}
```

The semantics of calling `push` are identical to what it would have been if it
was in the definition of `Array` instead. The only `external` members you can
write in such an extension are instance members and the allowed operators. Like
with interop types, you can write any non-`external` members in the extension.
These extensions are useful for when an interop type doesn't expose the
`external` member you need and you don't want to create a new interop type.

### Parameters

`external` interop methods can only contain positional and optional arguments.
The one exception is object literal constructors, where they can contain *only*
named arguments.

Unlike with non-`external` methods, optional arguments do not get replaced with
their default value, but are instead omitted. For example:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Calling `array.push(0.toJS)` in Dart will result in a JS invocation of
`array.push(0.toJS)` and *not* `array.push(0.toJS, null)`. If you declare a
parameter with an explicit default value, you will get a warning that the value
will be ignored.

## `@JS()`

It is sometimes useful to refer to a JS property with a different name than the
one written. For example, if you want to write two `external` APIs that point to
the same JS property, you’d need to write a different name for at least one of
them. In order to do this, you can use the [`@JS()`] annotation with a constant
string value. For example:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

Calling either `push` or `pushString` will result in JS code that uses `push`.

You can also rename interop types:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate();

  external static int now();
}
```

Calling `JSDate()` will result in a JS invocation of `new Date()`. Similarly,
calling `JSDate.now()` will result in a JS invocation of `Date.now()`.

Furthermore, you can namespace an entire library, which will add a prefix to all
interop top-level members, interop types, and `static` interop members within
those types:

```dart
@JS('library1')
library;

import 'dart:js_interop';

@JS()
external void method();

extension type JSType(JSObject _) implements JSObject {
  external JSType();

  external static int get staticMember;
}
```

Calling `method()` will result in a JS invocation of `library1.method()`,
calling `JSType()` will result in a JS invocation of `new library1.JSType()`,
and calling `JSType.staticMember` will result in a JS invocation of
`library1.JSType.staticMember`.

Unlike interop members and interop types, we only ever add a library name in the
JS invocation if you provide a non-empty value in the `@JS()` annotation on the
library.

```dart
library interop_library;

import 'dart:js_interop';

@JS()
external void method();
```

Calling `method()` will result in a JS invocation of `method()` and *not*
`interop_library.method()`.

You can also write multiple namespaces delimited by a '.' for libraries,
top-level members, and interop types:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method();

@JS('library3.JSType')
extension type JSType(JSObject _) implements JSObject {
  external JSType();
}
```

Calling `method()` will result in a JS invocation of
`library1.library2.library3.method()`, calling `JSType()` will result in a JS
invocation of `new library1.library2.library3.JSType()`, and so forth.

You can't use `@JS()` annotations with '.' in the value on interop type members
or extension members of interop types, however.

If there is no value provided to `@JS()` or the value is empty, no renaming will
occur.

`@JS()` also tells the compiler that a member or type is intended to be treated
as a JS interop member or type. It is required (with or without a value) for all
top-level members to distinguish them from other `external` top-level members,
but can often be elided on and within interop types and on extension members as
the compiler can tell from the representation type and on-type.

## `dart:js_interop` and `dart:js_interop_unsafe`

[`dart:js_interop`] contains all the necessary members you should need,
including `@JS`, JS types, conversion functions, and various utility functions.
Utility functions include:

- [`globalContext`], which represents the global namespace that the compilers
  use to generate JS invocations.
- [Helpers to type-check JS values]
- JS operators
- [`dartify`] and [`jsify`], which type-check and auto-convert certain JS values
  to Dart values and vice versa.

and more. More utilities might be added to this library in the future.

[`dart:js_interop_unsafe`] contains members that allow you to look up properties
dynamically. For example:

```dart
JSFunction f = console['log'];
```

Instead of declaring an interop member named `log`, we're instead using a string
to represent the property. `dart:js_interop_unsafe` provides functionality to
dynamically get, set, and call properties.

{{site.alert.warn}}
Avoid using `dart:js_interop_unsafe` if possible. It makes security compliance
more difficult to guarantee and may lead to violations.
{{site.alert.end}}

{% comment %}
TODO: add links (with stable) when ready:
TODO: How do you link to a subsection of another section?
{% endcomment %}

[global JS scope]: https://developer.mozilla.org/en-US/docs/Glossary/Global_scope
[`external`]: https://dart.dev/language/keywords
["JS types"]: /interop/js-interop/js-types
[extension types]: /
[`Window`]: https://developer.mozilla.org/en-US/docs/Web/API/Window
[restrictions]: /interop/js-interop/js-types.md#restrictions
[`Date`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
[property accessors]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_accessors#bracket_notation
[utility functions]: https://api.dart.dev/dev/dart-js_interop/JSAnyOperatorExtension.html
[JS types]: /interop/js-interop/js-types
[`JSArray`]: https://api.dart.dev/dev/dart-js_interop/JSArray-extension-type.html
[object literal]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Object_initializer
[`@JS()`]: https://api.dart.dev/dev/dart-js_interop/JS-class.html
[`dart:js_interop`]: https://api.dart.dev/dev/dart-js_interop
[`globalContext`]: https://api.dart.dev/dev/dart-js_interop/globalContext.html
[Helpers to type-check JS values]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension.html
[`dartify`]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension/dartify.html
[`jsify`]: https://api.dart.dev/dev/dart-js_interop/NullableObjectUtilExtension.html
[`dart:js_interop_unsafe`]: https://api.dart.dev/dev/dart-js_interop_unsafe

