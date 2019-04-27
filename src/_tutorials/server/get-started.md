---
title: Get started with server-side Dart
description: Get Dart and run a Dart app.
nextpage:
  url: /tutorials/server/cmdline
  title: Write command-line apps
prevpage:
  url: /tutorials/server
  title: Server-side Dart tutorials
---

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * The Dart SDK has development tools and libraries.
  * Use an IDE or a code editor to create your app.
  * All Dart apps have a `main()` function.
  * Dart supports top-level functions.
</div>

This tutorial gets you ready
to begin writing Dart apps in an editor or IDE.
Here you will download the Dart software and
create and run a small app.

## Download Dart and an IDE {#download-dart}

Once you are ready to move beyond DartPad and create Dart apps in
a real world environment, you need to download some software.

The Dart SDK contains all of
the tools and libraries that you need for basic Dart development.
You may also want an IDE or code editor.

* [Get the Dart SDK](/tools/sdk#install)
* Optional: [Get a Dart-savvy IDE or editor][ide]

## What did you get? {#what-did-you-get}

When you download the **Dart SDK**, you get a directory
that contains tools (under `bin`) and libraries (under `lib`),
along with supporting files.
The location of the directory (we'll call it the _&lt;sdk-install-dir&gt;_)
depends on your platform and how you downloaded the SDK.

Under _&lt;sdk-install-dir&gt;_/lib are Dart libraries, such as dart:core,
dart:html, and dart:io, that define APIs useful to most apps.
The _&lt;sdk-install-dir&gt;_/bin directory contains several useful
command-line tools, such as the **pub** package manager,
the Dart-to-JavaScript compiler,
and the command-line version of the Dart VM.


## About Dart apps {#what-is-app}

The most minimal Dart app has the following:

* One Dart source file&mdash;a
  file with the `.dart` suffix that contains Dart code
* One top-level `main()` function.
  This is the entry point for your app.

As long as this simple Dart app can be run from the
command line (and does not rely on the browser or the Flutter SDK),
you can run it using `dart`, the Dart VM tool.
For example:

```terminal
$ dart main.dart
```

**An app with any level of complexity should also
include a pubspec file.** The pubspec.yaml file contains
the name of the app and (optionally) a description.

For example:

<?code-excerpt "misc/pubspec.yaml" retain="/^(name|desc)/"?>
{% prettify yaml %}
name: examples
description: dartlang.org example code.
{% endprettify %}

### Pub package manager

The [pub tool](/tools/pub/cmd) tool allows you to manage Dart packages.
Pub also includes commands for creating, developing, running, and deploying
Dart apps. Behind the scenes, for example, [`pub run`](/tools/pub/cmd/pub-run)
uses the `dart` tool to run a command-line app.

Pub uses the `pubspec.yaml` file to determine
your app's dependencies and any special setup that your app requires.
Pub assumes that the files and directories in a Dart app are
[laid out in a particular way](/tools/pub/package-layout). The following diagram shows some of the
conventions used by pub. Not all of these directories are required.

<img class="scale-img-max" src="/tutorials/server/images/pub-directory-structure.png"
alt="Pub's directory structure including bin, lib, build directories, and pubspec">

`bin`
: The main files for a command-line app. One of the
  files must include a top-level `main()` function.

`lib`
: Additional code to be used by your app.

`pubspec.yaml`
: The app's metadata, including information about which
  packages the app depends on and which versions of those
  packages are required.

You can invoke pub commands from the command line or
from your IDE or editor's UI.

### Command-line apps

Dart command-line apps
run standalone from the command line.
Command-line apps are often used
to provide server-side support to a web app,
but they can also be scripts.

The Dart VM runs Dart code directly without intermediate compilation.

<img class="scale-img-max" src="/tutorials/server/images/dartvm-cmd-line.png"
     alt="Run a command-line app without compilation">

## Create a command-line app {#create-cmd-line}

Whether you use an IDE or the command line,
you can create a basic app using standard Dart templates.

If you're using a [Dart-savvy IDE][ide], follow these instructions:

1. Create a new Dart project called `hello_world`,
   using files from the template named
   **console-full**, which has the description 
   **A command-line application sample.**

1. If the IDE doesn't automatically download the packages
   that the app depends on, make the IDE run `pub get`.

If you're using the command line, follow these instructions:

1. Get [Stagehand.]({{site.pub}}/packages/stagehand)

1. Use Stagehand to get the files, and then
   use the pub tool to download dependent packages.
   The commands you use should be something like this:
   
   ```terminal
   mkdir hello_world
   cd hello_world
   stagehand console-full
   pub get
   ```

Some of the files and directories in the hello_world app
include the following:

`analysis_options.yaml`
: Defines lint rules enforced for this project.
  By default, this file specifies the set of rules used for Google projects,
  but you can [customize these options](/guides/language/analysis-options).

`bin`
: Contains the source files for the app.
  The main Dart file for this example is `bin/main.dart`.

`lib`
: Contains library code.
  In this directory, `hello_world.dart` defines
  a simple `calculate()` method.

`pubspec.lock`
: A generated file that specifies the version numbers
  of the packages on which the app depends.

`pubspec.yaml`
: Declares which packages your app needs.

`test`
: Contains test code for the hello_world app.

`.dart_tool`
: Support files used by `pub` and other Dart tools. You can ignore this.

`.packages`
: Tells the Dart tools where to get the packages that your
  app uses. This file is created by the `pub get` command.
  You can ignore this.


## Run a command-line app {#run-cmd-line}

Run the app, using either your IDE or the command line:

```terminal
$ pub run bin/main.dart
```

The program prints "Hello world: 42!" to the standard output stream,
using the `print()` function provided by the `dart:core` library.
The functions and objects defined in the dart:core library
are automatically available to all Dart apps.


## About main() and other top-level functions {#top-level-functions}

Dart lets you define _top-level_ functions,
that is, functions that are not encapsulated within a class or object.
All apps have at least one top-level function,
namely the `main()` function.

The app you've seen in this tutorial has other top-level functions.
The Hello World example calls `print()`,
a top-level function defined in `dart:core`.

A function declaration
has two parts: a _signature_ and a _body_.

<img class="scale-img-max" src="/tutorials/server/images/function-parts.png"
     alt="Two parts of a function, the signature and the body"/>

The signature sets the function name,
the data type of its return value,
and the number and type of its input arguments.

<img class="scale-img-max" src="/tutorials/server/images/signature-parts.png"
     alt="The parts of a function signature"/>

The body is the code that defines the function's behavior.
It usually appears between curly braces (`{`_code_`}`).
If the body is a single expression, then you
can skip the braces and use the `=>` shorthand:

<?code-excerpt "misc/lib/vm_get_started.dart"?>
{% prettify dart %}
double milesToKM(double miles) => miles / 0.62;
{% endprettify %}

The `milesToKM()` function performs a simple arithmetic calculation
and returns the result.

This function takes a single argument.
Functions can take multiple arguments,
in which case the arguments are set apart by commas.

## About file naming conventions {#file-names}

When creating an app with WebStorm,
you are asked to provide an app name.
By convention, app names
(and thus, the related files and directories) are lowercase,
with words separated by underscores (`_`).


## What next?

Try the next tutorial, [Write command-line apps](cmdline), which describes how
to build command-line apps.

[ide]: /tools#ides-and-editors
