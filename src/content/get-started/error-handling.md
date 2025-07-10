---
title: Error handling
short-title: Error handling
description: >-
  Improve app robustness by handling errors. Learn about exceptions, errors,
  `try/catch`, `throw`, and `rethrow`.
prevpage:
  url: /get-started/object-oriented
  title: Object-oriented Dart programming
nextpage:
  url: /get-started/advanced-oop
  title: Advanced OOP-adjacent features
---

{% include 'fwe-wip-warning.md' %}

In this chapter, you'll learn how to make your application more robust by
handling errors gracefully. You'll explore exceptions, `try/catch` blocks, and
how to create custom exceptions to manage errors in a structured way.

:::secondary What you'll learn

* Understand the difference between errors and exceptions in Dart.
* Use `try/catch` blocks to handle exceptions.
* `throw` exceptions to signal errors.
* Create a custom exception class.
* `rethrow` exceptions to propagate them up the call stack.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* Have completed Chapter 5 and have a working Dart development environment with
  the `dartpedia` project.
* Understand basic programming concepts like functions and classes.

## Tasks

In this chapter, you will improve the robustness of your `command_runner`
package by implementing error handling. You'll create a custom exception class
and add error handling to the `CommandRunner` to gracefully manage errors that
may occur during command execution.

### Task 1: Create a custom ArgumentException

First, define a custom exception class called `ArgumentException` to
represent errors related to command-line arguments.

1.  Create the file `command_runner/lib/src/exceptions.dart`. This file will
    contain the definition for your `ArgumentException` class.

