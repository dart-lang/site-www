---
title: Static Analyzer
description: The tool that analyzes and validates your Dart code.
---

The static analyzer evaluates your Dart code,
checking for errors and warnings that are specified in the
[Dart Language Specification](/guides/language/spec).

Many tools in the Dart ecosystem (including IDEs, DartPad, and dartanalyzer)
perform static analysis on code. Most of these tools (with the exception
of DartPad) allow you to customize static analysis. The next section
points you to where you can learn how to customize static analysis.

<a name="customizing-static-analysis"></a>
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

If your tool requires continuous analysis or can handle exchanging
text messages with a local server, use the [analysis
server](https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server).
(See the [Analysis Server API
Specification](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html)
for protocol details.) The following tools use the analysis server:

* Dart and Flutter plugins for IDEs (such as
  [WebStorm,]({{site.webdev}}/tools/webstorm)
  [IntelliJ](/tools/jetbrains-plugin), and
  [Atom](https://atom.io/packages/dart))
* [DartPad](/tools/dartpad)

If your tool requires access to the abstract syntax tree (AST), use the
[package:analyzer](https://pub.dartlang.org/packages/analyzer) library.
The following tools use package:analyzer:

* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
)
* [`dartdevc`]({{site.webdev}}/tools/dartdevc)
* [`dartdoc`](https://github.com/dart-lang/dartdoc)
* [`dartfmt`](https://github.com/dart-lang/dart_style)
* [`flutter analyze`]({{site.flutter}}/debugging/#the-dart-analyzer)

You might also be interested in the [Dart analyzer discussion
group.](https://groups.google.com/a/dartlang.org/forum/#!forum/analyzer-discuss)
