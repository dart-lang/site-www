---
title: "Get started: command-line & server apps"
description: Get Dart, run and compile a small app
toc: true
nextpage:
  url: /tutorials/server/cmdline
  title: Write command-line apps
prevpage:
  url: /tutorials/server
  title: Dart command-line and server tutorials
---

Follow these steps to start using Dart to develop command-line & server apps.
First you’ll play with Dart in your browser, no download required. Then you’ll
install Dart and run a small program with the Dart VM. Finally, you'll
AOT-compile that program to native machine code.

## 1. Play with a command-line app in DartPad

With DartPad you can experiment with the Dart language and APIs,
no download necessary.

For example, here's an embedded DartPad that lets you play with
the code for a small Hello World program.
Click run {% asset red-run.png alt="" %} to run the app;
the console output appears beneath the code.
Try editing the source code—perhaps you'd like to change the greeting
to use another language. To get the full DartPad experience,
which includes the web UI that the app produces,
<a href="https://dartpad.dartlang.org/27e044ec9e2957d9c5c7062871ce8bf3"
   target="_blank">open the example at dartpad.dartlang.org.</a>

<iframe
    src="{{site.custom.dartpad.embed-inline-prefix}}?id=27e044ec9e2957d9c5c7062871ce8bf3&verticalRatio=70"
    width="100%"
    height="200px"
    style="border: 1px solid #ccc;">
</iframe>

More information:

* [DartPad documentation][]
* [Dart language tour][]
* [Dart library tour][]

## 2. Install Dart

As you install, **note the path to the SDK.**
You'll need it in step 3.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
  Use [Chocolatey](https://chocolatey.org) to install a {{channel}} release of
  the Dart SDK:
  ```terminal
  C:\> choco install dart-sdk {%-if isDev%} --pre {%-endif%}
  ```
</div>

<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
  You can use Aptitude to install the Dart SDK on Linux.

   1. Perform the following one-time setup:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install apt-transport-https
      > sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
      {% if isStable -%}
      > sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
      {% else -%}
      ```
      Set up Dart **{{site.data.pkg-vers.SDK.channel}} channel**:
      ```terminal
      > sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
      {% endif -%}
      ```
   2. Install the Dart SDK:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install dart
      ```
</div>

<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
  With [Homebrew](http://brew.sh/),
  installing Dart is easy.

  ```terminal
  > brew tap dart-lang/dart
  {% if isStable -%}
  > brew install dart
  {% else -%}
  ```
  Get **{{site.data.pkg-vers.SDK.channel}} channel** release:
  ```terminal
  > brew install dart --devel
  {% endif -%}
  ```
</div>

More information: [Install the SDK](/tools/sdk#install)


## 3. Get command-line developer tools

Install [`stagehand`][stagehand], used for creating Dart apps from a set of
templates´:

```terminal
> pub global activate stagehand
```

More information, incl. tips for IDEs that support Dart native: [Dart
tools](/tools).

## 4. Create a small app

To create a command-line app and retrive all it's dependencies, use these
commands:

```terminal
> mkdir quickstart
> cd quickstart
> stagehand console-full
> pub get
```

This creates a minimal Dart app that has the following:

* One main Dart source file: `bin/main.dart`. This contains one top-level
  `main()` function. This is the entry point for your app.
* One additional Dart file: `lib/cli.dart`. This contains the functionality of
  the app, and is imported by the `main.dart` file.
* One `pubspec.yaml` file. This contains the app's metadata, including
  information about which [packages](/tools/pub/get-started) the app depends on
  and which versions of those packages are required.

## 5. Run the app

First we need to get the dependencies of the app using the
[`pub`](/tools/pub/cmd) command:

```terminal
> pub get
```

To run the app from the command line, use the Dart VM by running the
[`dart`][/tools/dart-vm] command:

```terminal
> dart bin/main.dart
Hello world: 42!
```

## 6. Add custom code to the app

Let's customize the app you just created:

 1. Edit `lib/cli.dart` to return a different result:

    ```dart
    int calculate() {
      return -1;
    }
    ```
 1. Save your changes.

 1. Re-run the main entry-point of your app:

    ```terminal
    > dart bin/main.dart
    Hello world: -1
    ```

More information:
[Write Command-Line Apps](/tutorials/server/cmdline)

## 7. Use DevTools to debug the app

If you wish to debug the app, you can use [Dart DevTools](/tools/dart-devtools).

## 8. Compile for production

The steps above used `dart`, the Dart VM to run the app. The Dart VM is
optimized for fast, incremental compilation to provide instant feedback
duringdevelopment. Now that our small app is done, it's time to AOT compile our
Dart code to optimized native machine code.

Use the `dart2aot` tool to AOT-compile the program to machine code:

```terminal
> dart2aot bin/main.dart bin/main.dart.aot
```

To run the compiled program, use the Dart Run-time:

```terminal
> dartaotruntime bin/main.dart.aot
```

Notice how it starts instantly, and completes very quicly:

```terminal
> time dartaotruntime bin/main.dart.aot

real	0m0.032s
```

## What next?

Check out these resources:

* Additional tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Sample code]({{site.dartlang}}/samples)
  * [Language tour]({{site.dartlang}}/guides/language/language-tour)
  * [Library tour]({{site.dartlang}}/guides/libraries/library-tour)
  * [Effective Dart]({{site.dartlang}}/guides/language/effective-dart)
* Tools & libraries
  * [Dart SDK]({{site.dartlang}}/tools/sdk)
  * [Dart tools](/tools)
  * [IDEs]({{site.dartlang}}/tools#ides-and-editors)

If you get stuck, find help at [Community and Support.](/community)

[stagehand]: https://pub.dartlang.org/packages/stagehand
[DartPad documentation]: /tools/dartpad
[Dart language tour]: /guides/language/language-tour
[Dart library tour]: /guides/libraries/library-tour
[ide]: /tools#ides-and-editors
