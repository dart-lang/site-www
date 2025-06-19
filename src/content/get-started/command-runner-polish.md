---
title: command_runner polish
short-title: command_runner polish
description: >-
  Improves `HelpCommand`, completes `CommandRunner`, adds `onOutput` argument, provides example.
prevpage:
  url: /get-started/advanced-oop
  title: Advanced OOP-adjacent features
nextpage:
  url: /get-started/setup-for-part-3
  title: Setup for part 3
---

{% include 'fwe-wip-warning.md' %}

In this chapter, you'll put the finishing touches on the `command_runner` package. You'll enhance the `HelpCommand` to provide more detailed usage information, complete the `CommandRunner` class, add an `onOutput` argument for customizing output handling, and see a complete example of how to use the package.

:::secondary What you'll learn

* Use `StringBuffer` for efficient string concatenation.
* Improve the `HelpCommand` to display detailed command and option usage.
* Complete the `CommandRunner` class to handle command execution.
* Add an `onOutput` argument to `CommandRunner` for customizing output handling.
* See an example of how to use the `command_runner` package.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* Completed Chapter 7 and have a working `dartpedia` project with the `command_runner` package.
* Understand the basic concepts of command-line arguments and options.
* Are familiar with the `Command`, `Option`, and `CommandRunner` classes from previous chapters.

## Tasks

You'll now finalize the `command_runner` package by improving the `HelpCommand`, completing the `CommandRunner`, and adding an `onOutput` argument.

### Task 1: Improve the `HelpCommand`

The `HelpCommand` currently provides basic usage information. Let's enhance it to display more detailed command and option usage.

1.  Open the `command_runner/lib/src/help_command.dart` file.

2.  Replace the existing `run` method with the following:

    ```dart title="command_runner/lib/src/help_command.dart"
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

        // If an arg was passed in, verbose print that command's usage only
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

    This updated `run` method uses a `StringBuffer` to efficiently build the output string. It handles three cases:

    *   **Verbose mode:** If the `verbose` flag is set, it iterates through all commands and calls the `_renderCommandVerbose` method to display detailed information for each command.
    *   **Specific command:** If a `command` option is provided, it finds the corresponding command and calls `_renderCommandVerbose` to display detailed information for that command only.
    *   **Basic usage:** If neither `verbose` nor `command` is provided, it iterates through all commands and displays basic usage information for each command.

    The `StringBuffer` class is used here because it's more efficient for building up strings piece by piece compared to using the `+` operator repeatedly.

3.  Add a new method called `_renderCommandVerbose` to `command_runner/lib/src/help_command.dart`:

    ```dart title="command_runner/lib/src/help_command.dart"
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

    This method takes a `Command` object as input and returns a string containing detailed usage information for that command. It includes the command's usage, help description, argument information (if applicable), and a list of options with their usage.

    The instruction text and `indent` variable are used to format the output for better readability. The null-aware operator (`??`) is used to display "none" if the default value is null.

### Task 2: Complete the `CommandRunner`

The `CommandRunner` class is currently missing some functionality. Let's complete it by adding argument parsing and error handling.

1.  Open the `command_runner/lib/src/command_runner_base.dart` file.

