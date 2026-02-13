---
title: "Announcing Dart 2.13"
description: "New type aliases language feature, improved Dart FFI"
publishDate: 2021-05-19
author: "mit-mit"
image: images/1qMQKtkRNuvBjORjoJrN2bQ.png
category: announcements
tags:
  - dart
  - announcements
  - programming
---


<DashImage src="images/1qMQKtkRNuvBjORjoJrN2bQ.png" />


*By Kevin Moore & Michael Thomsen*

Today we’re announcing Dart 2.13, featuring *type aliases* — currently our second most requested language feature. Dart 2.13 also includes improved Dart FFI and better performance, and we have new Docker Official Images for Dart. This post gives an update on the null safety feature introduced in 2.12, discusses the new 2.13 features, has some exciting news about Docker and Google Cloud support for Dart backends, and previews some changes that you can expect to see in future releases.

## Null safety update

We launched [sound null safety](https://dart.dev/null-safety) in March in the [Dart 2.12](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87) release. Null safety is Dart’s latest major productivity feature, intended to help you avoid null errors — a class of bugs that are often hard to spot. With that launch we encouraged package publishers to start migrating shared packages on pub.dev to null safety.

We’ve been extremely pleased to see how quickly null safety has been adopted! Just a few months after launch, **93% of the top-500 most popular packages on pub.dev already support null safety**. We’d like to extend our sincere thanks to all package developers for doing this work so quickly, and for helping the entire ecosystem to move forward!

With so many packages supporting null safety, there’s a good chance that you can begin to migrate your apps to use null safety. The first step is to use `dart pub outdated` to check your app’s dependencies. For details, see the [null safety migration guide](https://dart.dev/null-safety/migration-guide#step1-wait). We’ve also changed our `dart create` and `flutter create` templates so that they now enable null safety by default in new apps and packages.

## Announcing type aliases

Type aliases is a new feature in the 2.13 language. It extends our earlier support, which allowed for creating type aliases of function types, but not any other types. This highly sought-after feature was the second highest [rated](https://github.com/dart-lang/language/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) in the language issue tracker.

Using a type alias you can create a new name for any existing type, which can then be used anywhere the original type could be used. You aren’t really defining a new type, just introducing a short-hand alias. The alias even passes type equality tests:

```
typedef Integer = int;

void main() {
  print(int == Integer); // true
}
```


So what can you use type aliases for? One common use is to give a shorter or more descriptive name to a type, making your code more readable and maintainable.

A good example is working with JSON (thanks to GitHub user [Levi-Lesches](https://github.com/Levi-Lesches) for this example). Here we can define a new type alias `Json`, which describes a JSON document as a map from `String` keys to any value (using the `dynamic` type). Then we can use that `Json` type alias when defining our `fromJson` named constructor and `json` getter.

```
typedef Json = Map<String, dynamic>;

class User {
  final String name;
  final int age;

  User.fromJson(Json json) :
    name = json['name'],
    age = json['age'];

Json get json => {
    'name': name,
    'age': age,
  };
}
```


You can also call constructors on a type alias that names a class, so the following is perfectly legal:

```
main() {
  var j = Json();
  j['name'] = 'Michael';
}
```


By using type aliases to give names to complex types, you can make it easier for readers to understand the invariants of your code. For example, the following code defines a type alias to describe maps that contain keys of generic type `X` and values of type `List&lt;X&gt;`. By giving the type a name with a single type parameter, the regular structure of the map becomes more apparent to the reader of the code.

```
typedef MapToList<X> = Map<X, List<X>>;
void main() {
  MapToList<int> m = {};
  m[7] = [7]; // OK
  m[8] = [2, 2, 2]; // OK
  for (var x in m.keys) {
    print('$x --> ${m[x]}');
  }
}

=>

7 --> [7]
8 --> [2, 2, 2]
```


If you try to use types that don’t match, you’ll get an analysis error:

```
m[42] = ['The', 'meaning', 'of', 'life'];

=>

The element type 'String' can't be assigned to the list type 'int'.
```


You can even use type aliases when renaming classes in public libraries. Imagine you have an existing class `PoorlyNamedClass` in a public library that you want to rename to `BetterNamedClass`. If you simply rename the class, then your API customers will get sudden compilation errors. With type aliases you can go ahead and do the rename, but then define a new type alias for the old class name, and then add a `@Deprecated` annotation for the old name. Uses of `PoorlyNamedClass` will then cause a warning when used, but will continue to compile and work as before, giving users time to upgrade their code.

Here’s how you might implement `BetterNamedClass` and deprecate `PoorlyNamedClass` (in a file named `mylibrary.dart`):

```
class BetterNamedClass {...}

@Deprecated('Use BetterNamedClass instead')
typedef PoorlyNamedClass = BetterNamedClass;
```


And here’s what happens what someone tries to use `PoorlyNamedClass`:

```
import 'mylibrary.dart';

void main() {
  PoorlyNamedClass p;
}

=>

'PoorlyNamedClass' is deprecated and shouldn't be used. Use BetterNamedClass instead.
```


The type alias feature is available starting with Dart 2.13. To enable it, set the lower Dart SDK constraint in your pubspec to at least 2.13:

```
environment:
  sdk: ">=2.13.0 <3.0.0"
```


This feature is backward compatible, thanks to [language versioning](https://dart.dev/guides/language/evolution#language-versioning). Packages with lower SDK constraints under 2.13 can safely refer to type aliases defined in 2.13 packages, even though pre-2.13 packages can’t define their own type aliases.

## Dart 2.13 FFI changes

We also have a couple of new features in Dart FFI, our interop mechanism for calling C code.

First, FFI now supports structs that have inline arrays ([#35763](https://github.com/dart-lang/sdk/issues/35763)). Consider a C struct with an inline array like this:

```
struct MyStruct {
  uint8_t arr[8];
}
```


You can now wrap that in Dart directly, specifying the element type with a type argument to `Array`:

```
class StructInlineArray extends Struct {
  [@Array](http://twitter.com/Array)(8)
  external Array<Uint8> arr;
}
```


Second, FFI now supports packed structs ([#38158](https://github.com/dart-lang/sdk/issues/38158)). Normally structs are laid out in memory so that members fall in address boundaries that are easier to access for the CPU. With [packed structs](http://www.catb.org/esr/structure-packing/) some of this padding is omitted to lower overall memory consumption, often in platform-specific ways. With the new `@Packed(&lt;alignment&gt;)` annotation, you can easily specify the padding. For example, the following code creates a struct that has 4-byte alignment when it’s in memory:

```
[@Packed](http://twitter.com/Packed)(4)
class TASKDIALOGCONFIG extends Struct {
  [@Uint32](http://twitter.com/Uint32)()
  external int cbSize;
  [@IntPtr](http://twitter.com/IntPtr)()
  external int hwndParent;
  [@IntPtr](http://twitter.com/IntPtr)()
  external int hInstance;
  [@Uint32](http://twitter.com/Uint32)()
  external int dwFlags;
  ...
}
```


## Dart 2.13 performance changes

We’re continuing to work on reducing the application size and memory footprint of Dart code. In large Flutter applications, internal structures representing metadata of an AOT-compiled Dart program might occupy a sizable chunk of memory. Most of this metadata is present to enable features like hot reload, interactive debugging, and formatting of human-readable stack traces — features that are never used in deployed applications. Over the previous year we’ve been restructuring the Dart native runtime to eliminate as much of this overhead as possible. Some of these improvements apply to all Flutter applications built in release mode, but some require you to forgo human-readable stack traces by splitting debug information out of AOT-compiled applications using the [`--split-debug-info`](https://flutter.dev/docs/perf/app-size#reducing-app-size) flag.

Dart 2.13 includes a number of changes that significantly reduce the space occupied by program metadata when `--split-debug-info` is used. Take as an example the Flutter Gallery app. On Android the release APK is 112.4 MB with debug information, and 106.7 MB without it (a 5% overall reduction). This APK contains a lot of assets. Looking just at the code metadata inside the APK, it was reduced from 5.7MB in Dart 2.12 and only 3.7MB in Dart 2.13 (a 35% reduction).

If app size and memory footprint are important to you, consider omitting the debug information using the `--split-debug-info` flag. Note that when doing so you’ll need to use the [`symbolize`](https://flutter.dev/docs/deployment/obfuscate#reading-an-obfuscated-stack-trace) command to make the stack traces human readable again.

## Official Docker support and Dart on Google Cloud

Dart is now available as [Docker Official Images](https://docs.docker.com/docker-hub/official_images/). While Dart has provided Docker images for years, these [new Dart images](https://hub.docker.com/_/dart) are tested and validated by Docker to follow best practices. They also support ahead-of-time (AOT) compilation, which can dramatically reduce the size of built containers and can improve the speed of deployment in container environments — like [Cloud Run](https://cloud.google.com/run).

While Dart remains focused on enabling app frameworks like Flutter to drive beautiful pixels across every screen, we realize that behind most user experiences is at least one hosted service. By making it easy to build backend services with Dart, we support a full stack experience that lets developers extend their application to the cloud using the same language and business logic they use to power widgets on the frontend.

In general, using Dart for Flutter app backends is an especially good fit for the simplicity and scalability of Google’s managed serverless platform, Cloud Run. This includes scale-to-zero, which means you don’t incur costs when your backend isn’t handling any requests. We work with the Google Cloud team to provide the [Functions Framework for Dart](https://pub.dev/packages/functions_framework), a collection of packages, tools, and examples that make it easy to write Dart functions to deploy instead of full servers for handling HTTP requests and CloudEvents.

Check out our [Google Cloud docs](https://dart.dev/server/google-cloud) to get started.

## A few words about what’s next

We’re already working on some exciting changes for upcoming releases. As always, you can use the [language funnel](https://github.com/dart-lang/language/projects/1) tracker to keep an eye on our progress.

One area we’re working on is a new set of canonical lints for both Dart and Flutter. Lints are a powerful way to configure Dart [static analysis](https://dart.dev/guides/language/analysis-options), but with hundreds of possible lints to toggle on or off, it can be hard to decide on what to choose. We’re currently working on defining two canonical sets of lints that we’ll apply by default in Dart and Flutter projects. We expect this to be enabled by default in the next stable release. If you’d like a preview, checkout the two packages [lints](https://pub.dev/packages/lints) and [flutter_lints](https://pub.dev/packages/flutter_lints).

Finally, if you do deep embedding of the Dart VM runtime, please note that we’re planning to deprecate the existing mechanism for this. We’ll replace it with a faster, more flexible model based on Dart FFI (see tracking issue [#45451](https://github.com/dart-lang/sdk/issues/45451)).

## Dart 2.13 is available now

Dart 2.13, with type aliases and improved FFI, is available today in the [Dart 2.13](https://dart.dev/get-dart) and [Flutter 2.2](https://flutter.dev/docs/get-started/) SDKs.

If you’ve been waiting for your dependencies to migrate to null safety, you might want to check again, using `dart pub outdated`. With 93% of the top-500 most popular packages already migrated, there’s a good chance that you’re unblocked. We’d also like to extend a big thanks to developers who’ve already migrated!

We’d love to hear about your experience with the new features and changes discussed in this blog post. Leave a comment below or tweet us [@dart_lang](https://twitter.com/dart_lang).