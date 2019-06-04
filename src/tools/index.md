---
title: Tools
description: The tools that support the Dart language.
---

When you're ready to create an app,
get the SDK and tools for your app type.

<div class="table-wrapper" markdown="1">
|------------+-----------------------------------+--------------------------|
| App type   | Get started instructions          | Tool information         |
|------------|-----------------------------------|--------------------------|
| Mobile | [Install Flutter]({{site.flutter}}/setup) | [Flutter tools]({{site.flutter}}/using-ide) |
| Web    | [Install the Dart SDK](/tools/sdk) | [General-purpose tools][] and [web tools](#web) |
| Server or command line | [Install the Dart SDK](/tools/sdk) | [General-purpose tools][] and [specialized tools](#server) |
{:.table .table-striped}
</div>

[General-purpose tools]: #general-purpose-tools

## General-purpose tools

The following tools support the Dart language on all platforms.

* [DartPad](#dartpad)
* [IDEs and editors](#ides-and-editors)
* [Command-line tools](#cli)


### DartPad

<img src="{% asset dartpad-hello.png @path %}" alt="DartPad Hello World"
 width="200px" align="right" />
[DartPad](/tools/dartpad) is
a great, no-download-required way to learn Dart syntax
and to experiment with Dart language features.
It supports Dart's core libraries,
except for VM libraries such as dart:io.


### IDEs and editors

Dart plugins exist for these commonly used IDEs.

<ul class="col2">
<li>
<img src="{% asset tools/android_studio.png @path %}"
     width="48" alt="Android Studio logo">
<a href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="{% asset tools/intellij-idea.svg @path %}"
     width="48" alt="IntelliJ logo">
<a href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(and other JetBrains IDEs)</b></a>
</li>
<li>
<img src="{% asset tools/vscode.png @path %}" alt="Visual Studio Code logo">
<a href="/tools/vs-code"><b>Visual Studio Code</b></a>
</li>
</ul>

The following Dart plugins are also available,
thanks to the Dart community.

<ul class="col2">
<li>
<img src="{% asset tools/emacs.png @path %}" alt="Emacs logo">
<a class="no-automatic-external" href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="{% asset tools/vim.png @path %}" alt="Vim logo">
<a class="no-automatic-external" href="https://github.com/dart-lang/dart-vim-plugin"><b>Vim</b></a>
</li>
<li>
<img src="{% asset tools/atom-logo.png @path %}" alt="Atom logo">
<a class="no-automatic-external" href="https://github.com/dart-atom/dart"><b>Atom</b></a>
</li>
</ul>

### Command-line tools {#cli}

The Dart SDK includes the following general-purpose tools:

[`dartanalyzer`](/tools/dartanalyzer)
: A static analyzer that evaluates and reports any errors or warnings in your code.
  The Dart plugin for your IDE should make use of Dart's analysis engine,
  but you can also run the analyzer from the command line.

[`dartdoc`](/tools/dartdoc)
: Generates API reference documentation.

[`dartfmt`](/tools/dartfmt)
: Formats your code, following the recommendations of the
  [Dart style guide](/guides/language/effective-dart/style).
  IDEs that support Dart generally allow you to format the code within
  the IDE. Or you can run the formatter from the command line.

[`pub`](/tools/pub/cmd)
: Manages Dart packages,
  making it easy for you to install, use, and share Dart libraries,
  command-line tools, and other assets.
  Some Dart technologies, such as Flutter, may not support
  all of the pub commands.
  IDEs that support Dart generally have special support for pub,
  but you can also use it from the command line.

Some additional tools are available in [packages](/guides/packages).
To install these tools, use the `pub` command, as described in each tool's
installation instructions.
Here are the general-purpose tools you might want to install:

[`build_runner`][build_runner]
: A code generator.

[`dartfix`][dartfix]
: A tool for migrating Dart source code and fixing common issues.

[build_runner]: /tools/build_runner
[dart_style]: {{site.pub-pkg}}/dart_style
[dartfix]: {{site.pub-pkg}}/dartfix


## Tools for developing web apps {#web}

The following tools are especially for developing web apps:

[webdev](/tools/webdev)
: A command line interface (CLI) for Dart web app development,
  including building and serving web apps.

[dart2js](/tools/dart2js)
: The original Dart-to-JavaScript compiler, with tree shaking.
  IDEs and the webdev CLI use dart2js when building web apps for deployment.

[dartdevc](/tools/dartdevc)
: The Dart dev compiler, a modular Dart-to-JavaScript compiler.
  IDEs and the webdev CLI use dartdevc when running a development server.

[build_runner](/tools/webdev)
: A build package that's used by the webdev CLI.
  You can use it directly for [testing](/tools/webdev#test)
  or if you need more configurability than webdev provides.


## Tools for developing command-line apps and servers {#server}

The following tools have special support for developing or running
command line apps and servers:

[Standalone Dart VM: `dart`](/tools/dart-vm)
: Executes Dart code.
  IDEs that support Dart,
  and some of the `pub` commands, use this
  command behind-the-scenes to execute Dart scripts.
  Note that you must configure your IDE with the location of
  the `dart` binary.

[AOT compiler and runtime: `dart2aot`, `dartaotruntime`](/tools/dart2aot)
: Support ahead-of-time compilation of Dart code to native x64 machine code.

[Pub package manager: `pub`](/tools/pub/cmd)
: Simplifies downloading and running scripts,
  with commands such as `pub get`, `pub global activate`, `pub global run`,
  and `pub run`.