2.  Replace the existing `parse` method with the following:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    ArgResults parse(List<String> input) {
      ArgResults results = ArgResults();
      if (input.isEmpty) return results;

      if (_commands.containsKey(input.first)) {
        results.command = _commands[input.first];
        input = input.sublist(1);
      } else {
        throw ArgumentException(
          'The first word of input must be a command.',
          null,
          input.first,
        );
      }
      if (results.command != null &&
          input.isNotEmpty &&
          _commands.containsKey(input.first)) {
        throw ArgumentException(
          'Input can only contain one command. Got ${input.first} and ${results.command!.name}',
          null,
          input.first,
        );
      }

      // Section: handle Options (including flags)
      Map<Option, Object?> inputOptions = {};
      int i = 0;
      while (i < input.length) {
        if (input[i].startsWith('-')) {
          var base = _removeDash(input[i]);
          var option = results.command!.options.firstWhere(
            (option) => option.name == base || option.abbr == base,
            orElse: () {
              throw ArgumentException(
                'Unknown option ${input[i]}',
                results.command!.name,
                input[i],
              );
            },
          );

          if (option.type == OptionType.flag) {
            // all flags are false by default, and true if they appear at all
            inputOptions[option] = true;
            i++;
            continue;
          }

          if (option.type == OptionType.option) {
            if (i + 1 >= input.length) {
              throw ArgumentException(
                'Option ${option.name} requires an argument',
                results.command!.name,
                option.name,
              );
            }
            if (input[i + 1].startsWith('-')) {
              throw ArgumentException(
                'Option ${option.name} requires an argument, but got another option ${input[i + 1]}',
                results.command!.name,
                option.name,
              );
            }
            var arg = input[i + 1];
            inputOptions[option] = arg;
            // increment 1 extra to account for the arg
            i++;
          }
          // The arg must be a positional arg
        } else {
          if (results.commandArg != null && results.commandArg!.isNotEmpty) {
            throw ArgumentException(
              'Commands can only have up to one argument.',
              results.command!.name,
              input[i],
            );
          }
          results.commandArg = input[i];
        }

        i++;
      }
      results.options = inputOptions;

      return results;
    }
    ```

    This `parse` method now handles argument parsing, option parsing, and error handling. It performs the following steps:

    *   Checks if the input is empty.
    *   Checks if the first argument is a known command.
    *   Parses options (including flags) and their arguments.
    *   Handles positional arguments.
    *   Throws `ArgumentException` for invalid arguments, unknown options, missing option arguments, and multiple command arguments.

    This code ensures that the `CommandRunner` can correctly parse command-line arguments and options, and that it provides helpful error messages when it encounters invalid input.

3.  Replace the existing `_removeDash` method with the following:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    String _removeDash(String input) {
      if (input.startsWith('--')) {
        return input.substring(2);
      }
      if (input.startsWith('-')) {
        return input.substring(1);
      }
      throw ArgumentException(
        'This argument is not a valid flag or option',
        null,
        input,
      );
    }
    ```

    By updating this method with a `throw ArgumentException(...)`, it ensures that if the input doesn't start with one or two dashes, an `ArgumentException` will be thrown. This clearly signals an error to the user when they are providing invalid input.

4.  Update the `run` method in `command_runner/lib/src/command_runner_base.dart` to include a `try/catch` block for `Error` types:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    Future<void> run(List<String> input) async {
      try {
        final ArgResults results = parse(input);
        if (results.command != null) {
          T? output = await results.command!.run(results);
          // [Step 8 update] use onOutput
          if (onOutput != null) {
            await onOutput!(output.toString());
          } else {
            print(output.toString());
          }
        }
      } on Exception catch (e) {
        if (onError != null) {
          onError!(e);
        } else {
          rethrow;
        }
      } on Error catch (e) {
        if (onError != null) {
          onError!(e);
        } else {
          rethrow;
        }
      }
    }
    ```

    This change handles `Error` types in addition to `Exception` types. If an `Error` is caught, the `onError` handler is called if provided; otherwise, the `Error` is rethrown. This ensures that both `Exception` and `Error` types are handled consistently.

### Task 3: Add `onOutput` argument

The `CommandRunner` currently prints output directly to the console. Let's add an `onOutput` argument to allow customizing output handling.

1.  Update the `CommandRunner` constructor to accept an optional `onOutput` handler:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    class CommandRunner<T> {
      // [Step 8 update] add onOutput argument
      CommandRunner({this.onOutput, this.onError});

      // [Step 8 update] add onOutput member
      /// If not null, this method is used to handle output. Useful if you want to
      /// execute code before the output is printed to the console, or if you
      /// want to do something other than print output the console.
      /// If null, the onInput method will [print] the output.
      FutureOr<void> Function(String)? onOutput;

      FutureOr<void> Function(Object)? onError;

      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      UnmodifiableSetView<Command<T>> get commands =>
          UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});
    ```

    This adds an optional `onOutput` argument to the `CommandRunner` constructor. The `onOutput` argument is a function that takes a `String` as input and returns a `FutureOr<void>`. This allows the user to perform asynchronous operations before printing the output to the console, or to do something other than printing to the console.

