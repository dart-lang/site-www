---
title: "Dart 2.17: Productivity and integration"
description: "Language features. Productivity tools. Deeper & broader platform integration."
publishDate: 2022-05-11
author: "mit-mit"
image: images/1eJKM-4rFprGXyxNd5w2m-Q.png
category: announcements
tags:
  - dart
  - announcements
  - programming
  - dartlang
  - productivity
---


Today at [Google I/O](https://io.google/2022/products/flutter/), we announced a new Dart SDK, version 2.17. This release builds on our core themes of leading productivity and platform portability. It offers new language features: enums with member support, improved parameter forwarding to super classes, and more flexibility for named parameters. We have improved tools with a new major version of `package:lints` — our tool support for checking Dart code against our best practices — and a broad update of core library API documentation with rich code samples. For improved platform integration we have new templates for using `dart:ffi` (native C interop) in Flutter plugins, experimental support for RISC-V processors, and support for signing macOS and Windows executables.

<DashImage src="images/1eJKM-4rFprGXyxNd5w2m-Q.png" />


## New language features for improved productivity

We constantly evolve the Dart language to make you more productive — both by adding new features and by making improvements to existing features. Dart 2.17 adds major new support for members on enums, refines how you can use named arguments in constructors, and makes code for forwarding parameters to superclasses much less verbose and repetitive.

### Enhanced enums with members

Enums are great for representing a discrete set of states. For example, we might model water as `enum Water { frozen, lukewarm, boiling }`. But what if we want to add some methods on the `enum` — for example, to convert each of the states to a temperature, and support converting the `enum` to a `String`? We could perhaps use extension methods to add a `waterToTemp()` method, but we’d have to be careful to keep that in sync with the `enum`. For the `String` conversion we’d prefer to override `toString()`, but that hasn’t been supported.

With Dart 2.17 we now have general support for members on enums. That means we can add fields holding state, constructors that set that state, methods with functionality, and even override existing members. Many of you have been requesting this capability; it was our [third highest voted issue](https://github.com/dart-lang/language/issues?q=is%3Aissue+sort%3Areactions-%2B1-desc+) in the language tracker.

For our water example, we can add an `int` field holding the temperature and a default constructor that takes an `int`:

```
enum Water {
…
  final int tempInFahrenheit;
  const Water(this.tempInFahrenheit);
}
```


To ensure the constructor is called when the `enum` is created, we need to invoke it for each `enum` value:

```
enum Water {
  frozen(32),
  lukewarm(100),
  boiling(212);
…
}
```


To support the conversion to `String`, we simply override `toString`, which `enums` inherit from `Object`:

```
[@override](http://twitter.com/override)
String toString() => "The $name water is $tempInFahrenheit F.";
```


And with that, you have a complete `enum` that can be easily instantiated and you can invoke methods on:

```
void main() {
  print(Water.frozen); // Prints “The frozen water is 32 F.”
}
```


A complete example of these two approaches is illustrated below; we find the new Dart 2.17 version much easier to read and maintain.

<DashImage src="images/0hGKUdu4DT9v2IZGj.png" />


### Super initializers

When you have a class inheritance hierarchy, a common pattern is to pass some constructor parameters to the constructor of the superclass. To do that, the sub-class needs to 1) list each parameter in its own constructor, and 2) invoke the super constructor with those parameters. That leads to boilerplate code: lots of repetition, making the code harder to read and more bothersome to maintain.

