---
title: "Chapter 8: `command_runner` Polish"
description: "Learn about `StringBuffer`, completing the `CommandRunner`, adding an `onOutput` argument, and improving the `HelpCommand`."
---

# Chapter 8: `command_runner` Polish
Learn about `StringBuffer`, completing the `CommandRunner`, adding an `onOutput` argument, and improving the `HelpCommand`.

[Video Placeholder]

In this lesson, we'll be putting the final touches on our `command_runner` package. We'll improve the `HelpCommand` to provide more detailed usage information, complete the implementation of the `CommandRunner` class, add an `onOutput` argument for customizing output handling, and provide a complete example of how to use the package. By the end of this lesson, you'll have a robust and reusable command-line framework that you can use in your own Dart projects.

## Background / Key Concepts
*   **`StringBuffer`:** A class in Dart that allows you to efficiently build strings by concatenating multiple pieces of text. It's more performant than repeatedly using the `+` operator for string concatenation, especially when dealing with large strings or many concatenations.
*   **Command-Line Framework:** A set of classes and tools that simplify the process of creating command-line applications. Our `command_runner` package is an example of a command-line framework.
*   **Customizable Output Handling:**  Providing a way for users to customize how the output of a command is handled. This can be useful for logging, formatting, or redirecting the output to different destinations.

## Set up
Make sure you have completed Chapter 7 and have a working Dart project set up with the `cli` and `command_runner` packages.

## Tasks
In this lesson, we'll be improving the `HelpCommand` and `CommandRunner` classes, to be more robust and complete.

### Improve the `HelpCommand` Output with `StringBuffer`
1.  Open `command_runner/lib/src/help_command.dart` in your code editor.

2.  Replace the existing `run` method with the following:

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

      // [step 8] new command
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

3.  **Explanation:**

    *   **`final buffer = StringBuffer();`:** Creates a new `StringBuffer` object.  `StringBuffer` is more efficient for string concatenation.
    *   **`buffer.writeln(runner.usage.titleText);`:** Writes the runner usage to the buffer.
    *   **`if (args.flag('verbose')) { ... }`:** checks for verbose flag.
        *   **`for (var cmd in runner.commands) { buffer.write(_renderCommandVerbose(cmd)); }`:** If the verbose flag is true, this iterates over each command and runs the private method `_renderCommandVerbose`.
    *   **`if (args.hasOption('command')) { ... }`:** checks for command flag.
        *   **`var cmd = runner.commands.firstWhere((command) => command.name == input, orElse: () { throw ArgumentException('Input ${args.commandArg} is not a known command.',); },);`:** Throws error if the command doesn't exist.
        *   **`return _renderCommandVerbose(cmd);`:** Runs the private `_renderCommandVerbose` method, and returns its value.
    *   **`for (var command in runner.commands) { buffer.writeln(command.usage); }`:** Otherwise, iterates over each command and adds each command's basic usage info to the buffer.
    *   **`return buffer.toString();`:** Returns the String in the buffer.
    *   **`String _renderCommandVerbose(Command cmd) { ... }`:** renders the commands to verbose mode.
        *   **`final indent = ' ' * 10;`:** defines indentation for the CLI output.
        *   **`buffer.writeln(cmd.usage.instructionText);`:** Prints the usage of the command and adds color.
        *   **`buffer.writeln('$indent ${cmd.help}');`:** Print the help information, with indentation.
        *   **`if (cmd.valueHelp != null) { ... }`:** if it has a value, print the value information.
        *   **`buffer.writeln('$indent Options:');`:** Prints the 'Options:' label.
        *   **`for (var option in cmd.options) { buffer.writeln('$indent ${option.usage}'); }`:** Prints each option for the command.

### Add `onOutput` Argument to `CommandRunner`
1.  Open `command_runner/lib/src/command_runner_base.dart` in your code editor.

