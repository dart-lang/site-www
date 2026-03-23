---
title: "Announcing Dart 3.5, and an update on the Dart roadmap"
description: "It’s time for another of our quarterly Dart SDK releases. We have improvements in interoperability, new features in our pub.dev package…"
publishDate: 2024-08-06
author: mit-mit
image: images/1PVj9TIzP50I00tavJqAg_Q.gif
category: announcements
layout: blog
---


It’s time for another of our quarterly Dart SDK releases. We have improvements in interoperability, new features in our pub.dev package manager, and we’ve graduated our new web integration APIs to stable and version 1.0.

A large portion of our time has been dedicated to larger, multi-quarter efforts, so with that we also have an update on our Dart roadmap, with details on what we hope to make progress on in the coming quarters.

<DashImage src="images/1PVj9TIzP50I00tavJqAg_Q.gif" alt="Dart 3.5 release image." caption="Dart 3.5 release image." />


## New capabilities in Dart 3.5

Dart 3.5 features a number of new capabilities discussed below. There are also a smaller number of changes to core library APIs, and about 10 very minor breaking changes, covered in the [changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#350).

## Web platform and JS interoperability

In Dart 3.4 and Flutter 3.22 we introduced support for [compiling Flutter Web apps to WebAssembly](https://docs.flutter.dev/platform-integration/web/wasm). Compilation to WebAssembly requires using our new [Dart to JS interop model](https://dart.dev/interop/js-interop), which previously was in preview. As of Dart 3.5 it is now considered stable and complete, and we’ve updated the browser API bindings in [package:web](https://pub.dev/packages/web) (which replaces the older `dart:html` library) to version 1.0.

We’d like to encourage all web package authors to [migrate to package:web](https://dart.dev/interop/js-interop/package-web). We plan on deprecating the old interop APIs (dart:html, dart:js, package:js, etc.) in our next Dart release, and fully discontinuing them later next year. We invite you to offer feedback on this plan in [the tracking issue](https://github.com/dart-lang/sdk/issues/56358). We also plan on updating the [scoring](https://pub.dev/help/scoring) on the pub.dev package manager to award points for web packages that support the new interop model.

We’ve also added [a new lint](https://dart.dev/tools/linter-rules/invalid_runtime_check_with_js_interop_types), which validates that your code uses the new JS interop types correctly. We recommend that you add this lint to your `analysis_options.yaml` file as part of migrating your web packages.

## Dart native interoperability

We’ve also made a range of improvements to our native interoperability, which supports calling directly from Dart into C, Java, Kotlin, Objective-C, and Swift.

C interop is enabled by our [FFI](https://dart.dev/interop/c-interop) (Foreign Function Interface) library, which we’ve supported for several years. In Dart 3.5, we’ve made incremental improvements to support passing a pointer from Dart `TypedData` objects directly to FFI, avoiding having to first copy the memory from Dart to Native ([details](https://github.com/dart-lang/sdk/issues/44589)).

Java & Kotlin interop is enabled by the [JNIgen](https://pub.dev/packages/jnigen) generator (currently in preview), which automates the creation of the bindings code to call from Dart into Java & Kotlin via the Java Native Interface ([JNI](https://developer.android.com/training/articles/perf-jni)). We’ve improved performance and added support for Java exceptions and Kotlin top-level functions. We’ve also discontinued the former [C-based bindings](https://github.com/dart-lang/native/issues/660), as the alternate Dart-only bindings now have comparable performance and features, and are much easier to use, For details, see the [changelog](https://pub.dev/packages/jnigen/changelog).

Objective-C interop builds on top of FFI and our [FFIgen](https://pub.dev/packages/ffigen) generator (currently in preview). We’ve added support for Objective-C protocols, and common types such as `NSString`. For a large example of a package built with FFIgen, see [cupertino_http](https://github.com/dart-lang/http/tree/master/pkgs/cupertino_http) which interoperates with Apple’s URL Loading System networking library.

We’ll continue to invest in further interoperability — both in terms of completing the above mentioned libraries, and in terms of supporting Swift — over the coming releases. See the roadmap section below for details.

## Pub.dev package repository

Pub.dev is our package repository where the community can share and find packages with a wealth of functionality. We’ve made a number of improvements here. First we’ve refined the support for [**topics**](https://dart.dev/tools/pub/pubspec#topics): the mechanism by which package authors can tag their packages with the category that they belong to (such as widget). We now [consolidate](https://github.com/dart-lang/pub-dev/blob/master/doc/topics.yaml) common topics that cover the same category but use slight variations in their phrasing (for example widgets vs widget).

Second, we’ve added a new `pub unpack` command. This offers a quick and easy way to download a package to your file system. This can be used, for example, if you want to run the example program of a package on your local machine:

```bash
$ dart pub unpack path
Downloading path 1.9.0 to `./path-1.9.0`...

$ cd path-1.9.0/example/

$ dart run example.dart
Current path style: posix
Current process path: /Users/mit/tmp/path-1.9.0/example
```


Third, we’ve added a new `pub downgrade --tighten` command. This can be used to check all the version constraints in a package’s dependencies. When run, it updates the lower constraint to the lowest version for which pub was able to do a resolution.

## Dart roadmap update

In addition to the completed features above, we’ve also done work across a large number of areas to make progress on our long-term roadmap.

## IDE and analyzer performance for large monorepos

A ‘monorepo’ is a common way of structuring the source code for a set of related packages and apps in a single repository, for example as in Flutter’s [packages repo](https://github.com/flutter/packages/tree/main). A monorepo isn’t just about the convenience of having all the source code “close together”, but can also be a critical tool to ensure that the individual packages & apps in the repo are mutually compatible.

We’ve heard consistent feedback from developers that work in large monorepos, that the performance of our tools, and specifically the analyzer, can be lacking. Our analysis of these issues suggests that the root issue is that we end up loading multiple overlapping analysis contexts for each package and ALL of its dependencies, leading to several copies of the analysis of each package in the monorepo in memory at the same time. We believe the fundamental solution is to create a single, shared resolution of the versions of each dependency in such repos, and are working on such a capability via a new pub feature called [workspaces](https://github.com/dart-lang/sdk/issues/53875). We’ll have much more to share about this in our next Dart release, but for now you can go ahead and see how this was [recently applied](https://github.com/flutter/engine/pull/54157/files) to the Flutter engine repo.

## Pub.dev package repository

Users of the pub.dev package repository have long requested improved metrics for [how used/downloaded](https://github.com/dart-lang/pub-dev/issues/2714) each package is. This can be helpful both for package authors as a signal of how many users are deriving benefit from their work, and for package consumers as a signal of what packages other developers are consuming. We’re happy to share that we’re making good progress on this capability, and hope to have it in preview by end of year.

## Dart native interop

For the Java and Kotlin interop with JNIgen, we expect to wrap up the core support and graduate from experimental to a stable version 1.0 over the next two quarters. For details, see the [JNIgen tracker](https://github.com/orgs/dart-lang/projects/69/). For ObjectiveC interop, we have a similar goal; see the [Objective-C tracker](https://github.com/orgs/dart-lang/projects/87).

Next up we’re investigating direct interop with Swift code. The initial experimentation looks promising, and we hope to have experimental support added early next year.

## Native interop and bundling of native source code

In many cases direct interop is used to call into APIs that are present in the operating system, which means the APIs are always available on those host platforms. However, in some cases the code that Dart is interoperating with is native *source code* not included directly on the host, which presents a practical challenge for package authors who use such interop: How do you get that native source code bundled and built without having to push a bunch of manual steps onto the consumers of the package? To support this, we’re exploring a [native assets system](https://github.com/dart-lang/sdk/issues/50565), which could support publishing Dart packages that contain native source code, along with a standardized protocol for enabling the `dart` and `flutter` CLI tools to automate the building and bundling of that source code. We envision that this will enable a new set of interoperability use cases, while at the same time offering an uncomplicated user experience for developers who use packages that rely on native source code.

## Dart language & macros

Most of our time in the Dart language and compiler teams is currently spent on making progress on the very large language feature macros, which we introduced in the [Dart 3.4 blog post](https://medium.com/dartlang/dart-3-4-bd8d23b4462a). As we said at the time, this is a huge undertaking, with the potential to cause regressions in some of our core use cases such as hot reload, so we’re taking a thorough approach, and will likely need several quarters of further work before we can share details of the next step.

In addition to macros, we’re also concurrently exploring a number of other smaller language features, as documented in the [Dart language funnel](https://github.com/orgs/dart-lang/projects/90/views/1).

Since last fall, we have been rewriting the Dart formatter. The old design worked well for many years, but with the success of Flutter, we want to move to [a new style](https://github.com/dart-lang/dart_style/issues/1253) that better works for the kind of declarative code that Flutter users often write. The old formatter wasn’t able to produce that kind of output. The rewrite is close to being done and will ship soon. If you’d like to try it out, pass the experiment flag `tall-style` ([flag instructions](https://dart.dev/tools/experiment-flags)). We welcome [feedback](https://github.com/dart-lang/dart_style/issues) if you see weird output.

## Closing

That’s all we have for today. We welcome your feedback, both on the roadmap items discussed, and on the new features in Dart 3.5, available from [Dart.dev](https://dart.dev/get-dart) or bundled in today’s [Flutter 3.24 release](https://medium.com/flutter/whats-new-in-flutter-3-24-6c040f87d1e4).