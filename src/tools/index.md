---
title: Tools
description: The tools that support the Dart language.
show_breadcrumbs: false
toc: false
---

This page discusses tools that support the Dart language.

For specific tools for creating complete apps, see the following links:

|------------------------+----------+-------------------------------------|
| App type | Product | Download instructions | Tools information |
|--------------------------|------------------------------------------------|
| Mobile app | Flutter | [Flutter Setup]({{site.flutter}}/setup) | [flutter.io](https://flutter.io/using-ide/) |
| Web app | Dart | [Install Dart](/tools/sdk#install) | [Dart Tools for the Web]({{site.webdev}}/tools) |
| Script or server | Dart | [Install Dart](/tools/sdk#install) | [Dart VM Tools](/dart-vm/tools) |
{:.table .table-striped}

## DartPad

[DartPad](/tools/dartpad) is
a great way to learn Dart syntax and to experiment with Dart language features
and core libraries (_except_ for dart:io and libraries that depend on dart:io).

## Editors with support for the Dart language

Dart plugins exist for many commonly used IDEs.

<ul class="col2">
<li>
<img src="{% asset_path 'tools/android_studio.svg' %}"
     width="48" alt="IntelliJ logo">
<a class="no-automatic-external" href="/tools/jetbrains-plugin"><b>Android Studio</b></a>
</li>
<li>
<img src="{% asset_path 'tools/intellij-idea.svg' %}"
     width="48" alt="IntelliJ logo">
<a class="no-automatic-external" href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(and other JetBrains IDEs)</b></a>
</li>
<li>
<img src="{% asset_path 'tools/vscode.png' %}" alt="Visual Studio Code logo">
<a class="no-automatic-external" href="https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code"><b>Visual Studio Code</b></a>
</li>
</ul>

The following Dart plugins are unsupported
and available as open source:

<ul class="col2">
<li>
<img src="{% asset_path 'tools/atom-logo.png' %}" alt="Atom logo">
<a class="no-automatic-external" href="https://github.com/dart-atom/dartlang/"><b>Atom</b></a>
</li>
<li>
<img src="{% asset_path 'tools/emacs.png' %}" alt="Emacs logo">
<a class="no-automatic-external" href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="{% asset_path 'tools/vim.png' %}" alt="Vim logo">
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
