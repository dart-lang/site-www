---
layout: default
permalink: /tools/analyzer
title: "Static Analyzer"
description: "The tool that analyzes and validates your Dart code."
---

The static analyzer evaluates your Dart code,
checking for errors and warnings that are specified in the
[Dart Language Specification](https://www.dartlang.org/docs/spec/).

Many tools in the Dart ecosystem use the [analysis
server](https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server)
to perform static analysis. For example:

* Dart and Flutter plugins for IDEs (such as
  [WebStorm](https://webdev.dartlang.org/tools/webstorm),
  [IntelliJ](https://www.dartlang.org/tools/jetbrains-plugin), and
  [Atom](https://atom.io/packages/dartlang))
* [DartPad](https://www.dartlang.org/tools/dartpad)&mdash;browser-based
  Dart playground
* [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler)&mdash;experimental development tool and transpiler for web apps
* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
)&mdash;command-line static analyzer for web or VM apps
* [`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer)&mdash;command-line
  static analyzer for mobile (Flutter) apps

## Customizing static analysis

You can customize the behavior of the analyzer or the linter
by adding an analysis options file (`analysis_options.yaml`) to
the package root of your project. The linter, an analyzer plugin,
allows you to define (or exclude) rules specific to your project.
For example, you can add the `close_sinks` rule to ensure that all
sink methods include a `close()` call. For further information, see
[Customize Static Analysis](/guides/language/analysis-options).

## Building tools that use static analysis

To add static analysis to your Dart tool, you have two
options. Tools that are OK with a wire protocol API
(such as the plugin for an IDE), use the [analysis
server.](https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server)
Also see the [Analysis Server API
Specification](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html).

Tools that need to access the abstract syntax tree (AST) (such as
[dart_style](https://github.com/dart-lang/dart_style)&mdash;used
by `dartfmt`&mdash;or [dartdoc](https://github.com/dart-lang/dartdoc)),
use [package:analyzer.](https://pub.dartlang.org/packages/analyzer)

You might also be interested in the [Dart Analyzer discussion
group.](https://groups.google.com/a/dartlang.org/forum/#!forum/analyzer-discuss)