1.  Define a class called `ArgumentException` that `extends` `FormatException`.

    ```dart title="command_runner/lib/src/exceptions.dart"
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

    This class extends `FormatException`, which is a built-in Dart exception
    class. It includes additional properties to store the command and argument
    name associated with the error. This provides more context when handling the
    exception.

    * `command`: The command that was being processed when the exception
    occurred.
    * `argumentName`: The name of the argument that caused the exception.


## Task 2: Implement error handling in CommandRunner

Next, update the `CommandRunner` class to handle potential errors
gracefully. This involves adding an error-handling callback, using `try/catch`
to manage exceptions, and throwing your new `ArgumentException` when the user
provides bad input.

1.  Add the necessary imports.

    In `command_runner/lib/src/command_runner_base.dart`, add imports for
    `dart:async` (to use `FutureOr`) and your new `exceptions.dart` file.

    ```dart
    import 'dart:async'; // Add this line
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart'; // Add this line
    ```

1.  Add an `onError` callback to the `CommandRunner`.

    Modify the CommandRunner to accept an optional `onError` function in its
    constructor. This will allow the user of your package to define their own
    error-handling logic.

    ```dart
    class CommandRunner {
    // Add a constructor that accepts the optional callback.
    CommandRunner({this.onError});

    final Map<String, Command> _commands = <String, Command>{};

    UnmodifiableSetView<Command> get commands =>
        UnmodifiableSetView<Command>(<Command>{..._commands.values});

    // Define the onError property.
    FutureOr<void> Function(Object)? onError;

    // ... rest of the class
    }
    ```
    
    This change introduces a nullable `onError` property. The
    `FutureOr<void> Function(Object)?` type means it's a function that takes an
    `Object` and returns a `Future` or nothing, and it might be null.

1.  Update the run method to use `try`/`catch`.

    Wrap the logic inside the run method in a `try`/`catch` block. If an exception
    occurs, this block will "catch" it and either pass it to the `onError`
    callback or rethrow it if no callback was provided. `rethrow` preserves the
    original error and stack trace.

    ```dart
    Future<void> run(List<String> input) async {
    // [Step 6 update] try/catch added
        try {
            final ArgResults results = parse(input);
            if (results.command != null) {
                Object? output = await results.command!.run(results);
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
    ```

1.  Add validation to the `parse` method.

    Finally, replace the existing `parse` method in `command_runner_base.dart`
    with the following updated version. This new version is much more robust.
    It's filled with checks that will throw your custom `ArgumentException`
    whenever it detects invalid user input.

    ```dart
    // [Step 6 update] This method is replaced entirely.
    ArgResults parse(List<String> input) {
        ArgResults results = ArgResults();
        if (input.isEmpty) return results;

        // Throw an exception if the command is not recognized.
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

        // Throw an exception if multiple commands are provided.
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
                // Throw an exception if an option is not recognized for the given command.
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
                    inputOptions[option] = true;
                    i++;
                    continue;
                }

                if (option.type == OptionType.option) {
                // Throw an exception if an option requires an argument but none is given.
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
                    i++;
                }
            } else {
                // Throw an exception if more than one positional argument is provided.
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
    ```
    
    This updated parse method now actively defends against bad input.
    Specifically, the new throw statements handle several common error cases:

    *   Unknown commands: The first `if`/`else` block ensures the first argument is
        a valid command.
    *   Multiple commands: It checks that the user hasn't tried to run more than
        one command at a time.
    *   Unknown Options: The `orElse` parameter within `firstWhere` now throws an
        exception if a user provides a flag or option (like `--foo`) that
        hasn't been defined for that command.
    *   Missing option values: It ensures that an option (like `--output`) is
        followed by a value and not another option or the end of the input.
    *   Too many arguments: It enforces a rule that commands can only have one
        positional argument.

### Task 3: Update cli.dart to use the new error handling

Modify `cli/bin/cli.dart` to use the new error handling in `CommandRunner`.

1.  Open the `cli/bin/cli.dart` file.

1.  Update the `main` function to pass in an `onError` method to the
    `CommandRunner`:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      // [Step 6 update] Add onError method
      var commandRunner = CommandRunner(
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

    This code passes in an `onError` callback function to the `CommandRunner`
    constructor. If an error occurs during the execution of a command, the
    `onError` callback function is called with the error object. The callback
    checks whether the error is an `Error` or an `Exception`. If it's an
    `Error`, it's rethrown. If it's an `Exception`, it's printed to the console.

### Task 4: Update command_runner library exports

Make `ArgumentException` available to the `command_runner` library.

1.  Open `command_runner/lib/command_runner.dart`, and add the following
    exports:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;
    
    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';
    export 'src/exceptions.dart'; // Add this line
    
    // TODO: Export any libraries intended for clients of this package.
    ```

    This ensures that the `ArgumentException` is available to consumers of the
    `command_runner` package.

### Task 5: Test the new error handling

Test the new error handling by running the application with invalid arguments.

1.  Open your terminal and navigate to the `cli` directory.

1.  Run the command `dart run bin/cli.dart invalid_command`.

    You should see the following output:

    ```bash
    ArgumentException: The first word of input must be a command.
    ```

    This confirms that the `ArgumentException` is being thrown and caught
    correctly.

## Review

In this lesson, you learned about:

*   The difference between `Error` and `Exception` in Dart.
*   Using `try/catch` blocks to handle exceptions.
*   `throw` exceptions to signal errors.
*   Creating a custom exception class to represent specific types of errors.
*   `rethrow` exceptions to propagate them up the call stack.

## Quiz

**Question 1:** What is the purpose of the `try/catch` block in Dart?

* A) To define a new class.
* B) To handle exceptions that may occur during the execution of code.
* C) To declare a variable.
* D) To define a function.

**Question 2:** What is the purpose of the `throw` keyword in Dart?

* A) To declare a new class.
* B) To handle exceptions that may occur during the execution of code.
* C) To signal an error or exception.
* D) To define a function.

**Question 3:** What is the purpose of the `rethrow` keyword in Dart?

* A) To create a new exception.
* B) To catch an exception.
* C) To propagate an exception up the call stack.
* D) To ignore an exception.

## Next lesson

In the next lesson, you'll learn about advanced object-oriented features in
Dart, including enhanced enums and extensions. You'll improve the output
formatting and add color to your CLI application.
