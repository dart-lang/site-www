---
title: "Announcing sound null safety"
description: "Make your apps more stable and performant with Dart’s null safety"
publishDate: 2020-06-10
author: "filiph"
image: images/1HKl1Jf0uBNP-gReYYcgC_g.png
category: announcements
tags:
  - programming-languages
  - dart
  - flutter
  - announcements
---


*By: [Filip Hracek](https://medium.com/@filiph) & [Michael Thomsen](https://medium.com/@mit.mit)*

Today is a major milestone for the Dart team with the tech preview of our null safety work. Null safety helps you avoid a class of bugs that are often hard to spot, and as an added bonus enables a range of performance improvements. We’re now releasing an early tech preview, and we’re looking forward to your feedback.

This post describes the Dart team’s plans for rolling out null safety. It also explains what we mean by *sound* null safety and **why that’s different from approaches that many other languages take.

## Why null safety?

Dart is a type-safe language. This means that when you get a variable of some type, the compiler can *guarantee* that it is of that type. But type safety by itself doesn’t guarantee that the variable is not `null`.

Null errors are very common. A search on GitHub leads to [thousands of issues](https://github.com/search?l=Dart&q=%22called+on+null%22&type=Issues) caused by nulls in Dart code, and even more [thousands of commits](https://github.com/search?l=Dart&q=%22called+on+null%22&type=Commits) trying to fix those issues.

Try to see if you can spot the nullability problems in the following example code:

```
void printLengths(List<File> files) {
  for (var file in files) {
    print(file.lengthSync());
  }
}
```


This function will certainly fail if called with `null`, but there’s a second case to consider:

```
void main() {
  // Error case 1: passing a null to files.
  printLengths(null);

  // Error case 2: passing list of files, containing a null item.
  printLengths([File('filename1'), File('filename2'), null]);
}
```


The null safety feature makes this problem go away:

<DashImage src="images/1HKl1Jf0uBNP-gReYYcgC_g.png" />


With null safety, you can reason about your code with more confidence. No more pesky runtime null dereferencing errors. Instead, you get static errors as you code.

## Sound null safety

Dart’s null safety is *sound*. This means that Dart is 100% sure that the `files` list, and the elements in it, cannot be `null` in the above example. When Dart analyzes your code and determines that a variable is non-nullable, that variable is *always* non-nullable: if you inspect your running code in the debugger, you’ll see that non-nullability is retained at runtime. By contrast, some other implementations are unsound, and in many cases still need to perform runtime null checks. Dart shares sound null safety with Swift, but not very many other programming languages.

The soundness of Dart’s null safety has another welcome implication: it means your programs can be smaller and faster. Because Dart is *really* sure that `files` is never `null`, Dart can optimize. For example, the Dart ahead-of-time (AOT) compiler can produce smaller and faster native code, because it doesn’t need to add checks for nulls when it *knows* that a variable isn’t `null`.

We’ve seen some very promising preliminary results. For example, we saw a [19% performance improvement](https://gist.github.com/a-siva/07e8a5bfa8548a3041d44d5d1c6f3a40) in a microbenchmark that emulates typical Flutter framework rendering patterns.

## Design principles

Before starting the detailed design for null safety, the Dart team defined the following three core principles:

* **Non-nullable by default.** Unless you explicitly tell Dart that a variable can be `null`, it will consider it non-nullable. We chose this as the default because we found that non-null was by far the most common choice in APIs.

* **Incrementally adoptable.** There’s a lot of Dart code out there. It must be possible to migrate to null safety incrementally, part by part. It should be possible to have null-safe and non-null-safe code in the same project. We’ll also provide tools to help you with the migration.

* **Fully sound.** As mentioned above, Dart’s null safety is sound. Once you migrate your whole project and your dependencies to null safety, you reap the full benefits of soundness.

## Declaring variables with null safety

The core syntax is simple enough. Here are some non-nullable variables, declared in different ways. Remember, non-nullable is the default, so these declarations look like they do today, but their meaning changes.

```
// In null-safe Dart, none of these can ever be null.
var i = 42;
final b = Foo();
String m = '';
```


Dart will make sure that you never assign `null` to any of the above variables. If you try to do `i = null` a thousand lines later, you’ll get a static analysis error and red squiggly lines, and your program will refuse to compile.

If you want your variable to be nullable, you can use `?`, like this:

```
// These are all nullable variables.
int? j = 1;  // Can be null later.
final Foo? c = getFoo();  // Maybe the function returns null.
String? n;  // Is null at first. Can be null at any later time, too.
```


The above variables behave the same way that all variables do today.

You can use the `?` syntax in other places, too:

```
// In function parameters.
void boogie(int? count) {
  // It's possible that count is null.
}

// In function return values.
Foo? getFoo() {
  // Can return null instead of Foo.
}

// Also: generics, typedefs, type checks, etc.
// And any combination of the above.
```


But, once again, the dream is that you’ll almost never have to use `?`. The vast majority of your types will be non-nullable.

## Making null safety easier to use

The Dart team is trying hard to make null safety as easy to use as possible. For example, look at this code, which uses `if` to check for a null value:

```
void honk(int? loudness) {
  if (loudness == null) {
    // No loudness specified, notify the developer
    // with maximum loudness.
    _playSound('error.wav', volume: 11);
    return;
  }

  // Loudness is non-null, let's just clamp it to acceptable levels.
  _playSound('honk.wav', volume: loudness.clamp(0, 11));
}
```


Note how Dart is smart enough to realize that by the time we pass that `if` statement, the `loudness` variable *cannot* be `null`. And so Dart lets us call the `clamp()` method without jumping through hoops. This convenience is enabled by something called *flow analysis*: the Dart analyzer goes through your code as if it was executing it, figuring out additional information about your code automatically.

Here’s another example, which shows a case where Dart can be sure that a variable is non-null because we always assign a non-null value to it:

```
int sign(int x) {
  // The result is non-nullable.
  int result;

  if (x >= 0) {
    result = 1;
  } else {
    result = -1;
  }

  // By this point, Dart knows the result cannot be null.
  return result;
}
```


If you remove any of the assignments above (for example, by deleting the `result = -1;` line), Dart cannot guarantee that `result` will be non-null: you’ll get a static error and your code won’t compile.

Flow analysis only works inside functions. If you have a global variable or a class field, then Dart can’t guarantee when it will be assigned what value. Dart can’t model the flow of your whole application. For that reason, you can use the new `late` keyword when you ***know*** that a variable will be non-null before you first read it, but you can’t initialize it immediately.

```
class Goo {
  late Viscosity v;

  Goo(Material m) {
    v = m.computeViscosity();
  }
}
```


Note that `v` is non-null, although it starts uninitialized. Dart trusts you that you won’t try to read `v` before it’s assigned a non-null value, and your code compiles without errors.

## Null safety is backwards compatible

The Dart team has been working for more than a year to get null safety to tech preview. It’s the largest addition to the Dart language since we introduced Dart 2. Yet, it’s not a breaking change. Existing code can call into code that uses null safety, and vice versa. Even after null safety is available, it will be an optional feature that you can adopt when you’re ready. **Your existing code will continue to run without change**.

We recently migrated the Dart [core libraries to fully use null safety](https://api.dart.dev/dev/2.9.0-13.0.dev/index.html). As an example of null safety’s backwards compatibility, we replaced the existing core libraries without any breakage in existing tests and test apps running in the Dart and Flutter test environments. We even rolled the new core libraries to our many internal Google customers, directly into their production code bases, without a hitch. We plan on migrating all of our packages and apps to use null safety when the feature launches, and we hope you’ll do the same. But you’ll be able to do it on your timeline, package by package, app by app.

## The null safety roadmap

We plan to roll out null safety gradually, in three steps:

1. **Tech preview.** This is ***launching today***, and is available in Dart’s [dev channel](https://dart.dev/get-dart#release-channels). See the “Try it now” section below for details. Things are still subject to change, so **don’t use null safety in production code** just yet. Do test things out and [give us feedback](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here), though!

1. **Beta release.** Null safety will be available in Dart’s beta channel, and no longer behind an [experimental flag](https://github.com/dart-lang/sdk/blob/master/docs/process/experimental-flags.md). The feature will be very close to the expected final version. If you own a [pub.dev](https://pub.dev/) package or plugin, this is when you can begin migrating, but you shouldn’t publish it as a stable version just yet.

1. **Stable release.** Everyone will have null safety, and you’ll be encouraged to publish your migrated packages and plugins as stable versions. You should also migrate your production apps.

If all goes well, we plan to release null safety as a stable feature before the end of the year. Between now and then, we’ll add tooling to help you make your code null safe, including:

* A migration tool to support you in automating many of the steps for upgrading existing packages and apps

* Tags on [pub.dev](https://pub.dev), so you can tell if a package supports null safety or not

* An extension to the [`pub outdated`](https://dart.dev/tools/pub/cmd/pub-outdated) command, with support for finding the latest versions of your dependencies that support null safety

## Try it now

The quickest way to try null safety today is through [nullsafety.dartpad.dev](https://nullsafety.dartpad.dev/3d9c1769de7912c654bc5d132aff60ac), a version of DartPad with null safety enabled. Open the **Learn with Snippets** drop-down to find a series of learning exercises that walk through the new syntax and basics of null safety.

<DashImage src="images/07alHbKGJ1FoeNqII.png" />


You can also try null safety in small command-line apps. (We haven’t migrated larger frameworks like Flutter yet.) Start by downloading a copy of the [dev-channel Dart SDK](https://github.com/dart-lang/samples/blob/master/null_safety/calculate_lix/README.md#dart-preview-sdk-installation), and then get a copy of [this sample Dart CLI app](https://github.com/dart-lang/samples/tree/master/null_safety/calculate_lix) ([GitHub repo](https://github.com/dart-lang/samples), [zip archive](https://github.com/dart-lang/samples/archive/master.zip)). The sample app’s [README file](https://github.com/dart-lang/samples/blob/master/null_safety/calculate_lix/README.md) has instructions for running the app with the null safety experiment flag. Other files in the sample provide launch configurations that enable debugging in VS Code and Android Studio.

We also have documentation, with plans to produce more:

* [Null safety guide](https://dart.dev/null-safety)

* [API reference for core libraries with null safety](https://api.dart.dev/dev/2.9.0-13.0.dev/index.html)

We’re very happy to bring null safety to Dart. Sound null safety is a distinctive feature of Dart that helps you write less error-prone code and get better performance. We hope you’ll experiment with the feature in tech preview, and [give us feedback](https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here) through our issue tracker. Happy coding!