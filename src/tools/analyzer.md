---
layout: default
permalink: /tools/analyzer
title: "Static Analyzer"
description: "The tool that analyzes and validates your Dart code."
---

The static analyzer evaluates your Dart code,
checking for errors and warnings that are specified in the
[Dart Language Specification](https://www.dartlang.org/docs/spec/).

Many tools in the Dart ecosystem use the
[analyzer package](https://pub.dartlang.org/packages/analyzer) to
perform static analysis:

* Some IDEs (such as [WebStorm](https://webdev.dartlang.org/tools/webstorm),
  [IntelliJ](https://www.dartlang.org/tools/jetbrains-plugin),
  [Atom](https://atom.io/packages/dartlang))
* [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler)&mdash;Experimental development tool and transpiler for web apps
* [DartPad](https://www.dartlang.org/tools/dartpad)&mdash;browser-based
  Dart playground
* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
)&mdash;command-line tool for static analysis for web or VM apps
* [`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer)&mdash;static analysis for mobile (Flutter) apps

You can customize the behavior of the analyzer or the linter
by adding an analysis options file (`analysis_options.yaml`) to
the package root of your project. For further information, see
[Customize Static Analysis](/guides/language-analysis-options).

