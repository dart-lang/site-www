---
title: Get Started with Server-Side Dart
description: Get Dart and run a Dart app.
nextpage:
  url: /tutorials/dart-vm/cmdline
  title: Write Command-Line Apps
prevpage:
  url: /tutorials/dart-vm
  title: Server-Side Dart Tutorials
---

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * The Dart SDK has development tools and libraries.
  * Use an IDE (such as WebStorm) or code editor to create your app.
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
You may also want an IDE or code editor; this tutorial uses WebStorm.

* [Get the Dart SDK](/tools/sdk#install)
* Recommended: [Get WebStorm]({{site.webdev}}/tools/webstorm)

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

**WebStorm** has a pre-installed Dart plugin,
but it requires a bit of configuration,
as we'll describe later.
If you prefer to use another IDE or code editor,
you might want to download and install a Dart plugin,
if available.
See the [tools page](/tools) for a list of plugins.

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

The [pub](/tools/pub) tool allows you to manage Dart packages.
Pub also includes commands for creating, developing, running, and deploying
Dart apps. Behind the scenes, [`pub run`](/tools/pub/cmd/pub-run),
for example, uses the `dart` tool to run a command-line app.

Pub uses the `pubspec.yaml` file to determine
your app's dependencies and any special setup that your app requires.
Pub assumes that the files and directories in a Dart app are
[laid out in a particular way](/tools/pub/package-layout). The following diagram shows some of the
conventions used by pub. Not all of these directories are required.

<img class="scale-img-max" src="/tutorials/dart-vm/images/pub-directory-structure.png"
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

You can invoke pub commands from the command line or from the WebStorm UI.

### Command-line apps

Dart command-line apps
run standalone from the command line.
Command-line apps are often used
to provide server-side support to a web app,
but they can also be scripts.

The Dart VM runs Dart code directly without intermediate compilation.

<img class="scale-img-max" src="/tutorials/dart-vm/images/dartvm-cmd-line.png"
     alt="Run a command-line app without compilation">

## Create a command-line app {#create-cmd-line}

1.  Launch WebStorm. This brings up a "Welcome to Webstorm" dialog.

1.  If this is the first time you have run WebStorm, you will
    need to set the path to the SDK.
    You can find the instructions at
    [Configuring Dart support]({{site.webdev}}/tools/webstorm#configuring-dart-support).

1.  Choose **Create New Project**.
    A dialog appears asking you to fill out a simple form.

1.  Select **Dart** from the list on the left.

1.  Replace the `untitled` portion of the string with `hello_world`.
    This name is used for the app's directory name and package name.
    By convention, these names are lowercase, with words
    separated by underscores (`_`).

1.  Make sure that **Generate sample content** is checked.

1.  Select **Console app** from the list.

1.  Click **Create**.

WebStorm creates a `hello_world` directory for the app
and boilerplate files for a small command-line app.
It then runs `pub get` to download the packages that the app depends on.

<aside class="alert alert-info" markdown="1">
**If you don't have WebStorm:**
You can create the command-line app's files
using the **console-full** generator from
[Stagehand.](http://stagehand.pub/)
Then run `pub get`.
</aside>

Some of the files and directories in the hello_world app
include the following:

`.dart_tool`
: Support files used by `pub` and other Dart tools. You can ignore this.

`bin`
: Contains the source files for the app.
  Expand `bin` to see `main.dart`, which is the main
  Dart file for this example.

`pubspec.yaml`
: Declares which packages your app needs.

`pubspec.lock`
: A generated file that specifies the version numbers
  of the packages on which the app depends.

`lib`
: Contains library code. Expand `lib` to see
  `hello_world.dart`, a library file with
  a simple `calculate()` method.

`.packages`
: Tells the Dart tools where to get the packages that your
  app uses. This file is created by the `pub get` command.
  You can ignore this.

Double-clicking any filename displays the contents of that file
in the pane to the right.

The messages pane at the bottom contains the results of calling
`pub get`, which fetches the packages used by the app.

When executed, the program prints
"Hello world: 42!" to the standard output stream,
using the `print()` function provided by the `dart:core` library.
The functions and objects defined in the dart:core library
are automatically available to all Dart apps.

## Run a command-line app {#run-cmd-line}

In WebStorm, you can run the app in any of the following ways:

* Click the Run button {% asset green-run.png alt="" %} in the upper right corner.
* Click the Run button to the left of the messages pane.
* Right-click `main.dart` in the files pane and select **Run 'main.dart'**
  from the pop-up menu.

WebStorm shows the output at the bottom in a pane titled
**Run main.dart**.

If you don't have WebStorm, you can run the app from the command line:

```terminal
$ pub run bin/main.dart
```

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

<img class="scale-img-max" src="/tutorials/dart-vm/images/function-parts.png"
     alt="Two parts of a function, the signature and the body"/>

The signature sets the function name,
the data type of its return value,
and the number and type of its input arguments.

<img class="scale-img-max" src="/tutorials/dart-vm/images/signature-parts.png"
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

## Other resources

- The <a href="{{site.webdev}}/tools/webstorm">WebStorm</a> page
  provides more information about this tool.
- The <a href="/tools/pub">pub</a>
  pages contain more information
  about Dart's package and asset manager.

## What next?

Try the next tutorial, [Write Command-Line Apps](cmdline), which describes how
to build command-line apps.
