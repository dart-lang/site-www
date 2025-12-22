---
title: Command_runner polish
shortTitle: Command_runner polish
description: >-
  Improve the HelpCommand to provide more detailed information and add an
  onOutput argument for flexible output handling.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/advanced-oop
  title: Advanced OOP features
nextpage:
  url: /get-started/data-and-json
  title: Data and JSON
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll put the finishing touches on the `command_runner`
package. You'll refine the `HelpCommand` to provide more detailed usage
information and add an `onOutput` argument for more flexible output handling.
This finalizes the `CommandRunner` package and prepares it for use in more
complex scenarios.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Learn how to iteratively build strings
    icon: text_snippet
  - title: Enhance help usage information
    icon: help
  - title: Make your command runner more flexible
    icon: terminal
</SummaryCard>

## Prerequisites

Before you begin this chapter, ensure you:

* Have completed Chapter 7 and have a working Dart development environment
  with the `dartpedia` project.
* Are familiar with basic programming concepts like variables, functions, and
  control flow.
* Understand the concepts of packages and libraries in Dart.
* Are familiar with object-oriented programming principles like inheritance and
  abstract classes.

## Tasks

You will polish the `command_runner` package to make it more robust and
user-friendly.

### Task 1 Improve the `HelpCommand` output

Enhance the `HelpCommand` to provide more detailed usage information,
including options and their descriptions. This will make it easier for users to
understand how to use your CLI application.

1.  Open the `command_runner/lib/src/help_command.dart` file.

1.  Add imports for `console.dart` and `exceptions.dart` at the top of the file.
    You need these to use the color extensions and to throw an
    `ArgumentException`.

    ```dart
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    import 'console.dart';
    import 'exceptions.dart';
    ```

1.  Replace the existing `run` method with the following. This new version uses
    a `StringBuffer` to efficiently build the help string and includes logic to
    handle verbose output.

    ```dart
    @override
    FutureOr<String> run(ArgResults args) async {
      final buffer = StringBuffer();
      buffer.writeln(runner.usage.titleText);

      if (args.flag('verbose')) {
        for (var cmd in runner.commands) {
          buffer.write(_renderCommandVerbose(cmd));
        }

        return buffer.toString();
      }

      if (args.hasOption('command')) {
        var (:option, :input) = args.getOption('command');

        var cmd = runner.commands.firstWhere(
          (command) => command.name == input,
          orElse: () {
            throw ArgumentException(
              'Input ${args.commandArg} is not a known command.',
            );
          },
        );

        return _renderCommandVerbose(cmd);
      }

      // Verbose is false and no arg was passed in, so print basic usage.
      for (var command in runner.commands) {
        buffer.writeln(command.usage);
      }

      return buffer.toString();
    }
    ```

    `StringBuffer` is a Dart class that allows you to efficiently build strings.
    It's more performant than using the `+` operator, especially when performing
    many concatenations inside a loop.

1.  Add the `_renderCommandVerbose` private helper method to the `HelpCommand`
    class. This method formats the detailed output for a single command.

    ```dart
    String _renderCommandVerbose(Command cmd) {
      final indent = ' ' * 10;
      final buffer = StringBuffer();
      buffer.writeln(cmd.usage.instructionText); //abbr, name: description
      buffer.writeln('$indent ${cmd.help}');
      if (cmd.valueHelp != null) {
        buffer.writeln(
          '$indent [Argument] Required? ${cmd.requiresArgument}, Type: ${cmd.valueHelp}, Default: ${cmd.defaultValue ?? 'none'}',
        );
      }
      buffer.writeln('$indent Options:');
      for (var option in cmd.options) {
        buffer.writeln('$indent ${option.usage}');
      }
      return buffer.toString();
    }
    ```

### Task 2 Add an `onOutput` callback

Next, add an `onOutput` argument to the `CommandRunner` to allow for
flexible output handling.

1.  Open the `command_runner/lib/src/command_runner_base.dart` file.

1.  Add the `onOutput` argument to the `CommandRunner` constructor, and add the
    corresponding `onOutput` member to the class.

    ```dart
    class CommandRunner {
      CommandRunner({this.onOutput, this.onError});

      /// If not null, this method is used to handle output. Useful if you want to
      /// execute code before the output is printed to the console, or if you
      /// want to do something other than print output the console.
      /// If null, the onInput method will [print] the output.
      FutureOr<void> Function(String)? onOutput;

      FutureOr<void> Function(Object)? onError;

      // ... rest of the class
    }
    ```

1.  Update the `run` method to use the `onOutput` argument.

    ```dart
      Future<void> run(List<String> input) async {
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            Object? output = await results.command!.run(results);
            if (onOutput != null) {
              await onOutput!(output.toString());
            } else {
              print(output.toString());
            }
          }
        } on Exception catch (e) {
          print(e);
        }
      }
    ```

    This updates the `run` method to use the `onOutput` function if it is
    provided, otherwise it defaults to printing to the console.

### Task 3 Use the `onOutput` callback

Finally, update your main application to use the new `onOutput` feature.

1.  Open the `cli/bin/cli.dart` file.

1.  Update the `main` function to pass the `onOutput` function to the
    `CommandRunner`. You will also need to add an import for `console.dart` to
    make the `write` function available.

    ```dart
    import 'package:command_runner/command_runner.dart';
    import 'package:command_runner/src/console.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>(
        onOutput: (String output) async {
          await write(output);
        },
        onError: (Object error) {
          if (error is Error) {
            throw error;
          }
          if (error is Exception) {
            print(error);
          }
        },
      )..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

### Task 4 Test the changes

Test the improved `HelpCommand` and the `onOutput` callback.

1.  Open your terminal and navigate to the `cli` directory.

1.  Run the command `dart run bin/cli.dart help --verbose`.

    You should see detailed usage information for the `help` command, printed
    using the custom `write` function.

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Used StringBuffer for efficient string building
    icon: text_snippet
    details: >-
      You replaced string concatenation with a `StringBuffer`,
      which can be more efficient for building strings in loops.
      Methods like `writeln()` and `write()` append content,
      while `toString()` produces the final string.
  - title: Enhanced HelpCommand with verbose output
    icon: help
    details: >-
      You improved the help system to show detailed usage information
      including options, default values, and descriptions.
      The `--verbose` flag and `--command` option give users
      control over the level of detail.
  - title: Added an onOutput callback argument for flexible handling
    icon: terminal
    details: >-
      You added `onOutput` to `CommandRunner`,
      allowing library consumers to customize how output is displayed.
      This pattern makes your package more flexible and adaptable,
      enabling delayed printing, logging, or output redirection.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="command-runner-polish" />

## Next lesson

In the next lesson, you'll prepare for the Wikipedia portion of the application.
