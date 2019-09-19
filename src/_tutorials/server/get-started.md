---
title: "Get started: command-line and server apps"
description: Get Dart, run and compile a small app
nextpage:
  url: /tutorials/server/cmdline
  title: Write command-line apps
prevpage:
  url: /tutorials/server
  title: Dart command-line and server tutorials
---

Follow these steps to start using the Dart SDK to develop command-line and server apps.
First you’ll play with the Dart language and libraries in your browser, no download required.
Then you’ll install the Dart SDK, write a small program, and run that program using the Dart VM.
Finally, you'll use an AOT (_ahead of time_) compiler to compile your finished program to native machine code,
which you'll execute using the Dart runtime.

## 1. Play with Dart code in DartPad

With DartPad you can experiment with the Dart language and APIs,
no download necessary.

For example, here's an embedded DartPad that lets you play with the code for a
small Hello World program. Click **Run** to run the app; the console output
appears beneath the code. Try editing the source code—perhaps you'd like to
change the greeting to use another language. To get the full DartPad experience,
<a href="{{site.dartpad}}/27e044ec9e2957d9c5c7062871ce8bf3" target="_blank">open
the example at dartpad.dev.</a>

<iframe
    src="{{site.custom.dartpadx.embed-inline-prefix}}?id=27e044ec9e2957d9c5c7062871ce8bf3"
    width="100%"
    height="300px"
    style="border: 1px solid #ccc;">
</iframe>

More information:

* [DartPad documentation][]
* [Dart language tour][]
* [Dart library tour][]

## 2. Install Dart

{% include get-sdk.md %}

## 3. Get more command-line developer tools

Install [`stagehand`,][stagehand] which gives you templates for creating Dart apps:

```terminal
$ pub global activate stagehand
```

Note that although these instructions feature the command line,
many IDEs support Dart development.
Those IDEs use Stagehand behind the scenes when you create new Dart projects.

More information:

* [Dart tools](/tools)
* [Running a script from your path](/tools/pub/cmd/pub-global#running-a-script-from-your-path)

## 4. Create a small app

Create a command-line app:

```terminal
$ mkdir cli
$ cd cli
$ stagehand console-full
```

These commands create a small Dart app that has the following:

* A main Dart source file, `bin/main.dart`, that contains a top-level
  `main()` function. This is the entrypoint for your app.
* An additional Dart file, `lib/cli.dart`, that contains the functionality of
  the app and is imported by the `main.dart` file.
* A pubspec file, `pubspec.yaml`, that contains the app's metadata, including
  information about which [packages](/guides/packages) the app depends on
  and which versions of those packages are required.

## 5. Get the app's dependencies

Use the [`pub`](/tools/pub/cmd) command to get the packages
that the app depends on:

```terminal
$ pub get
```

## 6. Run the app

To run the app from the command line, use the Dart VM by running the
[`dart`](/tools/dart-vm) command:

```terminal
$ dart bin/main.dart
Hello world: 42!
```

## 7. Modify the app

Let's customize the app you just created.

 1. Edit `lib/cli.dart` to calculate a different result. For example, divide the
    previous value by two (operator details, see [Arithmetic operators][]):

    <?code-excerpt "misc/test/tutorial/get_started.dart (calculate)" replace="/~\/ 2/[!$&!]/g"?>
    {% prettify dart %}
    int calculate() {
      return 6 * 7 [!~/ 2!];
    }
    {% endprettify %}

 1. Save your changes.

 1. Rerun the main entrypoint of your app:

    ```terminal
    $ dart bin/main.dart
    Hello world: 21!
    ```

More information:
[Write command-line apps](/tutorials/server/cmdline)

## 8. Compile for production

The steps above used the Dart VM (`dart`) to run the app. The Dart VM is
optimized for fast, incremental compilation to provide instant feedback
during development. Now that your small app is done, it's time to AOT compile your
Dart code to optimized native machine code.

Use the `dart2aot` tool to AOT compile the program to machine code:

```terminal
$ dart2aot bin/main.dart bin/main.dart.aot
```

To run the compiled program, use the Dart runtime (`dartaotruntime`):

```terminal
$ dartaotruntime bin/main.dart.aot
Hello world: 21!
```

Notice how the compiled program starts instantly, completing quickly:

```terminal
$ time dartaotruntime bin/main.dart.aot
Hello world: 21!

real	0m0.016s
user	0m0.008s
sys	0m0.006s
```

## What next?

Check out these resources:

* Additional tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Sample code](/samples)
  * [Language tour](/guides/language/language-tour)
  * [Library tour](/guides/libraries/library-tour)
  * [Effective Dart](/guides/language/effective-dart)
* Tools and libraries
  * [Dart SDK](/tools/sdk)
  * [Dart tools](/tools)
  * [IDEs](/tools#ides-and-editors)

If you get stuck, find help at [Community and support.](/community)

[Arithmetic operators]: /guides/language/language-tour#arithmetic-operators
[stagehand]: {{site.pub-pkg}}/stagehand
[DartPad documentation]: /tools/dartpad
[Dart language tour]: /guides/language/language-tour
[Dart library tour]: /guides/libraries/library-tour
[ide]: /tools#ides-and-editors
