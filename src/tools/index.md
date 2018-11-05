---
title: Tools
description: The tools that support the Dart language.
show_breadcrumbs: false
toc: false
---

When you're ready to create an app,
get the SDK and tools for your app type.

|------------+-----------------------------------+--------------------------|
| App type   | Get started instructions          | Tool information         |
|------------|-----------------------------------|--------------------------|
| Mobile | [Install Flutter]({{site.flutter}}/setup) | [Flutter tools](https://flutter.io/using-ide/) |
| Web    | [Install the Dart SDK]({{site.webdev}}/tools/sdk) | [Dart tools for the web]({{site.webdev}}/tools) |
| Script or server | [Install the Dart SDK](/tools/sdk) | [Tools for server-side development](/dart-vm/tools) |
{:.table .table-striped}

The rest of this page covers general-purpose tools that
support the Dart language.


## DartPad

<img src="{% asset dartpad-hello.png @path %}" alt="DartPad Hello World"
 width="200px" align="right" />
[DartPad](/tools/dartpad) is
a great, no-download-required way to learn Dart syntax
and to experiment with Dart language features.
It supports Dart's core libraries,
except for VM libraries such as dart:io.


## IDEs and editors

Dart plugins exist for these commonly used IDEs.

<ul class="col2">
<li>
<img src="{% asset tools/android_studio.png @path %}"
     width="48" alt="IntelliJ logo">
<a class="no-automatic-external" href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="{% asset tools/intellij-idea.svg @path %}"
     width="48" alt="IntelliJ logo">
<a class="no-automatic-external" href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(and other JetBrains IDEs)</b></a>
</li>
<li>
<img src="{% asset tools/vscode.png @path %}" alt="Visual Studio Code logo">
<a class="no-automatic-external" href="https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code"><b>Visual Studio Code</b></a>
</li>
</ul>

The following Dart plugins are unsupported
and available as open source.

<ul class="col2">
<li>
<img src="{% asset tools/atom-logo.png @path %}" alt="Atom logo">
<a class="no-automatic-external" href="https://github.com/dart-atom/dartlang/"><b>Atom</b></a>
</li>
<li>
<img src="{% asset tools/emacs.png @path %}" alt="Emacs logo">
<a class="no-automatic-external" href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="{% asset tools/vim.png @path %}" alt="Vim logo">
<a class="no-automatic-external" href="https://github.com/dart-lang/dart-vim-plugin"><b>Vim</b></a>
</li>
</ul>

## Command-line tools

Most Dart-related SDKs include the following tools.

[Pub package manager](/tools/pub)
: Manages Dart packages,
  making it easy for you to install, use, and share Dart libraries,
  command-line tools, and other assets.
  Some Dart technologies, such as Flutter, may not support
  all of the pub commands.
  IDEs that support Dart generally have special support for pub,
  but you can also use it from the command line (`pub`).

[Static analyzer](/tools/analyzer)
: Evaluates and reports any errors or warnings in your code.
  The Dart plugin for your IDE should make use of Dart's analysis engine,
  but you can also run the analyzer from the command line (`dartanalyzer`).

[Code formatter](https://github.com/dart-lang/dart_style#readme)
: Formats your code, following the recommendations of the
  [Dart Style Guide](/guides/language/effective-dart/style).
  IDEs that support Dart generally allow you to format the code within
  the IDE. Or you can run the formatter from the command line (`dartfmt`).

Other tools, such as the [build_runner code generator,](/tools/build_runner)
aren't in the SDK but are distributed in packages.
