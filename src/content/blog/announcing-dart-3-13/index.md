---
title: "Announcing Dart 3.13"
description: "Bringing conciseness and simplicity to Dart codebases, tooling, and platforms."
publishDate: 2026-08-12
author: conooi
image: images/dart3-13-cover.webp
category: releases
layout: blog
---

<DashImage
  src="images/dart3-13.gif"
  alt="Dart 3.13 release banner animation with the Dart logo."
  caption="Announcing Dart 3.13"
/>

We are thrilled to announce Dart 3.13!

In this release, we are celebrating a theme that every developer loves:
clean and lightweight code.
Dart 3.13 brings this focus to every layer of the developer experience.
On the language front, primary constructors eliminate repetitive boilerplate
so you can define classes in a single line of code.
In developer tooling, refinements to `dart format` keep your code neat
according to [Effective Dart style rules](https://dart.dev/effective-dart/style#ordering),
while `dart pub` introduces new workspace commands to keep monorepos tidy.
On pub.dev, richer package documentation features like `<callout-box>` and `{@example}`
directives make package docs clearer to read.
Under the hood, native library tree-shaking (`@RecordUse`) and WebAssembly deferred loading
ensure your compiled application binaries remain as compact as possible.

So [update Dart](https://dart.dev/get-dart) or run [`flutter upgrade`](https://docs.flutter.dev/install/upgrade)
and follow along as we explore what's new in Dart 3.13!

## Language updates

### Primary constructors

Following an experimental preview in Dart 3.12,
primary constructors are now officially stable in Dart 3.13!

Primary constructors represent a major step forward for class conciseness.
We've heard from developers that repeating field names and types
across class bodies and parameter lists can feel tedious.
Primary constructors solve this completely, allowing you to define, for example,
a `Point` class with two fields and a constructor in a single line of code:

```dart
class Point(final int x, final int y);
```

This feature also includes
[concise syntax for constructors](https://dart.dev/language/constructors#concise-constructor-syntax)
using the `new` or `factory` keywords,
allowing empty declaration bodies to end with a `;`.

To help you adopt primary constructors and maintain a consistent style
across your codebase, we've introduced several new lints with automated fixes:

- `empty_container_bodies`: Encourages brevity by using `;` rather than `{}`
  in class-like declarations.
- `initialize_in_field_declaration`: Encourages clarity by moving field initialization
  from a primary constructor to the field declaration.
- `unnecessary_const_in_enum_constructor`: Encourages brevity by removing `const`
  from enum constructors.
- `unnecessary_primary_constructor_body`: Encourages brevity by removing unneeded
  primary constructor bodies.
- `unnecessary_type_name_in_constructor`: Encourages brevity by replacing the type name
  with `new` in constructor declarations.
- `use_declaring_parameters`: Encourages brevity by using declaring parameters
  where possible.

Along with these lints, we've also added new IDE refactorings
to automate your code migration:

- **Convert to primary constructor**: Converts an eligible in-body constructor
  to a primary constructor.
- **Convert to in-body constructor**: Converts a primary constructor
  to an in-body constructor.
- **Convert to declaring parameter**: Converts a non-declaring parameter
  in a primary constructor to a declaring parameter.
- **Move initialization to the field declaration**: Moves field initialization
  from the constructor initializer list to the field declaration.

**Learn more:** [Primary constructors documentation](https://dart.dev/language/primary-constructors)

## Web platform updates

### WebAssembly deferred loading preview

We've been hard at work expanding WebAssembly capabilities for Dart on the web.
In Dart 3.13, we're excited to share an early preview of deferred loading support
when compiling with `dart2wasm`.
You can enable it today using the experimental compiler flag:

```bash
dart compile wasm -O2 --enable-deferred-loading
```

:::note
Deferred loading requires your app embedder to supply a callback responsible
for loading Wasm module bytes.
For details, see the `CompiledApp.instantiate` documentation in your generated
`<app>.mjs` file.
:::

In large applications using deferred loading, `dart2wasm` delivers significant
initial page load (IPL) time improvements compared to `dart2js`,
benefiting both Flutter web apps and DOM-based web applications.

**Learn more:** [WebAssembly documentation](https://dart.dev/web/wasm).

### Deprecation and removal of dart:html

As part of our ongoing effort to modernize the Dart web platform
and support WebAssembly, the legacy `dart:html` library is deprecated
and scheduled for complete removal in a future release.
If your code or packages still rely on `dart:html`,
migrate to the modern JavaScript interop model using `dart:js_interop`
and `package:web`.
Upgrading your package dependencies often resolves legacy interop uses automatically.

**Learn more:** [JS interop migration guide](https://dart.dev/interop/js-interop/package-web)
and [JS interop usage documentation](https://dart.dev/interop/js-interop/usage)

## Core engine and runtime updates

### Engineering highlights

Alongside our web platform progress, our team is constantly improving
the foundation of Dart.
Here are a few highlights of what we've worked on behind the scenes
over the past three months:

- **Type promotion soundness fix**: Fixed a
  [rare unsoundness](https://github.com/dart-lang/sdk/issues/62889) issue
  with type promotion involving nested functions.
- **Common front-end refactoring**: Refactored internal common front-end
  components to enable greater code sharing with the Dart analyzer.
- **DDC module system unification**: Continued removing legacy DDC
  (Dart Development Compiler) module systems across tools to establish a single,
  unified module system.
- **Native runtime memory safety**: Enhanced native runtime memory safety
  by introducing a memory cage around the Dart heap.
- **Dynamic module linking**: Initiated experiments with
  [dynamic modules](https://github.com/dart-lang/sdk/blob/f29989d506b2dd82957da5d1917bcc76628c5ddb/pkg/dynamic_modules/README.md)
  to enable dynamic code linking, paving the way for improved development workflows
  like fast prototype sharing within a team.

## Tools updates

### Dart formatter

Keeping codebases tidy and easy to read is a top priority for `dart format`.
In Dart 3.13, we've introduced a handful of style tweaks
to make formatted code even cleaner.
While most changes are minor, a few key updates will make your everyday code
noticeably easier to read:

- **Method call mis-formatting fix**: We fixed a bug where an optimization
  would sometimes erroneously kick in and mis-format code.
  It mostly pops up around method calls containing large collection literals:

```dart
// Before:
await MethodChannelContainer()
    .onMethodChannelInvoke("reportCrash", <String, dynamic>{
      "time": nowTime,
      "errorValue": errorName,
      "reason": reason,
      "stacktrace": stacktrace,
    });

// After:
await MethodChannelContainer().onMethodChannelInvoke(
  "reportCrash",
  <String, dynamic>{
    "time": nowTime,
    "errorValue": errorName,
    "reason": reason,
    "stacktrace": stacktrace,
  },
);
```

- **Method chain split heuristics**: We changed the heuristics around whether
  the formatter decides to split a method call chain at the `.`
  or inside one of the argument lists.
  If the target of the method chain is a collection literal or function call
  with a single element or argument, it now prefers to split the call chain
  instead of the target:

```dart
// Split target:
function(
  argument,
).method().another();

// Or split chain:
function(argument)
    .method()
    .another();
```

- **Import section separation**: The formatter will now insert a blank line
  between different "sections" of a series of imports.
  The formatter doesn't sort the imports, but it will at least separate them now
  according to [the rules in Effective Dart](https://dart.dev/effective-dart/style#ordering):

```dart
// Before:
import 'dart:io';
import 'dart:math';
import 'package:args/args.dart';
import 'package:test/test.dart';
import 'my_library.dart';

// After:
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:test/test.dart';

import 'my_library.dart';
```

There are some other style tweaks described in the
`dart_style` CHANGELOG, but those are the most visible ones.
We know that formatting changes can cause annoying churn,
so we try to be conservative when changing the style.
At the same time, a style improvement can make code easier to read,
which is a valuable benefit in an era where we are all reviewing more code than ever
thanks to generative AI.
Aside from the optimization bug fix, these style changes are language-versioned.
You will only see them when you upgrade your code to Dart 3.13.

**Learn more:** [Dart formatter documentation](https://dart.dev/tools/dart-format)

### Pub updates

#### Package documentation updates

Clear and well-structured package documentation is essential for a healthy ecosystem.
To help package authors create cleaner, more maintainable docs,
pub.dev now supports `<callout-box>` tags and `{@example}` directives end-to-end.
You can extract code snippets directly from example files into your API documentation
while hiding unnecessary boilerplate.

For example, define a snippet region in `example/foo.dart`:

```dart
// example/foo.dart
void main() {
  // #region abc
  // Included in documentation
  foo();
  assert(false); // #hide
  // #endregion
}
```

Then reference that region in your Dart doc comments:

```dart
/// This is a great function.
///
/// Example usage:
/// {@example /example/foo.dart#abc}
void foo() {}
```

pub.dev renders the specified code region directly in the generated documentation.

<DashImage
  src="images/pub-doc-callout-example.webp"
  alt="The cupertino_ui documentation on pub.dev displaying a <callout-box> with a blue border alongside an embedded {@example} code block."
  caption="The cupertino_ui documentation on pub.dev displaying a <callout-box> with a blue border alongside an embedded {@example} code block."
/>

Behind the scenes, pub.dev also deployed a two-level hash index for dartdoc file lookups.
This update drastically speeds up documentation rendering for large packages
containing 100k+ generated files.

<DashImage
  src="images/pub-latency-blob-index.webp"
  alt="Chart showing Docs Request Latency drop after deploying the new blob index."
  caption="Docs Request Latency drop after deploying the new blob index."
/>

**Learn more:** [CupertinoActivityIndicator class documentation](https://pub.dev/documentation/cupertino_ui/latest/cupertino_ui/CupertinoActivityIndicator-class.html)

## Native interop updates

### Tree-shaking native libraries with @RecordUse and package:record_use

Our commitment to efficiency extends all the way down to your compiled application binaries.
When building Dart and Flutter apps that interoperate with native C, C++, or Rust code
using `dart:ffi` and Code Assets, the Dart compiler has always tree-shaken
unused Dart wrapper functions.
However, underlying native binaries traditionally remained bundled in full.

With `@RecordUse` (in `package:meta`) and `package:record_use`,
Dart and Flutter can now tree-shake native libraries alongside your Dart code.
This ensures your final application bundle contains only the native code you actually invoke.

#### How it works

1. **Annotate native FFI bindings with `@RecordUse()`**:
   Mark your native FFI bindings (such as those generated by `ffigen`)
   with the `@RecordUse()` annotation:

```dart
import 'dart:ffi';
import 'package:meta/meta.dart';

@RecordUse()
@Native<Int32 Function(Int32, Int32)>()
external int sqlite3_open(
  Pointer<Utf8> filename,
  Pointer<Pointer<sqlite3>> ppDb,
);

@RecordUse()
@Native<Int32 Function(Pointer<sqlite3>)>()
external int sqlite3_close(Pointer<sqlite3> db);
```

2. **Track reachable calls during compilation**:
   During whole-program compilation and tree-shaking in Dart AOT builds,
   the compiler tracks which `@RecordUse()` annotated bindings are reachable
   in executable code.
   Calls residing in unused Dart code that gets tree-shaken away
   are automatically excluded.

3. **Prune unused native symbols in your link hook**:
   In your package's link hook (`hook/link.dart`), retrieve `input.recordedUses`.
   Using `package:record_use`, query recorded calls and instruct your native toolchain
   (such as `package:native_toolchain_c` or a Rust build script)
   to keep only the symbols that Dart actually calls:

```dart
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:record_use/record_use.dart';
import 'package:my_package/src/c_library.dart';
import 'package:my_package/src/record_use_mapping.dart';

void main(List<String> arguments) async {
  await link(arguments, (input, output) async {
    // Extract symbols for functions called in reachable Dart code:
    final symbolsToKeep = input.recordedUses?.calls.keys
        .cast<Method>()
        .map((method) => recordUseMapping[method.name]!);

    await cLibrary.link(
      input: input,
      output: output,
      linkerOptions: LinkerOptions.treeshake(
        symbolsToKeep: symbolsToKeep,
      ),
    );
  });
}
```

#### Why this matters

- **Dramatically smaller binaries**: Heavy native dependencies like SQLite,
  cryptography, image decoders, or audio engines expose hundreds of functions.
  During release builds, the linker strips away unreferenced native code,
  dead object files, and unused exports.
- **Complete omission of unused native libraries**: If your application never invokes
  a package's native bindings, the link hook drops the native binary entirely
  from the final application bundle.
- **Seamless tooling integration**: Tools like `ffigen` automatically annotate
  generated bindings, while `package:native_toolchain_c` integrates directly
  with link hooks for effortless, end-to-end native tree-shaking.

**Learn more:** [Native link hooks documentation](https://dart.dev/tools/hooks#link-hooks)
and [Record use documentation](https://pub.dev/packages/record_use)

## Wrap up

Dart 3.13 brings our vision for a simpler, cleaner developer experience to life.
By connecting expressive language features like primary constructors with smarter tooling,
richer pub.dev docs, and compact native tree-shaking, this release helps you focus
on what matters most: building great apps.

Everything in this release is informed by your real-world insights, bug reports,
and package contributions.
The Dart ecosystem thrives because of your active participation,
and we are deeply grateful for your partnership in shaping where the language goes next.

We can't wait to see what you create with Dart 3.13!
Take a moment to [update Dart](https://dart.dev/get-dart)
or run [`flutter upgrade`](https://docs.flutter.dev/install/upgrade) today,
and join the conversation on our [GitHub issue tracker](https://github.com/dart-lang/sdk/issues).
Thank you for being such a passionate community and building the future of Dart with us!

**Learn more:** [Dart SDK changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3130)