2.  Modify the `run` method to use the `onOutput` handler:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    Future<void> run(List<String> input) async {
      try {
        final ArgResults results = parse(input);
        if (results.command != null) {
          T? output = await results.command!.run(results);
          // [Step 8 update] use onOutput
          if (onOutput != null) {
            await onOutput!(output.toString());
          } else {
            print(output.toString());
          }
        }
      } on Exception catch (e) {
        if (onError != null) {
          onError!(e);
        } else {
          rethrow;
        }
      } on Error catch (e) {
        if (onError != null) {
          onError!(e);
        } else {
          rethrow;
        }
      }
    }
    ```

    This updates the `run` method to use the `onOutput` handler if it is provided. If `onOutput` is not provided, the output is printed to the console using the `print` function.

3.  Update `cli/bin/cli.dart` to use the `onOutput` handler:

    ```dart title="cli/bin/cli.dart"
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>(
        // [Step 8 update] added
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

    This code provides an `onOutput` handler that calls the `write` function from `command_runner/lib/src/console.dart`. This allows the output to be formatted and printed to the console with a delay between each line.

### Task 4: Provide an example

Let's provide a complete example of how to use the `command_runner` package.

1.  Create the file `command_runner/example/command_runner_example.dart`.

2.  Add the following code to `command_runner/example/command_runner_example.dart`:

    ```dart title="command_runner/example/command_runner_example.dart"
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    class PrettyEcho extends Command<String> {
      PrettyEcho() {
        addFlag(
          'blue-only',
          abbr: 'b',
          help: 'When true, the echoed text will all be blue.',
        );
      }

      @override
      String get name => 'echo';

      @override
      bool get requiresArgument => true;

      @override
      String get description => 'Print input, but colorful.';

      @override
      String? get help =>
          'echos a String provided as an argument with ANSI coloring,';

      @override
      String? get valueHelp => 'STRING';

      @override
      FutureOr<String> run(ArgResults arg) {
        // if (arg.commandArg == null) {
        //   throw ArgumentException(
        //     'This argument requires one positional argument',
        //     name,
        //   );
        // }

        List<String> prettyWords = [];
        var words = arg.commandArg!.split(' ');
        for (var i = 0; i < words.length; i++) {
          var word = words[i];
          switch (i % 3) {
            case 0:
            // prettyWords.add(word.titleText);
            case 1:
            // prettyWords.add(word.instructionText);
            case 2:
            // prettyWords.add(word.errorText);
          }
        }

        return prettyWords.join(' ');
      }
    }

    void main(List<String> arguments) {
      final runner = CommandRunner<String>()..addCommand(PrettyEcho());

      runner.run(arguments);
    }
    ```

    This code defines a `PrettyEcho` command that takes a string as input and prints it to the console with ANSI coloring. It also adds a `blue-only` flag that, if set, will print the text in blue.

    This example demonstrates how to create a command, add options to it, and implement the `run` method to perform the command's logic.

### Task 5: Run the application

Test the completed `CommandRunner` and the example command.

1.  Open your terminal and navigate to the `cli` directory.

2.  Run the command `dart run bin/cli.dart help`.

    You should see the enhanced help output with detailed command and option usage.

3.  Run the command `dart run ../command_runner/example/command_runner_example.dart echo "Hello, world!"`.

    You should see the output "Hello, world!" printed to the console with ANSI coloring.

## Review

In this lesson, you learned about:

* Using `StringBuffer` for efficient string concatenation.
* Improving the `HelpCommand` to display detailed command and option usage.
* Completing the `CommandRunner` class to handle command execution.
* Adding an `onOutput` argument to `CommandRunner` for customizing output handling.
* Seeing an example of how to use the `command_runner` package.

## Quiz

**Question 1:** What is the purpose of the `StringBuffer` class in Dart?

* A) To store a fixed-size string.
* B) To efficiently build up strings piece by piece.
* C) To format strings for output.
* D) To encrypt strings for security.

**Question 2:** What is the purpose of the `onOutput` argument in the `CommandRunner` class?

* A) To specify the format of the output.
* B) To specify the file to write the output to.
* C) To customize the handling of the output.
* D) To suppress the output.

## Next lesson

In the next lesson, you will prepare for part 3 of this guide by creating the `wikipedia` package.