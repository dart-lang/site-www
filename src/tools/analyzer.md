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
to perform static analysis. The analysis server provides on-going
analysis to other tools. The following tools use the analysis server.

* Dart and Flutter plugins for IDEs (such as
  [WebStorm](https://webdev.dartlang.org/tools/webstorm),
  [IntelliJ](https://www.dartlang.org/tools/jetbrains-plugin), and
  [Atom](https://atom.io/packages/dartlang))
* [DartPad](https://www.dartlang.org/tools/dartpad)&mdash;browser-based
  Dart playground
* [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler)&mdash;experimental development tool and transpiler for web apps

Other tools perform static analysis when invoked, but do not continually
evaluate code. These tools use the low-level
[package:analyzer](https://pub.dartlang.org/packages/analyzer) library
to perform static analysis. (In fact, the analysis server itself
also uses the analyzer library.) The following tools use
package:analyzer.

* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
)&mdash;command-line static analyzer for web or VM apps
* [`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer)&mdash;command-line
  static analyzer for mobile (Flutter) apps
* [`dartdoc`](https://github.com/dart-lang/dartdoc)&mdash;command-line tool
  for generating Dart API docs
* [package:dart_style](https://github.com/dart-lang/dart_style)&mdash;an opinionated
  formatter and linter used for Dart code. The command-line tool, `dartfmt`,
  uses the dart_style library.

## Customizing static analysis

You can customize the behavior of the analyzer or the linter
by adding an analysis options file (`analysis_options.yaml`) to
the package root of your project. The linter, an analyzer plugin,
allows you to define (or exclude) rules specific to your project.
For example, you can add the `close_sinks` rule to ensure that all
sink methods include a `close()` call. For further information, see
[Customize Static Analysis](/guides/language/analysis-options).

## Building tools that use static analysis

You have two options for adding static analysis to your Dart tool:
the analysis server or package:analyzer.

If your tool requires continuous analysis and can handle sending text
messages back and forth to a server, use the [analysis
server.](https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server)
Note that the analysis server, part of the Dart SDK, runs locally.
Also see the [Analysis Server API
Specification](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html).

If your tool needs access to the abstract syntax tree (AST), and doesn't
require continuous analysis,
use [package:analyzer](https://pub.dartlang.org/packages/analyzer).

You might also be interested in the [Dart Analyzer discussion
group.](https://groups.google.com/a/dartlang.org/forum/#!forum/analyzer-discuss)
