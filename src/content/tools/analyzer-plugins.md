---
title: Analyzer plugins
description: >-
 Analyzer plugins allow you to create custom lints, warnings,
 and IDE quick fixes for your Dart projects
---

:::version-note
Support for analyzer plugins was added in Dart 3.10.
:::

Analyzer plugins extend the Dart analyzer to report custom
diagnostics (lints and warnings), offer quick fixes,
and provide assists. This functionality is available directly
in your IDE and at the command line when you run
`dart analyze` or `flutter analyze`.

## Use analyzer plugins

You can start using an analyzer plugin in your Dart project
by enabling it in the `analysis_options.yaml` 
file at the root of your package or workspace.

### Enable a plugin

To enable an analyzer plugin, add it to the top-level
plugins section of your `analysis_options.yaml` file. You can
add a plugin from [pub.dev][] using a version constraint:

```yaml
plugins:
  my_plugin: ^1.0.0
```

Or, if you are developing a plugin locally, 
you can use a local path:

```yaml title="analysis_options.yaml"
plugins:
  my_plugin:
    path: /path/to/my_plugin
```

After you have made changes to the plugins section, 
restart the Dart Analysis Server to see the effects.

[pub.dev]: {{site.pub}}

### Configure diagnostics

A plugin can report two kinds of diagnostics: warnings and lints. 
The analyzer handles them differently by default:

* Warnings that a plugin defines are enabled by 
default (just like standard analyzer warnings).

* Lint rules that a plugin defines are disabled by default 
and must be explicitly enabled in your analysis options file.

You can enable or disable specific lint rules under 
the diagnostics section for a plugin:

```yaml title="analysis_options.yaml"
plugins:
  my_plugin:
    path: /path/to/my_plugin
    diagnostics:
      rule_1: true
      rule_2: true
      rule_3: false
```

In this example, `rule_1` and `rule_2` are enabled. 
`rule_3` is explicitly disabled, which is useful for 
overriding a rule that might be enabled from an `include:` file.

### Suppress diagnostics

You can suppress diagnostics from a plugin using the same 
`ignore` comments as you would for [built-in Dart diagnostics][]. 
To target a diagnostic from a specific plugin, 
prefix the diagnostic code with the plugin name followed 
by a slash (`/`).

For example, to suppress a diagnostic with the 
code `some_code` from a plugin named `some_plugin`, 
use one of the following formats:

To suppress for a single line:

```dart
// ignore: some_plugin/some_code
```

To suppress for an entire file:
```dart
// ignore_for_file: some_plugin/some_code
```

[built-in Dart diagnostics]: https://dart.dev/tools/analysis#suppressing-diagnostics-for-a-file

## Write an analyzer plugin

Create your own analyzer plugin to add custom static analysis, 
quick fixes, or assists to the Dart development experience.

### Set up the plugin package

An analyzer plugin is a standard Dart package with 
specific dependencies and structure. The primary dependency 
you will use is the [`analysis_server_plugin` package][], 
which provides the core `Plugin` class.

[`analysis_server_plugin` package]: https://pub.dev/packages/analysis_server_plugin

1. Create the `pubspec.yaml` file:

```yaml
name: test_analyzer_plugin
version: 0.0.1

environment:
  sdk: ^3.10.0

dependencies:
  analysis_server_plugin: ^^0.3.0
  analyzer: ^8.0.0
```

2. Create the plugin entry point

You must have a `lib/main.dart` file in your package. 
This file is the entry point for the analysis server to load your plugin.

Here's the basic structure:

```dart
import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

final plugin = SimplePlugin();

class SimplePlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    // Register diagnostics, quick fixes, and assists.
  }
}
```

Key points:
* You need a top-level variable named `plugin` that 
instantiates your class. The Dart Analysis Server looks 
for this variable.
* Your class must extend `Plugin` from 
`package:analysis_server_plugin/plugin.dart`.
* Override the `register` method to add your 
plugin's features. This method serves as the main entry 
point for registering your custom analysis rules, 
quick fixes, and assists with the analyzer.

### Implement plugin features

Once you have your basic plugin package set up, 
you can start adding custom functionality by 
implementing the `register` method. 
To learn more about implementing specific functionality,
check out the following guides:

* [Writing rules][]
* [Writing fixes][]
* [Writing assists][]
* [Testing rules][]

[Writing rules]: https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/writing_rules.md
[Writing fixes]: https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/writing_fixes.md
[Writing assists]: https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/writing_assists.md
[Testing rules]: https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server_plugin/doc/testing_rules.md

### Debug a plugin

If your plugin is not working as expected, 
here are the recommended ways to debug it:

* Your first stop should be the [analyzer diagnostics pages][]. 
  If your plugin's isolate crashes, the "plugins" screen 
  displays the crash information and stack trace.
* Remember `print` statements will not work. 
Plugins run in a separate isolate, and their standard output 
is not connected to your console.
* The most reliable way to trace your plugin's execution 
and inspect values is to write to a log file from 
your plugin's code.


[analyzer diagnostics pages]: https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/doc/tutorial/instrumentation.md#open-the-analyzer-diagnostics-pages