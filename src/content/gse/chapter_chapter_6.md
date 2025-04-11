---
title: "Chapter 6: Error Handling"
description: "Learn about Exceptions, errors, `try/catch`, `throw`, `rethrow`"
---

# Chapter 6: Error Handling
Learn about Exceptions, errors, `try/catch`, `throw`, `rethrow`

[Video Placeholder]

In this lesson, we'll focus on making our command-line application more robust by implementing error handling. We'll cover Dart's exception handling mechanisms, including `try/catch` blocks, `throw`, and `rethrow`. We'll also create a custom exception class, `ArgumentException`, and integrate error handling into our `CommandRunner` to gracefully handle invalid user input and other potential issues. By the end of this lesson, you'll be able to write code that anticipates errors, handles them effectively, and provides informative feedback to the user.

## Background / Key Concepts
*   **Exceptions:** Exceptions are runtime errors that disrupt the normal flow of a program. In Dart, exceptions are objects that can be `throw`n and `catch`ed.
*   **Errors:** Errors represent more serious problems than Exceptions, often indicating issues with the program's underlying state or the Dart runtime itself. Errors are typically not caught.
*   **`try/catch`:** A mechanism for handling exceptions. The `try` block contains code that might throw an exception, and the `catch` block contains code that is executed if an exception is thrown.
*   **`throw`:** A statement used to explicitly raise an exception. You can `throw` predefined exception objects or create your own custom exception classes.
*   **`rethrow`:** A statement used within a `catch` block to re-raise the exception that was caught. This is useful when you want to perform some cleanup or logging in the `catch` block but still allow the exception to propagate up the call stack.
*   **Custom Exceptions:** Creating your own exception classes allows you to represent specific error conditions in your application and provide more context about the error.

## Set up
Make sure you have completed Chapter 5 and have a working Dart project set up with the `cli` and `command_runner` packages.

## Tasks
In this lesson, we'll create a custom `ArgumentException` class in the `command_runner` package. We will also add error handling to the `CommandRunner` class to handle the cases where the user enters the wrong arguments or options into the CLI program.

### Create a Custom `ArgumentException` Class
1.  Open `command_runner/lib/src/exceptions.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    // [Step 6 updates] The entire file
    class ArgumentException extends FormatException {
      /// The command that was parsed before discovering the error.
      ///
      /// This will be empty if the error was on the root parser.
      final String? command;

      /// The name of the argument that was being parsed when the error was
      /// discovered.
      final String? argumentName;

      ArgumentException(
        super.message, [
        this.command,
        this.argumentName,
        super.source,
        super.offset,
      ]);
    }
    ```

3.  **Explanation:**

    *   `class ArgumentException extends FormatException { ... }`: This defines a new class called `ArgumentException` that extends the built-in `FormatException` class. By extending `FormatException`, we inherit the standard behavior of exceptions related to formatting issues.
    *   `final String? command;`: A final field that stores the name of the command that was being parsed when the exception occurred.
    *   `final String? argumentName;`: A final field that stores the name of the argument that was being parsed when the exception occurred.
    *   `ArgumentException(super.message, [this.command, this.argumentName, super.source, super.offset]);`: The constructor for the `ArgumentException` class. It takes the error message, command name, argument name, source, and offset as parameters. The `super` keyword is used to call the constructor of the superclass (`FormatException`).

### Export `exceptions.dart`
1.  Open `command_runner/lib/command_runner.dart` in your code editor.

2.  Add the following line to the file:

    ```dart
    export 'src/exceptions.dart';
    ```

    This line exports the `exceptions.dart` file, making the `ArgumentException` class available to anyone who imports the `command_runner` package.

### Implement Error Handling in `CommandRunner`
1.  Open `command_runner/lib/src/command_runner_base.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      // [Step 6 update]
      CommandRunner({this.onError});

      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      UnmodifiableSetView<Command<T>> get commands =>
          UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});

      // [Step 6 update]
      FutureOr<void> Function(Object)? onError;

      Future<void> run(List<String> input) async {
        // [Step 6 update] try/catch added
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            T? output = await results.command!.run(results);
            print(output.toString());
          }
        } on Exception catch (exception) {
          if (onError != null) {
            onError!(exception);
          } else {
            rethrow;
          }
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
      // [Step 6 update] This method
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

      // [Step 6 update] _removeDash added
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

      // [Step 6] method added - called in [addCommand] method
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

    *   `CommandRunner({this.onError});`: Constructor now takes an optional `onError` callback.
    *   `FutureOr<void> Function(Object)? onError;`: A field that represents the error callback to be used.
    *   `try { ... } on Exception catch (exception) { ... }`: The `run` method is now wrapped in a `try/catch` block to handle exceptions that might occur during the parsing or execution of a command.
    *   `if (onError != null) { onError!(exception); } else { rethrow; }`: Inside the `catch` block, we check if an `onError` callback was provided. If so, we call the callback with the exception object. Otherwise, we `rethrow` the exception, allowing it to propagate up the call stack.
    *   The `parse` method now has a number of `throw ArgumentException` calls, which will trigger the `catch` block in the `run` method if an error is encountered.
    *   `String _removeDash(String input) { ... }`: A method to remove the dash from a string, making the code cleaner.
    *   `bool _validateArgument(Argument arg) { ... }`: A method to validate arguments when a command is added, throwing a `ArgumentError` if an argument already exists.

### Update `cli/bin/cli.dart`

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

    // [Step 6 update] Add onError method
    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>(
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

    *   `CommandRunner<String>(onError: (Object error) { ... })`: The `CommandRunner` constructor now takes an `onError` callback function. This function is called whenever an exception occurs during the parsing or execution of a command.
    *   `if (error is Error) { throw error; }`: Inside the `onError` callback, we check if the error is an `Error` object. If so, we `throw` the error, allowing it to propagate up the call stack.
    *   `if (error is Exception) { print(error); }`: If the error is an `Exception` object, we print the error message to the console. This provides informative feedback to the user without crashing the application.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following commands and observe the output:

    ```bash
    dart run bin/cli.dart
    ```

    Output:

    ```bash
    ArgumentException: The first word of input must be a command.
    ```

    ```bash
    dart run bin/cli.dart help not_a_real_command
    ```

    Output:

    ```bash
    ArgumentException: Unknown option not_a_real_command
    ```

[Pop out placeholder: Experiment with different command-line arguments and observe how the program responds. Try entering invalid commands, missing options, or other errors to trigger the exception handling mechanism. Also, try commenting out the `onError` callback in `cli/bin/cli.dart` to see how the exceptions are handled when no callback is provided.]

## Review

In this lesson, you learned how to:

*   Use `try/catch` blocks to handle exceptions in Dart.
*   Use the `throw` statement to explicitly raise exceptions.
*   Use the `rethrow` statement to re-raise exceptions after performing some cleanup or logging.
*   Create custom exception classes to represent specific error conditions in your application.
*   Implement error handling in the `CommandRunner` to gracefully handle invalid user input and other potential issues.

**Quiz Question:**

What is the purpose of the `rethrow` statement in Dart?

*   [Option A] To define a constant variable.
*   [Option B] To raise a new exception.
*   [Option C] To re-raise the exception that was caught.
*   [Option D] To import a package.

## Next lesson

In the next lesson, we'll explore more advanced Dart features like enhanced enums and extensions to further improve the user experience of our command-line application.