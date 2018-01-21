---
title: Tools
description: The tools that support the Dart language.
permalink: /tools
show_breadcrumbs: false
toc: false
---

This page discusses tools that are useful with multiple Dart technologies.

## DartPad

[DartPad](/tools/dartpad) is
a great way to learn Dart syntax and to experiment with Dart language features
and core libraries (_except_ for dart:io and libraries that depend on dart:io).

To write code that uses other libraries and features,
you need an [SDK](#sdks).
We also recommend using an IDE.


## IDEs

Dart plugins exist for many commonly used IDEs.
If you're writing web apps and don't already have a favorite IDE,
try WebStorm, which comes with Dart support.

<ul class="col2">
<li>
<img src="{% asset_path 'tools/intellij-idea.svg' %}"
     width="48" alt="IntelliJ logo">
<a href="/tools/jetbrains-plugin"><b>IntelliJ IDEA<br>
(and other JetBrains IDEs)</b></a>
</li>
<li>
<img src="{% asset_path 'tools/webstorm.svg' %}"
     width="48" alt="WebStorm logo">
<a href="{{site.webdev}}/tools/webstorm"><b>WebStorm</b></a>
</li>
</ul>

The following Dart plugins are unsupported
and available as open source:

<ul class="col2">
<li>
<img src="{% asset_path 'tools/atom-logo.png' %}" alt="Atom logo">
<a href="https://github.com/dart-atom/dartlang/"><b>Atom</b></a>
</li>
<li>
<img src="{% asset_path 'tools/emacs.png' %}" alt="Emacs logo">
<a href="https://github.com/nex3/dart-mode"><b>Emacs</b></a>
</li>
<li>
<img src="{% asset_path 'tools/sublime.png' %}" alt="Sublime logo">
<a href="https://github.com/dart-lang/dart-sublime-bundle#readme"><b>Sublime Text 3</b></a>
</li>
<li>
<img src="{% asset_path 'tools/vim.png' %}" alt="Vim logo">
<a href="https://github.com/dart-lang/dart-vim-plugin"><b>Vim</b></a>
</li>
<li>
<img src="{% asset_path 'tools/vscode.png' %}" alt="Visual Studio Code logo">
<a href="https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code"><b>Visual Studio Code</b></a>
</li>
</ul>

<aside class="alert alert-info" markdown="1">
**Note:** Two previous options, Dart Editor and the Eclipse Plugin for Dart,
are no longer maintained.
</aside>

## SDKs

Which SDK you need depends on what type of app you're developing.

|------------------------+----------+-------------------------------------|
| App type | SDK | Download instructions | More information |
|--------------------------|------------------------------------------------|
| Web app | Dart | [Install Dart and Dartium](/install) | [Dart SDK](/tools/sdk), [Dart Tools for the Web]({{site.webdev}}/tools) |
| Script or server | Dart | [Install Dart](/install) | [Dart SDK](/tools/sdk), [Dart VM Tools](/dart-vm/tools) |
| Mobile app | Flutter | [Flutter Setup]({{site.flutter}}/setup) | [flutter.io]({{site.flutter}}) |
{:.table .table-striped}

{% include dartium-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}


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

For details about these and many other tools,
see the tools documentation for the SDK you're using:

* [Dart SDK](/tools/sdk) and specialized tools:
  * [Dart Tools for the Web]({{site.webdev}}/tools)
  * [Dart VM Tools]({{site.dart_vm}}/tools)
* [Flutter]({{site.flutter}}/setup/)
