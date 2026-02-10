---
title: "Announcing Dart 2.6 with dart2native: Compile Dart to self-contained, native executables"
description: "Announcing Dart 2.6, featuring dart2native for compiling Dart apps to self-contained, native executables for Windows, macOS, and Linux"
publishDate: 2019-11-05
author: mit-mit
image: images/0lY0iF-neazyL0aE-.gif
category: announcements
tags:
  - dart
  - native-code
  - programming
  - compilers
  - announcements
layout: blog
---


Dart already offers [an extensive set of compilers](https://dart.dev/platforms) for building production-optimized code for mobile devices and the web. These flexible compilers enable our framework partners to target a wide range of form factors: Flutter apps on [Android & iOS](https://flutter.dev/docs), Flutter apps on the [web](https://flutter.dev/web) & [desktop](https://flutter.dev/desktop), AngularDart apps on the [web](https://angulardart.dev/), and Google Assistant on [embedded devices](https://developers.googleblog.com/2019/05/Flutter-io19.html).

Today we’re announcing **`dart2native`**, an extension of our existing compiler set, with the ability to compile Dart programs to self-contained executables containing ahead-of-time-compiled machine code. With dart2native, you can create tools for the command line on **macOS, Windows, or Linux** using Dart. This feature’s announcement picture [was implemented](https://gist.github.com/mit-mit/faec2bfc1d1cef7cd09df917e531c5c0) using the feature itself :-)

<DashImage src="images/0lY0iF-neazyL0aE-.gif" />


## Dart Native and the dart2native compiler

Dart has supported AOT (ahead-of-time) compilation to native machine code for several years, and [Dart Native](https://dart.dev/platforms) is thus fairly mature technology. However, in the past we only exposed this capability on iOS and Android mobile devices, via [Flutter](http://flutter.dev).

With `dart2native`, we’re extending our native compilation support to support traditional desktop operating systems running macOS, Windows, and Linux. Because the executables created with `dart2native` are self-contained, they can run on machines that don’t have the Dart SDK installed. And because they’re compiled with Dart’s AOT compiler, the executables start running in just a few milliseconds. As with other Dart compilers and runtimes, the same set of rich and consistent [core libraries](https://dart.dev/guides/libraries) are available in Dart when compiling to native code.

We’ve heard many customers ask for AOT compilation for desktop operating systems — the [sixth highest-rated issue](https://github.com/dart-lang/sdk/issues/36915) in our issue tracker — so we’re delighted to be able to make this feature available.
> If you used dart2aot before, then as of 2.6 you’ll use dart2native. It provides a superset of dart2aot’s functionality.

## Building command line apps with dart2native

The `dart2native` compiler is a great choice for building and deploying [Dart-based apps for the command line](https://dart.dev/tutorials/server/cmdline). These apps often use libraries such as [`dart:io`](https://api.dart.dev/stable/dart-io/dart-io-library.html) (basic I/O), `package:[http](https://pub.dev/packages/http)` (networking), and `package:[args](https://pub.dev/packages/args)` (argument parsing). Let’s review the basics of compiling a “hello, world” app to an executable:

The source code `hello.dart`:

```
main() {
  print(‘Hello Dart developers’);
}
```


Compile `hello.dart` to a `hello` executable:

```
$ dart2native src/hello.dart -o hello
Generated: /Users/mit/hello
```


Run `hello` measuring execution time:

```
$ time ./hello
Hello Dart developers

real 0m0.049s
user 0m0.018s
sys 0m0.020s
```


Notice how the command starts, prints to stdout, and exits in a combined time of just 49 milliseconds!

We’ve seen a few Dart developers already experiment with `dart2native` for command-line tools:

* Natalie from the [SASS](https://sass-lang.com/) (a popular CSS extension tool) team [reports](https://github.com/dart-lang/sdk/issues/32894#issuecomment-513975562) that after switching their Dart-based SASS implementation to compile with dart2native, it is now competitive in performance with LibSass, a C++ based implementation.

* Filip from the Dart DevRel team recompiled his [linkchecker](https://github.com/filiph/linkcheck/) tool with dart2native, and saw a [27x speedup](https://github.com/filiph/linkcheck/issues/7#issuecomment-496308288) when checking small sites.

## Interoperability with C code via dart:ffi

Native apps often need to access native functionality from the surrounding operating system. These system APIs are typically exposed in native C-based libraries, and Dart supports interoperability with these libraries via `dart:ffi`, our new mechanism for [C interop](https://dart.dev/guides/libraries/c-interop), which we launched in preview in [Dart 2.5](https://medium.com/dartlang/announcing-dart-2-5-super-charged-development-328822024970). The `dart2native` compiler is compatible with `dart:ffi`, so you can create and compile natively Dart apps that use it.

One team member recently used `dart:ffi` to create a [`dart_console`](https://pub.dev/packages/dart_console) library for console app development, which has functionality like getting window dimensions, reading and setting the cursor location, managing colors, and reading keys and control sequences. The ability to use `dart:ffi` makes Dart a very powerful language for console apps.

## kilo: a 7MB code editor written in less than 500 lines of Dart code

Using Dart core libraries, `dart:ffi`, and the dart_console library, we can create pretty interesting console apps. The dart_console package includes a full demo of *kilo*, a console text editor written in just ~[500 lines of Dart code](https://github.com/timsneath/dart_console/blob/master/example/kilo.dart). The name kilo comes from its origin, [`kilo.c`](https://github.com/antirez/kilo/blob/master/kilo.c), which was a C implementation in roughly 1000 lines of code.

With the new `dart2native` compiler we can easily package this, and we end up with a 7MB self-contained code editor. Here’s a demo of compiling the editor, and then using the compiled editor to edit its own source code to fix a bug:

<DashImage src="images/0f5pvUnbesO4mGZmW.gif" alt="The kilo editor written in Dart and compiled to an executable with dart2native editing it’s own source code" caption="The kilo editor written in Dart and compiled to an executable with dart2native editing it’s own source code" />


## Building services with dart2native

Another potential use of the dart2native compiler is for small services — for example, a backend supporting a frontend app written using Flutter. In recent years, a growing trend has been the use of services running on [serverless computing](https://en.wikipedia.org/wiki/Serverless_computing). These are fully managed services that automatically scale, including scaling up from and down to zero (not running), providing the potential to greatly lower cost because they are billed only when actually running. Google Cloud makes serverless computing available via [Cloud Run](https://cloud.google.com/run/).

For serverless backends it’s critical that the service starts quickly. Traditionally, Dart-based services have run with our JIT (just-in-time) compiler, but JIT-based execution has a high latency when starting as the code needs to be compiled and warmed up before it can start executing. By compiling your service’s code ahead-of-time to native code, you can avoid this latency and begin running right away. In addition, with native code you can create Dart services that have a small disk footprint and are self-contained, greatly reducing the size of the container in which the Dart service runs. Dart developer Paul Mundt recently [documented his experiences](https://itnext.io/experiments-with-dart-microservices-fa117aa408c7) with using the dart2native compiler; he was able to reduce the size of his Docker image by 91% from 220MB using JIT-compiled code down to just 20MB by using native code! See our documentation for more details about [server-side apps](https://dart.dev/tutorials/server/httpserver) and [packages](https://dart.dev/server/libraries#server-packages).

## Availability

The `dart2native` compiler is available in the Dart SDK starting with version 2.6, which is available starting today from [dart.dev/get-dart](https://dart.dev/get-dart). Once you’ve installed the SDK, you should see the new compiler inside the bin/ directory and in your `PATH`. Dart.dev has [more documentation](https://dart.dev/tools/dart2native).

If you’re getting the Dart SDK via Flutter, note that current Flutter builds have incomplete dart2native support. We recommend you install the Dart 2.6 SDK from [dart.dev/get-dart](https://dart.dev/get-dart).

## Known limitations

This initial version of the `dart2native` compiler has a few known limitations, listed below. You can let us know which issues are important to you by adding a “thumbs up” to the issue in our GitHub issue tracker.

* No cross-compilation support ([issue 28617](https://github.com/dart-lang/sdk/issues/28617)): The dart2native compiler supports creating machine code only for the operating system it’s running on. Thus, you’ll need to run the compiler three times — on macOS, Windows, and Linux — if you want to create executables for all three. One way of doing this is by using a CI (Continuous Integration) provider that supports all three operating systems.

* No signing support ([issue 39106](https://github.com/dart-lang/sdk/issues/39106)): The executables produced use a format that isn’t compatible with standard signing tools such as `codesign` and `signtool`.

* No support for `dart:mirrors` and `dart:developer` (see [Dart core libraries](https://dart.dev/guides/libraries)).

## Other changes in Dart 2.6

Version 2.6 of the Dart SDK also has a few other changes.

We launched a preview of `dart:ffi`, our new mechanism for [C interop](https://dart.dev/guides/libraries/c-interop), in [Dart 2.5](https://medium.com/dartlang/announcing-dart-2-5-super-charged-development-328822024970). Dart 2.6 has a new version of `dart:ffi`. This new version has a number of breaking API changes to make our APIs easier to use, provide more type safety, and to provide convenient access to memory. For additional details, see the [Dart 2.6 changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#foreign-function-interface-dartffi). With these changes `dart:ffi` graduates to the beta, and we expect API changes to be much less frequent going forward, and general stability is expected to be high. Please continue to give us feedback via the [issue tracker](https://github.com/dart-lang/sdk/issues).

Dart 2.6 also contains a preview of an exciting new language feature, [extension methods](https://github.com/dart-lang/language/issues/41). We still have a bit of polish and tools work left to complete this feature, but we hope to formally launch it in our next Dart SDK version. We’ll have much more to say about extension methods then; for now you can read about the [design considerations behind the feature](https://medium.com/dartlang/extension-methods-2d466cd8b308).

## Next steps

Download the Dart 2.6 SDK ([dart.dev/get-dart](https://dart.dev/get-dart)), build something cool with dart2native, and then tell us about it. If you’re willing to share the details, please leave a response at the bottom of this article. We’re excited to see what you build!