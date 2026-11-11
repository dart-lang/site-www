---
title: "Announcing Dart 3.14"
description: >-
  Bringing the Dart workflow full circle with automated SDK migrations,
  faster WebAssembly, and a re-engineered DartPad.
publishDate: 2026-11-11
author: conooi
image: images/dart3-14-cover.webp
category: releases
layout: blog
---

<DashImage src="images/dart3-14.webp" alt="Chef Dash pulling a freshly baked pie with the Dart logo from an oven next to glowing 3.14 numbers." caption="Announcing Dart 3.14" />

We are thrilled to announce Dart 3.14!

Fittingly for our pi release,
Dart 3.14 brings the developer workflow full circle,
from experimenting with ideas in the browser
to building cross-platform apps
and upgrading your packages for the next release.
You can test ideas and `pub.dev` packages in a re-engineered DartPad,
automatically migrate your codebase across SDK versions with `dart migrate`,
boost WebAssembly performance with hardware SIMD,
run Wasm modules outside the browser,
and call into native platform APIs with stable FFIgen and JNIgen support.

So [update Dart](/get-dart)
or run [`flutter upgrade`](https://docs.flutter.dev/install/upgrade)
and follow along as we explore what's new in Dart 3.14!
When you're ready to see what's new across the UI framework,
check out the companion
[What's new in Flutter 3.50](https://flutter.dev/blog/whats-new-in-flutter-3-50)
blog post.

## Tools updates

### Automated package upgrades with the `dart migrate` tool

Updating a Dart package to a newer SDK version often involves
bumping its SDK constraint and updating code
to adhere to new style recommendations
or prevent breakages with the incoming version.
However, figuring out which lints to enable
or what code changes are needed for each release can be tricky.

To take the guesswork out of upgrading across releases,
the new `dart migrate` tool automates this workflow
by bumping a package forward one version at a time.
For each version, it will:

1. Prepare your package by applying fixes from `dart fix`
   that need to be performed before the version bump.
1. Bump the lower bound of the SDK constraint in your `pubspec.yaml`.

Once your package is on the new version,
you can optionally clean it up by applying fixes
that use the new features or adhere to the new style recommendations.

For example, in a package with an SDK constraint of `^3.12.0`:

```dart
class WeakPasswordException implements Exception {}

void checkPassword(final String password, final int minLength) {
  if (password.length < minLength) {
    throw WeakPasswordException();
  }
}
```

The tool prepares the code by removing `final` from parameters,
which is a compile-time error in Dart 3.13.
It bumps the SDK constraint in the pubspec,
and then cleans it up by adopting the new semicolon body syntax
for empty classes:

```dart
class WeakPasswordException implements Exception;

void checkPassword(String password, int minLength) {
  if (password.length < minLength) {
    throw WeakPasswordException();
  }
}
```

When it's done running,
the migrate tool reports a summary of the edits for each step,
along with the optional cleanup fixes your package can still apply:

```text
my_package:
  3.12.0 -> 3.13.0:
    Preparatory changes:
      2 changes made in 1 file.

      my_package/lib/password.dart
        avoid_final_parameters • 2 changes

    SDK constraint:
      Bumped ^3.12.0 -> ^3.13.0

Optional cleanup fixes can modernize your code further:

  my_package: 1 change in 1 file
    empty_container_bodies • 1 change

To preview them, run 'dart pub get' and then 'dart migrate --dry-run --step=cleanup' on the same packages.
```

To preview changes for a package, use the `--dry-run` flag:

```bash
dart migrate --dry-run
```

To apply the proposed changes, use the `--apply` flag:

```bash
dart migrate --apply
```

For larger codebases where you may want to review fixes
before or after bumping the SDK constraint,
you can run specific steps using the `--step` flag:

```bash
# Only run preparatory fixes without bumping the constraint
dart migrate --apply --step=prepare

# After applying the preparatory fixes, bump the constraint and apply cleanup fixes
dart migrate --apply --step=bump,cleanup
```

By default, running the tool bumps the package by one minor version.
To migrate multiple versions in one run, use the `--target-sdk` flag:

```bash
dart migrate --apply --target-sdk=3.14.0
```

:::note
`dart migrate` only supports packages
whose SDK constraint requires Dart 3.0 or later.
:::

**Learn more:** [Dart migrate documentation](/tools/dart-migrate)

### Analysis Server performance improvements

Alongside smoother SDK upgrades,
keeping your IDE responsive and speeding up workflows with AI coding agents
as your workspace grows is a top priority for our tooling team.
Multiple performance improvements have landed in the Dart Analysis Server:

- **Faster file discovery:**
  Speeds up requests like **Find References**,
  especially when the workspace includes many Analysis Contexts.
- **Less-blocking tasks:**
  Tasks that previously blocked other actions like code formatting
  are now less blocking.
- **Faster server startup:**
  Reduces startup time,
  including when the analysis server restarts its analysis
  due to changes in package configuration and analysis options.
- **Faster `documentColor` requests:**
  Speeds up the `documentColor` request,
  which unblocks many other analysis server requests when editing a file.
- **Scoped analyzer plugin roots:**
  Restricts plugin analysis roots to plugin context roots,
  which makes analyzer plugins analyze faster.

### Pub updates

#### ETag cache support for faster dependency resolution

Warm-cache dependency resolution in `dart pub` is now faster
and uses much less bandwidth on medium-to-large projects.
When resolving dependencies with `dart pub get`, `upgrade`, or `add`,
`pub` queries `pub.dev` for each package's version listing
to check for newly published versions, retractions, and security advisories,
which previously meant re-downloading megabytes of package metadata
even when nothing had changed.

Now, `dart pub` stores the server's `ETag`
alongside cached package listings in your local pub cache
and sends conditional `If-None-Match` requests when resolving with a warm cache.
When a package listing hasn't changed,
`pub.dev` responds with `304 Not Modified` and an empty body,
and `pub` reuses the cached listing directly without re-downloading it.
On a Flutter project with 144 dependencies,
this eliminates ~1.5 MB of repeated version-listing downloads,
speeding up warm-cache resolution,
especially on slower or higher-latency connections.

### Re-engineered DartPad beta

We are excited to share a beta release of a newly re-engineered
[DartPad](https://dartpad.dev)
that makes it easier and faster to experiment with Dart and Flutter
right in your browser.

It's built on top of `package:dartpad`,
which compiles the Dart compiler, the analyzer, and the pub client
to WebAssembly and runs them locally in a Web Worker.
This means DartPad now analyzes and compiles your code directly in the browser,
so you get faster feedback without waiting on a remote server.
It also features full Language Server Protocol (LSP) support:
you get the same code completion, hover documentation, go-to-definition,
and quick fixes you're used to from your IDE.

An exciting feature of this new tech stack is that
it lets you pull in packages from `pub.dev`,
so you're no longer limited to a hand-picked allowlist.
Bring in the libraries you'd use in a real project and try them out instantly.
Additionally, DartPad now supports multiple files,
so you can organize widgets and data models
the way you would in a real app.

The new DartPad shows Dart's versatility as a full-stack language
that can run on your machine, the server, or in a web browser.
Because those core tools are written in Dart themselves,
compiling them to WebAssembly makes it possible
to run the entire workflow directly in the browser.

**Try it out:** [dartpad.dev](https://dartpad.dev)

## Web platform updates

### Standardized WebAssembly exceptions for browsers and Wasm runtimes

Dart WebAssembly apps now run across more browsers
and non-browser Wasm environments out of the box.
In the browser, `dart2wasm` now emits finalized WebAssembly
[`try_table` exception-handling instructions](https://github.com/dart-lang/sdk/issues/54394)
by default and works around
[streaming compilation issues in Safari 26.5 and earlier](https://github.com/dart-lang/sdk/issues/63543),
enabling WebAssembly across Chrome 137+, Safari 26.2+, and Firefox 147+.

Outside the browser, adopting `try_table` removes
the compiler's last reliance on JavaScript exception wrappers
in `dart compile wasm --standalone`
(contributed by community member [Simon Binder](https://github.com/simolus3)).
This produces standard `.wasm` binaries
that execute directly in Wasm runtimes such as [Wasmtime](https://wasmtime.dev/)
without needing a JavaScript host,
making it much easier to run Dart in edge workers, plugin systems,
and server-side Wasm environments.
To experiment with WASI and the WebAssembly Component Model,
explore Simon Binder's community
[`wasm_tools`](https://pub.dev/packages/wasm_tools) package
on [GitHub](https://github.com/simolus3/wasm.dart).

**Learn more:** [WebAssembly documentation](/web/wasm)

### Hardware 128-bit WebAssembly SIMD

Alongside wider runtime support,
WebAssembly performance gets a major boost in this release.
Thanks to over 60 SDK contributions from community member
[Modestas Valauskas](https://github.com/modulovalue),
`dart2wasm` now compiles `Int32x4`, `Float32x4`, `Float64x2`,
and their typed-data list views directly to
[hardware 128-bit WebAssembly SIMD (`v128`) instructions](https://github.com/dart-lang/sdk/issues/64170),
alongside expanded and optimized `Int32x4` operations in `dart:typed_data`
on native platforms,
delivering up to 4x speedups across native and WebAssembly SIMD benchmarks.

**Learn more:** [`dart:typed_data` library documentation](https://api.dart.dev/dart-typed_data/)

### Legacy web library removal with `--no-deprecated-js-interop`

As WebAssembly adoption grows and we continue modernizing the Dart web platform,
the legacy web and JavaScript interop libraries
(`dart:html`, `dart:js`, `dart:js_util`, `package:js`,
and related `dart:*` browser libraries)
are deprecated and scheduled for removal from the Dart SDK
in an upcoming release.
While we know migrations take time,
moving to `package:web` and `dart:js_interop` unlocks
a much more robust, standardized future for Dart on the web,
including full compatibility with WebAssembly.

To help you prepare your code early,
`dart compile js` (`dart2js`) and `ddc` now support
[`--no-deprecated-js-interop`](https://github.com/dart-lang/sdk/issues/63919),
which rejects direct or transitive imports of those libraries at compile time
and sets their `dart.library.*` environment conditions to `false`
in conditional imports.

Run `dart compile js --no-deprecated-js-interop`
(or `flutter build web --no-deprecated-js-interop`
in [Flutter 3.50](https://flutter.dev/blog/whats-new-in-flutter-3-50))
on your packages and apps today,
and migrate remaining usages to [`dart:js_interop`](/interop/js-interop)
and [`package:web`](/interop/js-interop/package-web).

**Learn more:** [JS interop documentation](/interop/js-interop) and
[Migrating to package:web](/interop/js-interop/package-web)

## Core engine and runtime updates

### Fast range comparisons in `dart:typed_data`

Comparing slices of byte buffers in performance-critical code
no longer requires allocating `sublistView`s and iterating element-by-element
(for example, with `package:collection`'s `ListEquality`).
`dart:typed_data` now includes a `rangeEquals` extension method
on all integer typed data lists
(`Uint8List`, `Int8List`, `Uint8ClampedList`, `Uint16List`, `Int16List`,
`Uint32List`, `Int32List`, `Uint64List`, `Int64List`)
and `ByteData`:

```dart
import 'dart:typed_data';

void main() {
  final packet = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A]);
  final pngMagic = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);

  // Compare packet[0..4] against pngMagic[0..4] without allocating views:
  if (packet.rangeEquals(0, 4, pngMagic)) {
    print('PNG header matched');
  }
}
```

Under the hood, `rangeEquals` is lowered to `memcmp` on the Dart VM,
direct Wasm array loads (with 32-bit chunking for `ByteData`) on `dart2wasm`,
and tight typed-array loops on JS,
giving you fast, allocation-free comparisons across every target.

**Learn more:** [`dart:typed_data` library documentation](https://api.dart.dev/dart-typed_data/)

## Direct native interoperability

Beyond the core runtime,
calling into native platform libraries from Dart is now ready for production.
With Dart 3.14, [FFIgen](https://pub.dev/packages/ffigen) for Objective-C
and [JNIgen](https://pub.dev/packages/jnigen) are **stable**!

Instead of writing manual platform channel boilerplate,
you can use FFIgen and JNIgen to automatically generate
idiomatic, type-safe Dart bindings and call
Objective-C, Java, and Kotlin APIs directly from Dart.
Reaching stability is the result of years of design, iteration, and feedback
focused on reducing the friction of building Dart packages and Flutter plugins,
and we'll share a deeper dive into choosing the right interop approach
for your use case soon on the [Flutter blog](https://flutter.dev/blog).

**Learn more:** [Native interoperability documentation](https://docs.flutter.dev/interop)

## Looking ahead: Language roadmap

The team continues to make progress on `this` promotion and static extensions.
Stay tuned to hear more about them in an upcoming release!

**Learn more:** [Dart language funnel](https://github.com/dart-lang/language/projects/1)

## Community

### A structured RFC process for Dart

Community contributors play a big part in every Dart release,
including the standalone WebAssembly and hardware SIMD improvements
in Dart 3.14.
As the Dart ecosystem continues to grow,
we want to make it even easier to follow and contribute
to major project decisions.
The Dart project is adopting a new structured approach
to proposing and evaluating large changes that require team consensus:
such changes now require authoring a Request for Comments (RFC).

This process can be used by both team members and community contributors
to solicit feedback and formal approval
from the Dart team and Dart project leadership.
It also aims to provide clear visibility into what the team is working on
by consolidating design discussions and decision artifacts in a single place.

**Learn more:** [Dart RFC repository](https://dart.googlesource.com/rfc)

## Take Dart 3.14 for a spin

Our pi release brings Dart full circle,
connecting your workflow from testing `pub.dev` packages in the browser
with DartPad,
to shipping high-performance WebAssembly and native apps,
to automating version upgrades with `dart migrate`.
Under the hood, Dart's own compiler, analyzer, and `pub` client
now compile to WebAssembly to run Dart itself in the browser.

That full-circle loop extends to the Dart community as well.
Key highlights in Dart 3.14 were driven directly by open-source contributors,
and our new RFC process brings greater transparency
to how large engineering changes are designed, reviewed,
and shared across the Dart project.
Thank you to everyone who contributed code, filed issues, and shared feedback
during this release!

Ready to dive in?
Run [`flutter upgrade`](https://docs.flutter.dev/install/upgrade)
or [download the latest Dart SDK](/get-dart),
try out the new [DartPad](https://dartpad.dev) beta preview,
and share your feedback on our
[GitHub issue tracker](https://github.com/dart-lang/sdk/issues).
Thank you for building with us!

**Learn more:** [Dart SDK changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3140)
