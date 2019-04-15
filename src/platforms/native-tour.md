---
title: "A tour of Dart Native"
short-title: Get-started
description: "A guide to get you quickly writing native apps in Dart."
toc: true
---

Follow these steps to start using Dart to develop native apps.

## 1. Install Dart

As you install, **note the path to the SDK.**
You'll need it in step 4.

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


## 2. Get command-line developer tools

<i class="fas fa-terminal dark"></i> Install [stagehand:][stagehand], used for
creating Dart apps.

```terminal
> pub global activate stagehand
```

More information, incl. tips for IDEs that support Dart native: [Dart tools](/tools).

## 3. Create a small app

<i class="fas fa-terminal dark"></i>
To create a command-line app and retrive all it's dependencies, use these commands:

```terminal
> mkdir quickstart
> cd quickstart
> stagehand console-full
> pub get
```

## 4. Run the app

<i class="fas fa-terminal dark"></i>
To run the app from the command line, use [dart][]:

```terminal
> dart bin/main.dart
```

The console should display "Hello world: 42!"

## 5. Add custom code to the app

Let's customize the app you just created.

 1. Edit `bin/main.dart` to parse the list of arguments into a list of `int`s:

    ```dart
    import 'package:cons/cons.dart' as cons;
    import 'package:args/args.dart';

    main(List<String> arguments) {
      if (arguments == []) {
        print('Hello world: ${cons.calculate()}!');
      } else {
        // Parse the arguments into a list of ints.
        var argResults = ArgParser().parse(arguments);
        List<int> numbers = argResults.rest.map((s) => int.parse(s)).toList();
        print('The multiplication of $numbers is ${cons.multiplication(numbers)}');
      }
    }
    ```

 2. In `lib/cons.dart`, add the new `multiplication` method:

    ```dart
    int multiplication(List<int> numbers) {
      var result = 1;
      for (var number in numbers) {
        result = result * number;
      }
      return result;
    }
    ```

 3. Save your changes.

 4. Re-run your app, passing it a list of intergers. 
    It should look something like this:

    ```terminal
    > dart bin/main.dart 3 6 89
    The multiplication of [3, 6, 89] is 1602 
    ```

More information:
[Write Command-Line Apps](/tutorials/server/cmdline)

## 6. Use DevTools to debug the app

TODO: Update to use [Dart DevTools](https://flutter.github.io/devtools/).

## 7. Compile for production

The steps above used `dart`, the Dart VM to run the app. The Dart VM is
optimized for fast, incremental compilation to ensure a super-fast developer
cycle. Now that our small app is done, it's time to AOT compile our Dart code to
optimized native machien code.

The `dart2aot` tool is used to AOT compile:

```terminal
> dart2aot bin/main.dart bin/main.dart.aot
```

To run the compiled program; notice how it starts instantly:

```terminal
> dartaotruntime bin/main.dart.aot
```

## What next?

Check out these resources:

* Command-line and server-related tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Sample code]({{site.dartlang}}/samples)
  * [Language tour]({{site.dartlang}}/guides/language/language-tour)
  * [Library tour]({{site.dartlang}}/guides/libraries/library-tour)
  * [Effective Dart]({{site.dartlang}}/guides/language/effective-dart)
* Tools & libraries
  * [Dart SDK]({{site.dartlang}}/tools/sdk)
  * [Dart tools for the web](/tools)
  * [IDEs]({{site.dartlang}}/tools#ides-and-editors)

If you get stuck, find help at [Community and Support.](/community)
