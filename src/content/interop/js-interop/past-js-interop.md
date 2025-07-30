---
title: Past JS interop
description: Archive of Dart's previous JS interop support.
prevpage:
  url: /interop/js-interop/tutorials
  title: JS interop tutorials
nextpage:
  url: /interop/js-interop/package-web/
  title: Migrate to package:web
---

:::warning
None of these legacy interop libraries are supported when compiling to [Wasm][].
:::

This page addresses previous iterations of JS interop for Dart that
have been considered legacy and are deprecated as of Dart 3.7.
Therefore, prefer using [`dart:js_interop`][] going forwards and
migrate usages of old interop libraries when possible.
While [`dart:html`][] and other web libraries are closely related,
they're covered in the [`package:web`][] page.

[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:html`]: {{site.dart-api}}/dart-html/dart-html-library.html
[`package:web`]: /interop/js-interop/package-web

## `dart:js`

[`dart:js`] exposed a concrete [`object wrapper`] to interop with JS objects.
This wrapper contained String-based methods to dynamically get, set, and call
properties on the wrapped JS object. It was less performant due to wrapping
costs and ergonomically more difficult to use. For example, you did not get
code-completion as you couldn't declare interop members and instead relied on
Strings. Many of the functionalities exposed in `dart:js` like [`allowInterop`]
were later re-exposed through other interop libraries.

This library has been legacy since
`package:js` and `dart:js_util` were released.

## `package:js`

[`package:js`] introduced functionality to declare interop types and members.
It allowed users to write interop classes instead of interop extension types. At
runtime, these classes were erased to a type that is similar to
`dart:js_interop`'s [`JSObject`].

```dart
@JS()
class JSType {}
```

Users of `package:js` will find the syntax and semantics of `dart:js_interop`
familiar. You may be able to migrate to `dart:js_interop` by replacing the class
definition with an extension type and have it work in many cases.

There are significant differences, however:

- `package:js` types could not be used to interop with browser APIs.
  `dart:js_interop` types can.
- `package:js` allowed dynamic dispatch. This meant that if you casted the
  `package:js` type to `dynamic` and called an interop member on it, it would
  forward to the right member. This is no longer possible with
  `dart:js_interop`.
- `package:js`' `@JS` has no soundness guarantees as return types of
  `external` members were not checked. `dart:js_interop` is sound.
- `package:js` types could not rename instance members or have non-`external`
  members.
- `package:js` types could subtype and be a supertype of non-interop classes.
  This was often used for mocks. With `dart:js_interop`, mocking is done by
  substituting the JS object instead. See the [tutorial on mocking].
- [`@anonymous`] types were a way to declare an interop type with an object
  literal constructor. `dart:js_interop` doesn't distinguish types this way and
  any `external` named-argument constructor is an object literal constructor.

### `@staticInterop`

Along with `@JS` and `@anonymous`, `package:js` later exposed
[`@staticInterop`], which was a prototype of interop extension types. It is as
expressive and restrictive as `dart:js_interop` and was meant to be a
transitory syntax until extension types were available.

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
declared in an `package:js` type or were necessary for values to be passed back
and forth. This included members like:

- `allowInterop` (which is now [`Function.toJS`])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (which are now in
  [`dart:js_interop_unsafe`])
- Various JS operators
- Type-checking helpers
- Mocking support
- And more.

`dart:js_interop` and `dart:js_interop_unsafe` contain these helpers now with
possibly alternate syntax.


[`dart:js`]: {{site.dart-api}}/dart-js/dart-js-library.html
[`object wrapper`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html
[`package:js`]: {{site.pub-pkg}}/js
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[tutorial on mocking]: /interop/js-interop/mock
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[Wasm]: /web/wasm
