---
title: Tools
description: The tools that support the Dart language.
---

When you're ready to create an app,
get the SDK and tools for your app type.
If you aren't sure which tools you need, **get the Flutter SDK.**

<div class="table-wrapper" markdown="1">
|------------+-----------------------------------+--------------------------|
| App type   | Get started instructions          | Tool information         |
|------------|-----------------------------------|--------------------------|
| Flutter (mobile and more) | [Install Flutter]({{site.flutter}}/setup) | [Flutter tools]({{site.flutter}}/using-ide) |
| Web app (non-Flutter) | [Install the Dart SDK](/tools/sdk) | [General-purpose tools][] and [web tools](#web) |
| Server or command line | [Install the Dart SDK](/tools/sdk) | [General-purpose tools][] and [specialized tools](#server) |
{:.table .table-striped}
</div>

[General-purpose tools]: #general-purpose-tools

{{site.alert.version-note}}
  As of Flutter 1.21, the Flutter SDK includes the full Dart SDK.
{{site.alert.end}}


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
<img src="{% asset tools/vscode.svg @path %}"
     width="48" alt="Visual Studio Code logo">
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
<img src="{% asset tools/eclipse-logo.png @path %}" alt="Eclipse logo">
<a class="no-automatic-external" href="https://github.com/eclipse/dartboard"><b>Eclipse</b></a>
</li>
</ul>

A [Language Server Protocol implementation][LSP] is also available for
[LSP-capable editors][] that don't have specific Dart extensions.

[LSP]: https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md
[LSP-capable editors]: https://microsoft.github.io/language-server-protocol/implementors/tools/

### Command-line tools {#cli}

The Dart SDK includes the following general-purpose tools:

[`dart`](/tools/dart-tool)
: A command-line interface for creating, formatting, analyzing,
  testing, compiling, and running Dart code.

[`dartdoc`](/tools/dartdoc)
: A documentation generator.
  For examples of dartdoc's output, see the API reference documentation
  published at [api.dart.dev]({{site.dart_api}}) and pub.dev
  (for example, the [`path` API reference]({{site.pub-api}}/path)).

[`pub`](/tools/pub/cmd)
: A package manager that
  makes it easy for you to install, use, and share Dart libraries,
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
: A build package that's used behind-the-scenes by the `webdev` command.

[`dartfix`][dartfix]
: A tool for migrating Dart source code and fixing common issues.

[build_runner]: /tools/build_runner
[dart_style]: {{site.pub-pkg}}/dart_style
[dartfix]: {{site.pub-pkg}}/dartfix

### Debugging

[Dart DevTools](/tools/dart-devtools)
: A suite of debugging and performance tools.


## Tools for developing web apps {#web}

The following tools support developing web apps:

[`dart2js`](/tools/dart2js)
: The original Dart-to-JavaScript compiler, with tree shaking.
  IDEs and the webdev CLI use dart2js when building web apps for deployment.

[`dartdevc`](/tools/dartdevc)
: The Dart dev compiler, a modular Dart-to-JavaScript compiler.
  IDEs and the webdev CLI use dartdevc when running a development server.

[`webdev`](/tools/webdev)
: A command-line interface (CLI) for Dart web app development,
  including building and serving web apps.

## Tools for developing command-line apps and servers {#server}

The following tools support developing or running
command-line apps and servers:

[`dart`](/tools/dart-vm)
: Use the `dart run` command to run uncompiled Dart command-line apps
  and some kinds of snapshots.

[`dartaotruntime`](/tools/dartaotruntime)
: Use this Dart runtime to run AOT snapshots.
