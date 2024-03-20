---
title: Migrate to package:web
description: How to migrate web interop code from dart:html to package:web.
---

Dart's [`package:web`][] exposes access to browser APIs,
enabling interop between Dart applications and the web.
Use `package:web` to interact with the browser and
manipulate objects and elements in the DOM.

```dart
import 'package:web/web.dart';

void main() {
  final div = document.querySelector('div')!;
  div.text = 'Text set at ${DateTime.now()}';
}
```

:::important
If you maintain a public Flutter package that uses `dart:html` or any of the
other Dart SDK web libraries,
**you should migrate to `package:web` as soon as possible**.
`package:web` is replacing `dart:html` and other web libraries
as Dart's web interop solution long-term.
Read the **`package:web` vs `dart:html`** section for more information.
:::

## `package:web` vs `dart:html`

The goal of `package:web` is to revamp how Dart exposes web APIs
by addressing several concerns with the existing Dart web libraries:

1. **Wasm compatibility**

   Packages can only be compatible with [Wasm][]
   if they use [`dart:js_interop`][] and [`dart:js_interop_unsafe`][].
   `package:web` is based on `dart:js_interop`,
   so by default, it's supported on `dart2wasm`.
   
   Dart core web libraries, like [`dart:html`][html] and [`dart:svg`][svg],
   are **not supported** when compiling to Wasm.

2. **Staying modern**
   
   `package:web` uses the [Web IDL][idl] to automatically generate
   [interop members][] and [interop types][]
   for each declaration in the IDL.
   Generating references directly,
   as opposed to the additional members and abstractions in `dart:html`,
   allows `package:web` to be more concise, easier to understand, more consistent,
   and more able to stay up-to-date with the future of Web developments.

3. **Versioning**

   Because it's a package, `package:web` can be versioned
   more easily than a library like `dart:html` and avoid breaking user code as it
   evolves.
   It also makes the code less exclusive and more open to contributions.
   Developers can create [alternative interop declarations][] of their own
   and use them together with `package:web` without conflict.

---

