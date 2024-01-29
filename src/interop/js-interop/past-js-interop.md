---
title: Past JS interop
description: Archive of past JS interop implementations.
---

This page addresses previous iterations of JS interop for Dart that are
considered legacy. They are not necessarily deprecated, but might be in the
future. Therefore, prefer using [`dart:js_interop`] going forwards and migrate
usages of old interop libraries when possible. While [`dart:html`] and other web
libraries are closely related, they're covered in the [`package:web`] page.

{{site.alert.warn}}
None of these legacy interop libraries are supported when compiling to Wasm.
{{site.alert.end}}

## `dart:js` 

[`dart:js`] exposed a concrete [`class wrapper`] to interop with JS objects.
This wrapper contained methods to dynamically get, set, and call properties on
the wrapped JS object. It was less performant to use due to the use of a class
wrapper and ergonomically more difficult to use as you couldn't declare interop
members. Many of the functionalities exposed in `dart:js` like [`allowInterop`]
were later re-exposed through other interop libraries.

This library has been legacy ever since `package:js` and `dart:js_util` were
released. It is likely the first to be deprecated.

## `package:js`

[`package:js`] introduced functionality to declare interop types and members.
It allowed users to write interop classes instead of interop extension types. At
runtime, these classes were erased to a type that is similar to
`dart:js_interop`'s [`JSObject`].

```dart
@JS()
class JSType {}
```

Users who have used this package will find the syntax and semantics of
`dart:js_interop` familiar. You may be able to migrate to `dart:js_interop` by
replacing the class definition with an extension type and have it work in many
cases.

There are significant differences, however:

- `package:js` types could not be used to interop with browser APIs.
- `package:js` allowed dynamic dispatch. This meant that if you casted the
  `package:js` type to `dynamic` and called an interop member on it, it would
  forward to the right member. This is no longer possible with
  `dart:js_interop`.
- `package:js`' [`@JS`] has different soundness guarantees. `external` members
  would not have their return types checked. This is also why there's a
  [separate `@JS`] annotation in `dart:js_interop` that users should use
  instead.
- `package:js` types could not rename instance members or have non-`external`
  members.
- `package:js` types could subtype and be a supertype of non-interop classes.
  This was often used for mocks.
- [`@anonymous`] types were a way to declare an interop type with an object
  literal constructor. `dart:js_interop` does not use this annotation and treats
  all `external` named-argument constructors as object literal constructors.

### `@staticInterop`

Along with `@JS` and `@anonymous`, `package:js` later exposed
[`@staticInterop`], which was a prototype of interop extension types.

`@staticInterop` types were implicitly erased to `JSObject`. It required users
to declare all instance members in extensions so that only static semantics
could be used, and had stronger soundness guarantees. Users could use it to
interact with browser APIs, and it also allowed things like renaming and
non-`external` members. Like interop extension types, it didn't have support for
dynamic dispatch.

`@staticInterop` classes can almost always be migrated to an interop extension
type by just changing the class to an extension type and removing the
annotations.

`dart:js_interop` exposed `@staticInterop` (and `@anonymous`, but only if
`@staticInterop` is also used) to support static interop semantics until
extension types were added to the language. All such types should now be
migrated to extension types.

## `dart:js_util`

[`dart:js_util`] supplied a number of utility functions that could not be
declared in an interop type or were necessary for values to be passed back and
forth. This included members like:

- `allowInterop` (which is now [`Function.toJS`])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (which are now in
  [`dart:js_interop_unsafe`])
- Various JS operators
- Type-checking helpers
- Mocking support

and more. `dart:js_interop` and `dart:js_interop_unsafe` contain these helpers
now with possibly alternate syntax.

{% comment %}
TODO: add links (with stable) when ready:
TODO: Link to `package:web` section
{% endcomment %}

[`dart:js_interop`]: https://api.dart.dev/dev/dart-js_interop
[`dart:html`]: https://api.dart.dev/dev/dart-html
[`package:web`]: /
[`dart:js`]: https://api.dart.dev/dev/dart-js
[`class wrapper`]: https://api.dart.dev/dev/dart-js/JsObject-class.html
[`allowInterop`]: https://api.dart.dev/dev/dart-js_util/allowInterop.html
[`package:js`]: https://pub.dev/packages/js
[`JSObject`]: https://api.dart.dev/dev/dart-js_interop/JSObject-extension-type.html
[`@JS`]: https://github.com/dart-lang/sdk/blob/main/sdk/lib/js/_js_annotations.dart#L11
[separate `@JS`]: https://api.dart.dev/dev/dart-js_interop/JS-class.html
[`@anonymous`]: https://github.com/dart-lang/sdk/blob/main/sdk/lib/js/_js_annotations.dart#L40
[`@staticInterop`]: https://github.com/dart-lang/sdk/blob/main/sdk/lib/js/_js_annotations.dart#L48
[`dart:js_util`]: https://api.dart.dev/dev/dart-js_util
[`Function.toJS`]: https://api.dart.dev/dev/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: https://api.dart.dev/dev/dart-js_interop_unsafe
