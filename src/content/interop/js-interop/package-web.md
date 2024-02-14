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
If you maintain a public Flutter package that uses `dart:html`,
**you should migrate to `package:web` as soon as possible**.
`package:web` is replacing `dart:html` and other web libraries
as Dart's web interop solution.
Read [`package:web` vs `dart:html`](#packageweb-vs-darthtml)
for more information.
:::

## `package:web` vs `dart:html`

The goal of `package:web` is revamping Dart's bindings API
by addressing several concerns with the previous solution,
namely, `dart:html`.

1. **Wasm compatibility.**

Packages will only be compatible with [Wasm][]
if they use [`dart:js_interop`][] and [`dart:js_interop_unsafe`][].
`package:web` is built around the new JS interop libraries
specifically for this reason.
It's methods are statically dispatched,
so by default supported on `dart2wasm`.

Web libraries that were previously the default for Dart Web interop,
like [`dart:html`][html] and [`dart:svg`][svg],
are **not supported** when comiling to Wasm.

2. **Web compatibility.**

`package:web` uses the [Web IDL][idl] to automatically generate
[interop members][js] and [interop extension types][static]
for each declaration in the IDL.
Generating references directly,
as opposed to the light abstractions in `dart:html`,
makes `package:web` leaner, easier to maintain, more consistent,
and more able to stay up-to-date with the future of Web developments.

3. **Delivered as a package.**

Delivering bindings as a package means `package:web` can be versioned
more easily than a library like `dart:html`.
This makes it a lower entry for contributions,
and less exclusive. Developers can customize it
or [create alternative bindings][] of their own
and use them together with `package:web` without conflict. 

---

These improvements naturally result in some
implementation differences between `package:web` and `dart:html`.
The changes that affect existing packages the most,
like [renaming](#renames) members to match IDL references, or
[converting](#type-checks) dynamic expressions
to be static-dispatch friendly,
are addressed in the migration sections that follow. 

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

The following sections cover the current available methods of migration
from `dart:html` to `package:web`.

For any other migration issues, check the [dart-lang/web][] repo and file an issue.

### Renames

Many of the symbols in `dart:html` were renamed from
their original IDL declaration to align more with Dart style.
For example, `appendChild` became `append`,
`HTMLElement` became `HtmlElement`, etc.

In contrast, to be as lean and maintainable as possible,
`package:web` is fully aligned with the IDL declaration
and keeps all the original names.
A `dart fix` is available to convert symbols that have been renamed
between `dart:html` and `package:web`. 

After changing the import, any renamed objects will be new "undefined" errors.
You can address these either:
- From the CLI by running `dart fix --dry-run`.
- In your IDE, select the `dart fix`: **Rename to '`package:web name`'**.

{% comment %}
Maybe a pic here of menu selection in IDE?
{% endcomment -%}

The `dart fix` should cover the majority of renames.
If you come across a `dart:html` symbol without a built-in fix,
first let us know by filing an [issue][].
Then, you can manually discover the `package:web` name
by looking up its `@Native` annotation.
You can do this by either:

- Ctrl or cmd clicking the name in the IDE and choosing **Go to Definition**.
- Searching for the name in the [`dart:html` API docs][html] 
  and checking its page under *Annotations*.

### Type checks

It's common for `dart:html` code to utilize runtime `is` checks
to confirm whether an object actually maps to its JS type.
In constrast, the types that represent browser bindings in `package:web`
are not reified. This means a runtime `is` check can't confirm the interop type,
only that the underlying type is JS `Object`.

To be able to perform type checks, migrate any `dart:html` code
using `is` type tests to use [interop methods][] like `instanceOf`.
The [Compatibility, type checks, and casts][]
section of the JS types page covers static interop alternatives to `is`
in detail.

```dart
obj is Window; // Remove
obj.instanceOf('Window'); // Add
```

### Method conversions

To migrate unsupported method calls from `dart:html` to `package:web`,
you'll mostly want to use conversion methods like `toJS()` and `toDart()`.
Learn how to use static interop conversion methods from the [Conversions][]
section of the JS types page.

```dart
_clickSubscription = window.onClick.listen(callback); // Remove
window.onclick = callback.toJS; // Add
```

Generally, you can spot which methods need to migrate because they'll be flagged 
with some variation of the exception:

```plaintext
A value of type '...' can't be assigned to a variable of type 'JSFunction?'
```

Also important to note that methods are [statically dispatched][static]
in `package:web`. So, unlike `dart:html`, there is no support for
dynamic dispatch like virtual methods, overriding members, or mocks.

[Helpers](#helper-layer) are available for some method call conversions
(and are continuosly being added to). You can find available helpers in the
[repo][helpers].

### Zones

In `dart:html`, calls are automatically zoned.
This is not the case in `package:web`. There is no
automatic binding of async callbacks in the current zone.

To migrate, you can still to use zones,
but you will have to [write them yourself][zones].
There is no [helper](#helper-layer) available yet.

## Helper layer

The core of `package:web` contains `external` members
to directly interop with the web,
but does not provide solutions for some other
functionality that `dart:html` handled by default.
To mitigate these differences,
`package:web` provides a [`helpers`][helpers] library
for additional support in handling a number of use cases
that aren't directly available through the core interop.
The helper library contains various types and members
to expose some legacy features from the Dart web libraries.

For example, `package:web` doesn't have any core functionality to handle
event listeners. Instead, you can use
[stream helpers][] that abstract the stream conversion logic
for subscribing to events with Dart streams,
so you don't need to write that logic yourself.

{% comment %}
Nice to have a line showing how to call a random method from the heper library?
```dart
// dart:html version
// package:web version
```
{% endcomment -%}

You can find all the helpers and their documentation in the repo 
at [`package:web/helpers`][helpers].

## Examples

Here are some examples of packages that have been migrated from `dart:html`
to `package:web`:

- [Upgrading `url_launcher` to `package:web`][]

{% comment %}
Do we have any other package migrations?
{% endcomment -%}

[`package:web`]: {{site.pub-pkg}}/web
[Wasm]: https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/README.md
[html]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-html/dart-html-library.html
[svg]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-svg/dart-svg-library.html
[`dart:js_interop`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[idl]: https://www.npmjs.com/package/@webref/idl
[js]: /interop/js-interop
[dart-lang/web]: https://github.com/dart-lang/web
[issue]: https://github.com/dart-lang/web/issues/new
[helpers]: https://github.com/dart-lang/web/tree/main/lib/src/helpers
[zones]: /articles/archive/zones
[Conversions]: /interop/js-interop/js-types#conversions
[interop methods]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/JSAnyUtilityExtension.html#instance-methods
[create alternative bindings]: https://github.com/dart-lang/web/blob/main/tool/generator/README.md
[Compatibility, type checks, and casts]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[pub-helpers]: {{site.pub-pkg}}/web
[Upgrading `url_launcher` to `package:web`]: https://github.com/flutter/packages/compare/main...johnpryan:wasm/url-launcher
[stream helpers]: https://github.com/dart-lang/web/blob/main/lib/src/helpers/events/streams.dart
[static]: /language/extension-types