2.  Replace the existing `CommandRunner` class definition with the following:

    ```dart
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
          print(e);
        }
      }

      void addCommand(Command<T> command) {
        if (_validateArgument(command)) {
          _commands[command.name] = command;
          command.runner = this;
        }
      }

      /// Parses the arguments passed into the program
      /// This demo [CommandRunner] package requires a stricter structure than pkg:args.
      ///
      /// The following inputs would be parsed successfully.
      /// Minimum input:
      /// ```bash
      /// $ dart <executable>
      /// ```
      ///
      /// Only commands are top level inputs. There are no flags or options on the base executable.
      /// ```bash
      /// $ dart <executable> <command>
      /// ```
      ///
      /// Commands can take one position arg, which is a [String]. The positional arg can
      /// appear anywhere in the input (i.e. after options).
      /// ```bash
      /// $ dart <executable> <command> "positional arg"
      /// ```
      ///
      /// Commands can have options (including flags).
      /// Options take one arg, which is a [String]. It must immediately follow the option.
      /// Flags are [Option] objects that take no arguments, and are parsed into [bool] types
      /// ```bash
      /// $ dart <executable> <command> --<option> "arg" --<flag>
      /// ```
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

      String _removeDash(String input) {
        if (input.startsWith('--')) {
          return input.substring(2);
        }
        if (input.startsWith('-')) {
          return input.substring(1);
        }
        return input;
      }

      /// Returns usage for the executable only.
      /// Should be overridden if you aren't using [HelpCommand]
      /// or another means of printing usage.
      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }

      bool _validateArgument(Argument arg) {
        if (_commands.containsKey(arg.name)) {
          // This indicates a bug in the code of the consumer of this API that
          // needs to be caught at compile time.
          throw ArgumentError('Input ${arg.name} already exists.');
        }

        return true;
      }
    }
    ```

3.  **Explanation:**

    *   **`CommandRunner({this.onOutput, this.onError});`:** The `CommandRunner` constructor now takes an optional `onOutput` callback function.
    *   **`FutureOr<void> Function(String)? onOutput;`:** A field that represents the output callback to be used.
    *   **`if (onOutput != null) { await onOutput!(output.toString()); } else { print(output.toString()); }`:** Inside the `run` method, we check if an `onOutput` callback was provided. If so, we call the callback with the output of the command. Otherwise, we print the output to the console using `print()`.

### Update `cli/bin/cli.dart` to use `onOutput`
1.  Open `cli/bin/cli.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
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

3.  **Explanation:**

    *   **`onOutput: (String output) async { await write(output); }`:** The `CommandRunner` constructor now takes an `onOutput` callback function. This function is called with the result of the command, and passed to the `write` function.

### Complete `CommandRunner` by Adding Validation Logic
1.  Open `command_runner/lib/src/command_runner_base.dart` in your code editor.

2.  Replace the existing `_validateArgument` method with the following:

    ```dart
      bool _validateArgument(Argument arg) {
        if (_commands.containsKey(arg.name)) {
          // This indicates a bug in the code of the consumer of this API that
          // needs to be caught at compile time.
          throw ArgumentError('Input ${arg.name} already exists.');
        }

        return true;
      }
    ```

3.  **Explanation:**

    *   The logic from this method was extracted from the `addCommand` method.  It is unchanged.

### Example
1.  Open `command_runner/example/command_runner_example.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
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

3.  **Explanation:**

    *   **`class PrettyEcho extends Command<String> { ... }`:** This class defines a command called `echo`. The `<String>` defines the generic type, which determines the return type of the `run` method.
        *   `PrettyEcho() { addFlag(...); }`: Adds a flag to the command.
        *   `String get name => 'echo';`: overrides name.
        *   `bool get requiresArgument => true;`: overrides requiresArgument.
        *   `String get description => 'Print input, but colorful.';`: overrides the description.
        *    `FutureOr<String> run(ArgResults arg) { ... }`: This is the function that determines the command operation.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the `command_runner` directory.

3.  Run the following command and observe the output:

    ```bash
    dart run example/command_runner_example.dart help
    ```

    You should now see the output formatted with colors and verbose information about the command:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?] (in light blue)
     echo:  Print input, but colorful. (in yellow)
             echos a String provided as an argument with ANSI coloring,
              Options:
             --blue-only, -b: When true, the echoed text will all be blue.
    ```

4.  Run the following command and observe the output:

    ```bash
    dart run example/command_runner_example.dart echo hello
    ```

    You should now see the output, but without any special color formatting.

## Review
In this lesson, you learned how to:

*   Use `StringBuffer` to efficiently build strings.
*   Add an `onOutput` argument to the `CommandRunner` to customize output handling.
*   Improve the `HelpCommand` output to provide more detailed usage information.
*   Use an example CLI program.

**Quiz Question:**

What is the purpose of the `StringBuffer` class in Dart?
*   [Option A] To define constant variables.
*   [Option B] To efficiently build strings by concatenating multiple pieces of text.
*   [Option C] To create new objects.
*   [Option D] To import a package.

## Next lesson

In the next lesson, we will set up the wikipedia package to create the wikipedia CLI program.