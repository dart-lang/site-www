---
title: "Announcing Dart 2.15"
description: "Fast concurrency, constructor tear-offs, improved enums, and more"
publishDate: 2021-12-08
author: "mit-mit"
image: images/196RfgLO4RYR2ReAs8t6x5w.png
category: announcements
tags:
  - dart
  - announcements
  - programming
---


Today we’re releasing version 2.15 of the Dart SDK, featuring fast concurrency with worker isolates, a new constructor tear-off language feature, improved enum support in the dart:core library, new features for package publishers, and more.

<DashImage src="images/196RfgLO4RYR2ReAs8t6x5w.png" />


## Fast concurrency with worker isolates

Just about all modern devices have CPUs with multiple cores, capable of running multiple tasks in parallel. For most Dart programs, how these cores are used is transparent to you as a developer: the Dart runtime system by default runs all your Dart code on a single core, but then uses additional cores for executing systems-level tasks such as async input/output, like writing a file or making a network call.

But your Dart code itself may need to run concurrently. For example, you may have a continuous animation and a long-running task such as parsing a large JSON file. If the additional task takes too long, that might cause stutter or lag in the UI. By moving those additional tasks to a separate core, the animation can continue to run on the main thread of execution, uninterrupted.

Dart’s model for concurrency is based on [isolates](https://dart.dev/guides/language/concurrency) — independent units of execution that are isolated from one another — to prevent a large class of concurrency programming bugs related to shared memory, such as [*race conditions* like data races](https://en.wikipedia.org/wiki/Race_condition#In_software). Dart prevents these bugs by not allowing any mutable objects to be shared between isolates, and instead uses a model where isolates exchange state using [*message passing*](https://dart.dev/guides/language/concurrency#sending-multiple-messages-between-isolates). In Dart 2.15 we’ve made a number of substantial enhancements to isolates.

We started by redesigning and reimplementing how isolates work, introducing a new concept: *isolate groups.* Isolates in an isolate group share various internal data structures representing the running program*.* This makes individual isolates in the group much cheaper. It is now more than 100 times faster to start an additional isolate in an existing isolate group as we don’t need to initialize the program structures, and those spawned isolates consume between 10–100 times less memory.

While isolate groups still prevent shared access to mutable objects between isolates, the group is implemented with a shared heap, which unlocks further capabilities. We can pass objects from one isolate to another, which can be used for worker isolates that perform a task that returns a large piece of memory. An example is a worker isolate that makes a network call to get data, parses that data into a large JSON object graph, and then returns that JSON graph to the main isolate. Before Dart 2.15, that result needed to be deep-copied, which could itself cause UI jank if the copy took longer than the frame budget.

In 2.15 the worker isolate can call [`Isolate.exit()`](https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate/exit.html), passing its result as an argument. The Dart runtime then passes the memory containing the result from the worker isolate to the main isolate without copying, and the main isolate can receive the result in constant time. We’ve updated the [`compute()`](https://api.flutter.dev/flutter/foundation/compute-constant.html) utility function in [Flutter 2.8 ](https://medium.com/flutter/whats-new-in-flutter-2-8-d085b763d181)to take advantage of `Isolate.exit()`. If you’re already using `compute()`, then you’ll get these performance gains automatically after upgrading to Flutter 2.8.

Finally, we’ve reworked how the isolate message passing mechanism is implemented, making passing of small-to-medium sized messages approximately 8 times faster. Sending is significantly faster, and receiving messages is almost always done in constant time. We’ve also expanded the kinds of objects that isolates can send to each other, adding support for function types, closures, and stacktrace objects. For details, see the API docs for [`SendPort.send()`](https://api.dart.dev/stable/2.15.0/dart-isolate/SendPort/send.html).

To learn more about how to use isolates, see the new [*Concurrency in Dart*](https://dart.dev/guides/language/concurrency) documentation we added for 2.15. We also have a number of [code samples](https://github.com/dart-lang/samples/tree/master/isolates) you can check out.

## New language feature: Constructor tear-offs

In Dart you can create a function object, which points to a function on another object, by using the function’s name. In the following example, the second line of the main() method illustrates this syntax when it sets `g` to `m.greet`:

```
class Greeter {
  final String name;
  Greeter(this.name);
  
  void greet(String who) {
    print('$name says: Hello $who!');
  }
}

void main() {
  final m = Greeter('Michael');
  final g = m.greet; // g holds a function pointer to m.greet.
  g('Leaf'); // Invokes and prints "Michael says: Hello Leaf!"
}
```


Such function pointers — also referred to as function *tear-offs* — appear frequently when using the Dart core libraries. Here’s an example of calling `foreach()` on an iterable by passing it a function pointer:

```
final m = Greeter('Michael');

['Lasse', 'Bob', 'Erik'].forEach(m.greet);

// Prints "Michael says: Hello Lasse!", "Michael says: Hello Bob!",
// "Michael says: Hello Erik!"
```


Historically we haven’t supported creating tear-offs from a constructor (language issue [#216](https://github.com/dart-lang/language/issues/216)). That’s annoying because in many cases — for example, when building Flutter UIs — a constructor tear-off is what you need. As of Dart 2.15, this syntax is now supported. Here’s an example of building a `Column` widget containing three `Text` widgets, by calling `.map()` and passing it a tear-off to the constructor of `Text`.

```
class FruitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: ['Apple', 'Orange'].map(Text.new).toList());
  }
}
```


`Text.new` refers to the default constructor of the `Text` class. You can also refer to a named constructor — for example, `.map(Text.rich)`.

## Related language changes

While we were implementing constructor tear-offs, we took the opportunity to fix some inconsistencies in our existing support for function pointers. You can now specialize a generic method to create a non-generic method:

```
T id<T>(T value) => value;
var intId = id<int>; // New in 2.15.
int Function(int) intId = id; // Pre-2.15 workaround.
```


You can even specialize a generic function object to create a non-generic function object:

```
const fo = id; // Tear off `id`, creating a function object.
const c1 = fo<int>; // New in 2.15; error before.
```


Lastly, we cleaned up type literals involving generics:

```
var y = List; // Already supported.
var z = List<int>; // New in 2.15.
var z = typeOf<List<int>>(); // Pre-2.15 workaround.
```


## Improved enums in the dart:core library

We’ve made a number of convenience additions to the enum APIs in the dart:core library (language issue [#1511](https://github.com/dart-lang/language/issues/1511)). You can now get the `String` value for each enum value using `.name`:

```
enum MyEnum {
  one, two, three
}

void main() {
  print(MyEnum.one.name);  // Prints "one".
}
```


You can also look up an enum value by name:

```
print(MyEnum.values.byName('two') == MyEnum.two);  // Prints "true".
```


Finally, you can get a map of all name-value pairs:

```
final map = MyEnum.values.asNameMap(); 
print(map['three'] == MyEnum.three);  // Prints "true".
```


For an example of using these new APIs, see [this Flutter PR](https://github.com/flutter/flutter/pull/94496/files).

## Compressed pointers

Dart 2.15 adds support for compressed pointers, a technique where a 64-bit SDK can use a more space-efficient representation of pointers if only a 32-bit address space needs to be supported (up to 4 GB of memory). Compressed pointers result in a significant memory reduction; in our internal testing with the GPay app, we saw an approximately 10% reduction of the Dart heap size.

Because compressed pointers imply not being able to address any available RAM above 4 GB, the feature is behind a configuration option in the Dart SDK that can only be toggled by embedders of the Dart SDK when the SDK is built. The Flutter SDK version 2.8 has enabled this configuration for Android builds, and the Flutter team is considering also [enabling it for iOS](https://github.com/flutter/flutter/issues/94753) builds in a future release.

## Dart DevTools included in the Dart SDK

The [DevTools suite](https://dart.dev/tools/dart-devtools#) of debugging and performance tools previously wasn’t in the Dart SDK; you had to download it separately. Starting with Dart 2.15, you now get DevTools when you download the Dart SDK, with no further installation steps required. For more information on using DevTools with Dart command-line apps, see the [DevTools documentation](https://dart.dev/tools/dart-devtools#using-devtools-with-a-command-line-app).

## New pub features for package publishers

Dart 2.15 SDK also has two new features in the `dart pub` developer command and the [pub.dev](https://pub.dev) package repository.

First, there’s a new security feature for package publishers. The aim is to detect when a publisher accidentally publishes secrets — for example Cloud or CI credentials — inside pub packages. We were inspired to add this leak detection after learning that inside GitHub repositories, thousands of secrets are [leaked every day](https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf).

Leak detection runs as part of the pre-publish validation run in the `dart pub publish` command. If it detects a potential secret in the files about to be published, the `publish` command exits without publishing, and prints output like this:

```
Publishing my_package 1.0.0 to [https://pub.dartlang.org](https://pub.dartlang.org):
Package validation found the following errors:
* line 1, column 1 of lib/key.pem: Potential leak of Private Key detected.
╷
1 │ ┌ - - -BEGIN PRIVATE KEY - - -
2 │ │ H0M6xpM2q+53wmsN/eYLdgtjgBd3DBmHtPilCkiFICXyaA8z9LkJ
3 │ └ - - -END PRIVATE KEY - - -
╵
* line 2, column 23 of lib/my_package.dart: Potential leak of Google OAuth Refresh Token detected.
╷
2 │ final refreshToken = "1//042ys8uoFwZrkCgYIARAAGAQSNwF-L9IrXmFYE-sfKefSpoCnyqEcsHX97Y90KY-p8TPYPPnY2IPgRXdy0QeVw7URuF5u9oUeIF0";
```


On rare occasions this detection might have false positives, flagging potential leaks for content or files that you do in fact intend to publish. In those cases, you can add the files to an [allowlist](https://dart.dev/go/false-secrets).

Second, we’ve added another feature for publishers that supports retracting a package version that’s already been published. When a faulty package version is published, we usually recommend publishing a new version with a minor increment that fixes the unintended issue. In rare cases — for example when you don’t have such a fix yet, or where you accidentally published a new major version but intended to publish a new minor version — you can use the new [package retraction feature](https://dart.dev/go/package-retraction) as a last resort. This functionality is available in the Admin UI on pub.dev:

<DashImage src="images/19KDYm1R4x6D4S-mzL-QE2g.png" />


When a package version is retracted, the pub client no longer resolves to that version in `pub get` or `pub upgrade`. If any developers have already resolved to the retracted version (and it’s thus in their `pubspec.lock` file), they’ll see a warning the next time they run `pub`:

```
$ dart pub get
Resolving dependencies…
mypkg 0.0.181-buggy (retracted, 0.0.182-fixed available)
Got dependencies!
```


## Security analysis for detecting bidirectional Unicode characters (CVE-2021–22567)

Recently a general programming language vulnerability was discovered involving bidirectional Unicode characters ([CVE-2021–42574](https://nvd.nist.gov/vuln/detail/CVE-2021-42574)). This vulnerability affects most modern programming languages that support Unicode. The following Dart source code illustrates the problem:

```
main() {
  final accessLevel = 'user';

  if (accessLevel == 'user‮ .⁦// Check if admin⁩ ⁦') {
    print('You are a regular user.');
  } else {
    print('You are an admin.');
  }
}
```


You’d probably think that this program prints *You are a regular user.*, but it might in fact print *You are an admin.*! This exploit is possible by using a string containing bidirectional Unicode characters. These are characters that change the direction of the text from left-to-right to right-to-left and back, all within a single line. With bidirectional characters, the text can render onscreen quite differently from the actual text contents. You can see an example of this in [this GitHub code gist](https://gist.github.com/mit-mit/7dda00ca6278ce7d2555f78d59d9e67b?h=1).

Mitigations against this vulnerability include using tools (editors, code review tools, etc.) that detect bidirectional Unicode characters, so that a developer can be made aware of them, and knowingly accept their use. The GitHub gist file viewer linked to above is one example of a tool that reveals these characters.

Dart 2.15 introduces one further mitigation (Dart security advisory [CVE-2021–22567](https://github.com/dart-lang/sdk/security/advisories/GHSA-8pcp-6qc9-rqmv)): the Dart analyzer now scans for bidirectional Unicode characters, and flags any use of them:

```
$ dart analyze
Analyzing cvetest...                   2.6s

info • bin/cvetest.dart:4:27 • The Unicode code point 'U+202E'
       changes the appearance of text from how it's interpreted
       by the compiler. Try removing the code point or using the 
       Unicode escape sequence '\u202E'. •
       text_direction_code_point_in_literal
```


We recommend replacing these characters by Unicode escape sequences, so that they’re visible in any text editor or viewer. Alternatively, if you do have a legitimate use of these characters, you can disable the warning by adding an override in the line preceding the use:

```
// ignore: text_direction_code_point_in_literal
```


## Pub.dev credentials vulnerability when using third-party pub servers (CVE-2021–22568)

We’re also publishing a second pub.dev-related Dart security advisory: [CVE-2021–22568](https://github.com/dart-lang/sdk/security/advisories/GHSA-r32f-vhjp-qhj7). This advisory is targeted at package publishers who may have published packages to third-party pub package servers, such as private or company-internal package servers. Developers who publish only to the public pub.dev repository (the standard configuration) are **not affected** by this vulnerability.

If you’ve published to a third-party repository, the vulnerability is that the OAuth2 temporary (one-hour) access token presented for authentication at that third-party repository can be misused to authenticate against the public pub.dev repository. Thus a malicious third-party pub server might use an access token to impersonate you on pub.dev and publish packages there. If you’ve published a package to an untrusted third-party package repository, consider doing an audit of all your account activity on the pub.dev public package repository. You can use the [pub.dev activity log](https://pub.dev/my-activity-log) for this purpose.

## Closing comments

We hope that you’ll enjoy the new features in Dart 2.15, [available today](https://dart.dev/get-dart). This is our last release of the year, and we’d like to take the chance to express our gratitude for the wonderful Dart ecosystem. Thanks for all the great feedback, for your continued support as witnessed by our continued growth, and for extending our ecosystem with thousands of packages published on [pub.dev](https://pub.dev) over the past year. We can’t wait to get back to it next year, and we have lots of exciting things planned for 2022. Until then, enjoy the holidays!