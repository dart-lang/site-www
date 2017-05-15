---
layout: default
permalink: /tools/analyzer
title: "Static Analyzer"
description: "The tool that analyzes and validates your Dart code."
---

The static analyzer evaluates your Dart code,
checking for errors and warnings that are specified in the
[Dart Language Specification](https://www.dartlang.org/docs/spec/).

Many tools in the Dart ecosystem (including IDEs, DartPad, and dartanalyzer)
perform static analysis on code. Most of these tools (with the exception
of DartPad) allow you to customize static analysis. The next section
points you to where you can learn how to customize static analysis.

The following section,
[Adding static analysis to your tool](#adding-static-analysis),
applies only if you are writing a Dart tool that needs to analyze code.

## Customizing static analysis

You can customize the behavior of the analyzer or the linter
by adding an analysis options file (`analysis_options.yaml`) to
the root of your package. The analysis options file allows
you to enable the lint rules appropriate to your project.
For example, adding the `close_sinks` rule ensures that all
sink methods include a `close()` call. For further information, see
[Customize Static Analysis](/guides/language/analysis-options).

<a name="adding-static-analysis"></a>
## Adding static analysis to your tool

If you aren't writing a Dart tool, you can ignore this section.

You have two options for adding static analysis to your Dart tool:
the analysis server or package:analyzer.
This section has more information and points you to where you can
learn more about each approach.

Some tools in the Dart ecosystem use the [analysis
server](https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server)
to perform static analysis. The analysis server provides on-going
analysis to other tools. The following tools use the analysis server.

* Dart and Flutter plugins for IDEs (such as
  [WebStorm](https://webdev.dartlang.org/tools/webstorm),
  [IntelliJ](https://www.dartlang.org/tools/jetbrains-plugin), and
  [Atom](https://atom.io/packages/dartlang))
* [DartPad](https://www.dartlang.org/tools/dartpad)&mdash;browser-based
  Dart playground

Other tools perform static analysis when invoked, but do not continually
evaluate code. These tools use the low-level
[package:analyzer](https://pub.dartlang.org/packages/analyzer) library
to perform static analysis. (In fact, the analysis server itself
also uses the package:analyzer.) The following tools use
package:analyzer.

* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
)&mdash;command-line static analyzer for web or VM apps
* [`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer)&mdash;command-line
  static analyzer for mobile (Flutter) apps
* [`dartdoc`](https://github.com/dart-lang/dartdoc)&mdash;command-line tool
  for generating Dart API docs
* [`dartfmt`](https://github.com/dart-lang/dart_style)&mdash;an
  opinionated formatter and linter for Dart code.
* [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler)&mdash;experimental development tool and transpiler for web apps

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