Several Dart community members helped make this happen. GitHub user @roy-sianez filed a [language issue](https://github.com/dart-lang/language/issues/1855) regarding this about half a year ago; suggesting something similar to what GitHub user [@apps](http://twitter.com/apps)-transround had [suggested earlier](https://github.com/dart-lang/language/issues/493#issuecomment-879624528): that we could perhaps resolve this by introducing a new construct to express that a parameter was specified in the super class. We thought that was a great idea, so this has been added to Dart 2.17. As you can see from the following example, this is especially relevant for Flutter widget code. In fact, when we applied the new feature to the Flutter framework, we saw a total reduction of [nearly two thousand lines of code](https://github.com/flutter/flutter/pull/100905/files)!

<DashImage src="images/0ypTj-6zzDBoqnpRL.png" />


### Named args everywhere

Lastly, we’ve refined how named arguments work when you invoke a method. Previously, these had to appear last in the list of arguments to the method. This was annoying in cases where you’d prefer to place a positional argument last to make the code more readable. For example, see the following invocation of the `List&lt;T&gt;.generate` constructor — before, the growable argument had to be placed last, making it easy to miss below the large positional argument containing the generator itself. Now you can order them as you prefer, allowing you to place the small named arguments first and the generator last.

<DashImage src="images/0gMf1J56vEgV96z1l.png" />


For further examples of these three features in actions, see our updated samples for [enums](https://github.com/dart-lang/samples/blob/master/enhanced_enums/lib/members.dart), [super initializers](https://github.com/dart-lang/samples/blob/master/parameters/lib/super_initalizer.dart), and [named parameters](https://github.com/dart-lang/samples/blob/master/parameters/lib/named_parameters.dart).

## Productivity tools

Continuing the productivity theme, we have several improvements in our core tools.

In Dart 2.14 we introduced `package:lints`, which works with the Dart analyzer to help you write Dart code that prevents errors and uses a canonical style enabling more effective code reviews. Since then a number of new lints have been made available in the analyzer, which we’ve carefully triaged and from that selected [ten new lints](https://github.com/dart-lang/lints/blob/main/CHANGELOG.md#200) for all Dart code, and [two new lints](https://github.com/flutter/packages/blob/master/packages/flutter_lints/CHANGELOG.md#200) specifically for Flutter code. These include lints for ensuring your imports are included in your pubspec file, preventing the misuse of null checks on type parameters, and ensuring a consistent style for child properties. You can upgrade to the new lints with a simple command:

* For Dart packages:
`dart pub upgrade —-major-versions lints`

* For Flutter packages: 
`flutter pub upgrade —-major-versions flutter_lints`

SecureSockets are commonly used to enable TCP sockets secured with TLS and SSL. Before Dart 2.17, debugging these sockets during development was tricky, as there was no way to inspect the secure data traffic. We’ve now added support for specifying a `keyLog` file. When specified, a line of text in the [NSS Key Log Format](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format) is appended to the file when new TLS keys are exchanged with the server. This enables network traffic analyzer tools (such as [Wireshark](https://gitlab.com/wireshark/wireshark/-/wikis/TLS#tls-decryption)) to decrypt the content sent through the socket. For details, see the API docs for [`SecureSocket.connect()`](https://api.dart.dev/stable/2.17.0/dart-io/SecureSocket/connect.html).

API documentation generated by the `dart doc` tool is a critical asset to most Dart developers learning new APIs. While our [core library APIs](https://dart.dev/guides/libraries) have long had rich textual descriptions, many developers have told us they prefer to learn APIs by reading sample code that uses the API. With Dart 2.17, we’ve completely overhauled all major core libraries, adding sample code to the top 200 most viewed pages, so they now have comprehensive sample code. As an example, compare the documentation for dart:convert in [Dart 2.16](https://api.dart.dev/stable/2.16.2/dart-convert/dart-convert-library.html) with the updated page for [Dart 2.17](https://api.dart.dev/stable/2.17.0/dart-convert/dart-convert-library.html); hopefully this makes the documentation much easier to consume.

Productivity gains come not only when we add new features to our platform, but also when we clean up our stack and remove features that are no longer used. This helps keep our surface area small, which is critical especially to new developers. Towards this, we’ve removed [231 lines of deprecated code](https://dart-review.googlesource.com/c/sdk/+/236840) from the `dart:io` library — if you are still using these deprecated APIs, you can upgrade to their replacements with [`dart fix`](https://dart.dev/tools/dart-fix). We’ve also continued our effort to remove [deprecated Dart CLI tools](https://github.com/dart-lang/sdk/issues/46100), this time removing the `dartdoc` tool (use `dart doc` instead), and `pub` tool (use `dart pub` or `flutter pub`).

## Broadening our platform integration and support

A second core theme is platform integration and support. Dart is a true multi-platform language. While we already support a [wide range of platforms](https://dart.dev/overview#platform), we’re constantly evolving to ensure that you can deeply integrate with each supported platform, and also to support emerging platforms.

Dart FFI — our core mechanism for [interop with C/native code](https://dart.dev/guides/libraries/c-interop) — is a popular way of integrating Dart code with existing native platform code. On Flutter, this can be a great way to build [plugins](https://docs.flutter.dev/development/packages-and-plugins/developing-packages) that use native APIs from the host platform (such as Windows win32 APIs). In Dart 2.17 and Flutter 3, we’ve added templates to the `flutter` tool so you can now easily create FFI Plugins that have a Dart API backed by `dart:ffi` calls into native code. For details, see the updated [developing packages and plugins](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#dart-only-platform-implementations) page on flutter.dev.

To enable use of FFI on platforms that have types specific to their ABI ([application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface)), FFI now supports ABI-specific types. For example, you can now use [`Long`](https://api.dart.dev/stable/2.17.0/dart-ffi/Long-class.html) (`long` in C) to correctly represent a long integer with an ABI-specific size, which might be 32-bit or 64-bit depending on the CPU architecture. For the full list of supported types, see the list of “Implementers’’ in the [`AbiSpecificInteger`](https://api.dart.dev/stable/2.17.0/dart-ffi/AbiSpecificInteger-class.html) API page.

When deeply integrating with native platforms using Dart FFI, you sometimes need to align the cleanup of memory or other resources (ports, files, and so on) allocated by Dart and the native code. This has historically been very tricky, as Dart is a garbage collected language that automatically handles cleanup. Dart 2.17 solves this by introducing the concept of a Finalizer, which includes a `Finalizable` marker interface for “tagging” objects that shouldn’t be finalized or discarded too early, and a `NativeFinalizer` class that can be attached to a Dart object to provide a call-back run when the object is about to be garbage collected. Together these allow for running cleanup code in both native and Dart code. For details, see the description and example in the API documentation for [`NativeFinalizer`](https://api.dart.dev/stable/2.17.0/dart-ffi/NativeFinalizer-class.html), or the documentation for [`WeakReferences`](https://api.dart.dev/stable/2.17.0/dart-core/WeakReference-class.html) and [`Finalizer`](https://api.dart.dev/stable/2.17.0/dart-core/Finalizer-class.html) for similar support in regular Dart code.

Our support for compiling Dart to native code is a core enabler of making Flutter apps have great startup performance and fast rendering. A second use case is the ability to compile Dart to executables with [`dart compile`](https://dart.dev/tools/dart-compile). These executables can run standalone on any machine without needing the Dart SDK to be installed. Another new capability in Dart 2.17 is support for [signing of executables](https://dart.dev/tools/dart-compile#exe), which enables deployment on Windows and macOS where signing is often required.

We’re also continuing to broaden our set of supported platforms by staying at the forefront of new emerging platforms. [RISC-V](https://riscv.org/about/) is a new innovative instruction set for processors. RISC-V International, a global non-profit organization, owns the RISC-V specification, making the instruction set free and open. This is still an emerging platform, but we’re excited about its potential, so our `2.17.0–266.1.beta` Linux release (or later from our [beta channel)](https://dart.dev/get-dart/archive#beta-channel) includes experimental support for it. We’d love to hear your feedback, so please [file an issue](https://github.com/dart-lang/sdk/issues) or [post](https://groups.google.com/a/dartlang.org/g/misc) about your experience!

## Get started with Dart 2.17!

We hope that today’s Dart 2.17 release excites you, improves your productivity, and enables even more platform integration for your apps. To get started, you can directly download the Dart[ 2.17](https://dart.dev/get-dart) release, or get it embedded as part of today’s [Flutter 3](https://docs.flutter.dev/get-started/install) SDK release.

We also invite you to check out [the new content](https://io.google/2022/products/flutter/) we’ve made available for Google I/O!