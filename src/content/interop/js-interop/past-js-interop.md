---
title: Past JS interop
breadcrumb: Legacy
description: Archive of Dart's previous JS interop support.
prevpage:
  url: /interop/js-interop/tutorials
  title: JS interop tutorials
nextpage:
  url: /interop/js-interop/package-web/
  title: Migrate to package:web
---

## The evolution of JavaScript interop {: #next-generation-js-interop }

[Dart 3.3][] introduces a new generation of JS interop that offers
a unified set of features and APIs to access JavaScript and browser
functionalities within your Dart code. This modern approach enhances the
developer experience and enables WebAssembly ([Wasm][]) support, aligning
Dart with the future of the web.

The following table maps Dart's new JS and web interop solutions to
their past counterparts:

| New interop libraries        | Legacy libraries                       |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}


Previous iterations of JS interop for Dart are considered legacy and
are deprecated as of Dart 3.7 (Feb 2025).
Prefer using [`dart:js_interop`][] going forwards and
migrate usages of old interop libraries when possible.
Support for browser APIs, such as [`dart:html`][],
is now provided by [`package:web`][].


:::warning
None of the legacy interop libraries are supported when compiling to [Wasm][].
:::

### Disallow deprecated JS interop libraries {:#disallow-deprecated-js-interop}

:::version-note
The `--[no-]deprecated-js-interop` compiler flag was introduced in Dart 3.14.
:::

To verify that your app and its dependencies don't import legacy web libraries
when compiling to JavaScript,
pass `--no-deprecated-js-interop` to [`dart compile js`][] (`dart2js`)
or `dart compile js-dev` (`dartdevc`):

```console
$ dart compile js --no-deprecated-js-interop -o out/main.js web/main.dart
```

If you build with [`webdev`][] (4.1.0 or later with [`build_web_compilers`][]
4.9.0 or later), you can also pass `--no-deprecated-js-interop` to
`webdev serve` and `webdev build`, or set `deprecated-js-interop: false`
in `build.yaml`.

Passing `--no-deprecated-js-interop` enforces the following behavior:

- **Disallows legacy web imports.**
  Importing any of the deprecated `dart:*` web libraries
  (`dart:html`, `dart:indexed_db`, `dart:js`,
  `dart:js_util`, `dart:svg`, `dart:web_audio`, and `dart:web_gl`)—or
  packages that import them, such as `package:js`—results in a
  compile-time error.
  (`dart compile wasm` always disallows these libraries and doesn't accept
  `--[no-]deprecated-js-interop`.)
- **Evaluates legacy conditional imports to `false`.**
  The environment conditions `dart.library.html`,
  `dart.library.indexed_db`, `dart.library.js`, `dart.library.js_util`,
  `dart.library.svg`, `dart.library.web_audio`, and `dart.library.web_gl`
  evaluate to `false` in [conditional imports][]
  (such as `if (dart.library.html)`) and [`bool.fromEnvironment`][].
- **Reports shortest-path import chains.**
  When a disallowed library is imported,
  the compiler prints a deduplicated shortest-path import tree
  that pinpoints which library or package introduced the deprecated import:

  ```plaintext
  Deprecated JS interop libraries are imported through:
    main library
    ├── package:foo
    │   └── dart:html
    └── web/src/app.dart
        ├── package:foo (see above)
        └── package:bar
            └── dart:js_util
  ```

By default, deprecated JS interop libraries are still allowed
(`--deprecated-js-interop` is enabled).
Pass `--no-deprecated-js-interop` in your continuous integration (CI) pipeline
to catch legacy web dependencies early and prepare your code for the removal
of the deprecated `dart:*` web libraries from the Dart SDK.

In addition, to catch invalid runtime type checks on JS interop types
at analysis time, use the [`invalid_runtime_check_with_js_interop_types`][]
lint rule, which is included in `package:lints/core.yaml`
starting in [`package:lints`][] 7.0.0.

[Dart 3.3]: /blog/new-in-dart-3-3-extension-types-javascript-interop-and-more
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/
[`dart:svg`]: {{site.dart-api}}/dart-svg/
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/
[Wasm]: /web/wasm
[`dart compile js`]: /tools/dart-compile#js
[`webdev`]: /tools/webdev
[`build_web_compilers`]: {{site.pub-pkg}}/build_web_compilers
[conditional imports]: /interop/js-interop/package-web#conditional-imports
[`bool.fromEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types
[`package:lints`]: {{site.pub-pkg}}/lints

## `dart:js`

[`dart:js`][] exposed a concrete [`object wrapper`][] to interop with JS objects.
This wrapper contained String-based methods to dynamically get, set, and call
properties on the wrapped JS object. It was less performant due to wrapping
costs and ergonomically more difficult to use. For example, you did not get
code-completion as you couldn't declare interop members and instead relied on
Strings. Many of the functionalities exposed in `dart:js` like
[`allowInterop`][] were later re-exposed through other interop libraries.

This library has been legacy since
`package:js` and `dart:js_util` were released.

[`object wrapper`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html

## `package:js`

[`package:js`][] introduced functionality to declare interop types and members.
It allowed users to write interop classes instead of interop extension types.
At runtime, these classes were erased to a type that is similar to
`dart:js_interop`'s [`JSObject`].

```dart
@JS()
class JSType {}
```

Users of `package:js` will find the
syntax and semantics of `dart:js_interop` familiar.
You might be able to migrate to `dart:js_interop` by
replacing the class definition with an extension type and
have it work in many cases.

There are significant differences, however:

- `package:js` types could not be used to interop with browser APIs.
  `dart:js_interop` types can.
- `package:js` allowed dynamic dispatch. This meant that if you cast the
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
- [`@anonymous`][] types were a way to declare an interop type with an object
  literal constructor. `dart:js_interop` doesn't distinguish types this way and
  any `external` named-argument constructor is an object literal constructor.

[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[tutorial on mocking]: /interop/js-interop/mock

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

[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48

## `dart:js_util`

[`dart:js_util`] supplied a number of utility functions that could not be
declared in an `package:js` type or were necessary for values to be passed back
and forth. This included members like:

- `allowInterop` (which is now [`Function.toJS`][])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (which are now in
  [`dart:js_interop_unsafe`])
- Various JS operators
- Type-checking helpers
- Mocking support
- And more.

`dart:js_interop` and `dart:js_interop_unsafe` contain these helpers now with
possibly alternate syntax.

[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html

[`dart:js`]: {{site.dart-api}}/dart-js/
[`package:js`]: {{site.pub-pkg}}/js