These improvements naturally result in some
implementation differences between `package:web` and `dart:html`.
The changes that affect existing packages the most,
like IDL [renames](#renames) and
[type tests](#type-tests),
are addressed in the migration sections that follow. While we only refer to
`dart:html` for brevity, the same migration patterns apply to any other Dart
core web library like `dart:svg`.

## Migrating from `dart:html`

Remove the `dart:html` import and replace it with `package:web/web.dart`:

```dart
import 'dart:html' as html; // Remove
import 'package:web/web.dart' as web; // Add
```

Add `web` to the `dependencies` in your pubspec:

```yaml
dependencies:
  web: ^0.5.0
```

The following sections cover some of the common migration issues
from `dart:html` to `package:web`.

For any other migration issues, check the [dart-lang/web][] repo and file an
issue.

### Renames

Many of the symbols in `dart:html` were renamed from
their original IDL declaration to align more with Dart style.
For example, `appendChild` became `append`,
`HTMLElement` became `HtmlElement`, etc.

In contrast, to reduce confusion,
`package:web` uses the original names from the IDL definitions.
A `dart fix` is available to convert types that have been renamed
between `dart:html` and `package:web`.

After changing the import, any renamed objects will be new "undefined" errors.
You can address these either:
- From the CLI, by running `dart fix --dry-run`.
- In your IDE, by selecting the `dart fix`: **Rename to '`package:web name`'**.

{% comment %}
Maybe a pic here of menu selection in IDE?
TODO: Update this documentation to refer to symbols instead of just types once
we have a dart fix for that.
{% endcomment -%}

The `dart fix` covers many of the common type renames.
If you come across a `dart:html` type without a built-in fix, let us know by
filing an [issue][].
You can manually discover the `package:web` type name
by looking up the `dart:html` class' `@Native` annotation.
You can do this by either:

- Ctrl or cmd clicking the name in the IDE and choosing **Go to Definition**.
- Searching for the name in the [`dart:html` API docs][html]
  and checking its page under *Annotations*.

The `@Native` annotation tells the compiler to treat any JS object of that type
as the class that it annotates.

Similarly, if you find an API with the keyword `native` in `dart:html` that
doesn't have an equivalent in `package:web`, check to see if there was a rename
with the `@JSName` annotation.
`native` is an internal keyword that means the same as `external` in this
context.

### Type tests

It's common for code that uses `dart:html` to utilize runtime checks like `is`.
When used with a `dart:html` object, `is` and `as` verify that the object is
the JS type within the `@Native` annotation.
In contrast, all `package:web` types are reified to [`JSObject`][]. This means a
runtime type test will result in different behavior between `dart:html` and
`package:web` types.

To be able to perform type tests, migrate any `dart:html` code
using `is` type tests to use [interop methods][] like `instanceOfString`
or the more convenient and typed [`isA`][] helper
(available from Dart 3.4 onward).
The [Compatibility, type checks, and casts][]
section of the JS types page covers alternatives in detail.

```dart
obj is Window; // Remove
obj.instanceOfString('Window'); // Add
```

### Type signatures

Many APIs in `dart:html` support various Dart types in their type signatures.
Because `dart:js_interop` [restricts] the types that can be written, some of
the members in `package:web` will now require you to *convert* the value before
calling the member.
Learn how to use interop conversion methods from the [Conversions][]
section of the JS types page.

```dart
window.addEventListener('click', callback); // Remove
window.addEventListener('click', callback.toJS); // Add
```

{% comment %}
TODO: Think of a better example. People will likely use the stream helpers
instead of `addEventListener`.
{% endcomment -%}

Generally, you can spot which methods need a conversion because they'll be
flagged with some variation of the exception:

```plaintext
A value of type '...' can't be assigned to a variable of type 'JSFunction?'
```

### Conditional imports

It is common for code to use a conditional import based on whether `dart:html`
is supported to differentiate between native and web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

However, since `dart:html` is not supported when compiling to Wasm, the correct
alternative now is to use `dart.library.js_interop` to differentiate between
native and web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.js_interop) 'src/hw_web.dart';
```

### Virtual dispatch and mocking

`dart:html` classes supported virtual dispatch, but because JS interop uses
extension types, virtual dispatch is [not possible]. Similarly, `dynamic` calls
with `package:web` types won't work as expected (or, they might continue to work
just by chance, but will stop when `dart:html` is removed), as their members are
only available statically. Migrate all code that relies on virtual dispatch to
avoid this issue.

One use case of virtual dispatch is mocking. If you have a mocking class that
`implements` a `dart:html` class, it can't be used to implement a `package:web`
type. Instead, prefer mocking the JS object itself. See the [mocking tutorial]
for more information.

### Non-`native` APIs

`dart:html` classes may also contain APIs that have a non-trivial
implementation. These members may or may not exist in the `package:web`
[helpers](#helpers). If your code relies on the specifics of that
implementation, you may be able to copy the necessary code.
However, if you think that's not tractable or if that code would be beneficial
for other users as well, consider filing an issue or uploading a pull request to
[`package:web`][dart-lang/web] to support that member.

### Zones

In `dart:html`, callbacks are automatically zoned.
This is not the case in `package:web`. There is no automatic binding of
callbacks in the current zone.

If this matters for your application, you can still use zones, but you will have
to [write them yourself][zones] by binding the callback. See [#54507] for more
details.
There is no conversion API or [helper](#helpers) available yet to
automatically do this.

## Helpers

The core of `package:web` contains `external` interop members,
but does not provide other functionality that `dart:html` provided by default.
To mitigate these differences, `package:web` contains [`helpers`][helpers]
for additional support in handling a number of use cases
that aren't directly available through the core interop.
The helper library contains various members to expose some legacy features from
the Dart web libraries.

For example, the core `package:web` only has support for adding and removing
event listeners. Instead, you can use [stream helpers][] that makes it easy to
subscribe to events with Dart `Stream`s without writing that code yourself.

```dart
// dart:html version
InputElement htmlInput = InputElement();
await htmlInput.onBlur.first;

// package:web version
HTMLInputElement webInput = document.createElement('input') as HTMLInputElement;
await webInput.onBlur.first;
```

You can find all the helpers and their documentation in the repo at
[`package:web/helpers`][helpers]. They will continuously be updated to aid users
in migration and make it easier to use the web APIs.

## Examples

Here are some examples of packages that have been migrated from `dart:html`
to `package:web`:

- [Upgrading `url_launcher` to `package:web`][]

{% comment %}
Do we have any other package migrations to show off here?
{% endcomment -%}

[`package:web`]: {{site.pub-pkg}}/web
[Wasm]: https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/README.md
[html]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-html/dart-html-library.html
[svg]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-svg/dart-svg-library.html
[`dart:js_interop`]: https://api.dart.dev/dev/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: https://api.dart.dev/dev/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[idl]: https://www.npmjs.com/package/@webref/idl
[interop members]: /interop/js-interop/usage#interop-members
[interop types]: /interop/js-interop/usage#interop-types
[dart-lang/web]: https://github.com/dart-lang/web
[issue]: https://github.com/dart-lang/web/issues/new
[helpers]: https://github.com/dart-lang/web/tree/main/lib/src/helpers
[zones]: /articles/archive/zones
[Conversions]: /interop/js-interop/js-types#conversions
[interop methods]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension.html#instance-methods
[alternative interop declarations]: /interop/js-interop/usage
[Compatibility, type checks, and casts]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[Upgrading `url_launcher` to `package:web`]: https://github.com/flutter/packages/pull/5451/files
[stream helpers]: https://github.com/dart-lang/web/blob/main/lib/src/helpers/events/streams.dart
[not possible]: /language/extension-types
[`JSObject`]: https://api.dart.dev/dev/dart-js_interop/JSObject-extension-type.html
[`isA`]: https://api.dart.dev/dev/dart-js_interop/JSAnyUtilityExtension/isA.html
[restricts]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[#54507]: https://github.com/dart-lang/sdk/issues/54507
[mocking tutorial]: /interop/js-interop/mock
