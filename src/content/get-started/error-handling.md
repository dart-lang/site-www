---
title: Error Handling in Dart
short-title: Error Handling
description: >-
  Improve the robustness of your Dart applications by learning how to handle
  errors and exceptions using `try/catch`, `throw`, and custom exceptions.
prevpage:
  url: /get-started/object-oriented
  title: Object oriented dart
nextpage:
  url: /get-started/advanced-oop
  title: Advanced OOP-adjacent features
---

{% include 'fwe-wip-warning.md' %}

In this chapter, you'll learn how to make your Dart applications more resilient
by implementing robust error handling. You'll focus on using `try/catch` blocks
to gracefully handle exceptions, creating custom exceptions to represent
specific error conditions, and improving the error reporting of the
`CommandRunner` class.

:::secondary What you'll learn

* Understand the difference between `Error` and `Exception` in Dart.
* Use `try/catch` blocks to handle exceptions.
* `Throw` exceptions to signal errors.
* `Rethrow` exceptions to propagate them up the call stack.
* Create custom exception classes.
* Implement error handling in the `CommandRunner` class.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* Completed Chapter 5 and have a working `dartpedia` project with the
    `command_runner` package.
* Are aware that errors can occur when your program runs, either from the code itself or because of external issues (like a user entering invalid data).

## Tasks

Let's improve the robustness of our CLI app by implementing error handling in
the `command_runner` package.

### Task 1: Understand Errors and Exceptions

In Dart, as in many languages, it's important to understand the distinction
between `Error` and `Exception`.

* **`Error`**: Represents serious problems that a reasonable application
    shouldn't try to catch. These are usually unrecoverable, like running out
    of memory.
* **`Exception`**: Represents conditions that an application might want to
    catch and handle. These are typically recoverable, such as an invalid user
    input.

### Task 2: Create a Custom Exception

To handle specific errors related to command-line arguments, let's create a
custom exception called `ArgumentException`.

1. Create the file `command_runner/lib/src/exceptions.dart`.

2. Add the following `ArgumentException` class to `exceptions.dart`:

    We'll start by defining the basic structure of our custom exception class. All exceptions in Dart should extend from the `Exception` class or a subclass of it. In our case, `FormatException` is a suitable base class for errors related to invalid input.

    ```dart
    class ArgumentException extends FormatException {
      // Class members will go here
    }
    ```

    This establishes `ArgumentException` as a type of `FormatException`, indicating it deals with issues in input format.

    Now, let's add fields to provide more specific information about where the argument error occurred. We'll include optional fields for the `command` and `argumentName`.

    ```dart
    class ArgumentException extends FormatException {
      /// The command that was parsed before discovering the error.
      ///
      /// This will be empty if the error was on the root parser.
      final String? command;

      /// The name of the argument that was being parsed when the error was
      /// discovered.
      final String? argumentName;

      // Constructor will go here
    }
    ```

    We've added `command` and `argumentName` as nullable `String` fields. These fields are `final` because once an `ArgumentException` is created, its contextual information shouldn't change. They provide valuable details to help debug where in the command parsing the error occurred.

    Next, we'll define the constructor for our `ArgumentException` class. This constructor will allow us to initialize the exception with a message and optionally the command and argument name.

    ```dart
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

    The `ArgumentException` constructor takes `super.message` as its first argument, which means it's passing the error message directly to the `FormatException` superclass constructor. The `[this.command, this.argumentName, super.source, super.offset]` syntax indicates optional positional parameters that are assigned to the `command` and `argumentName` fields of this class, and also passed to the `FormatException` superclass. This constructor allows us to create an `ArgumentException` with a descriptive message and optional context about the command and argument involved in the error.

### Task 3: Throw an Exception

Now, let's modify the `CommandRunner` class to throw an `ArgumentException`
when it encounters an invalid argument.

1.  Open `command_runner/lib/src/command_runner_base.dart`.

2.  Modify the `parse` method to throw an `ArgumentException` if the first
    argument is not a known command:

    We'll begin by looking at the existing `parse` method and setting up the basic structure for the error check.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart'; // Ensure this import is present

    class CommandRunner<T> {
      // ... (existing code)

      ArgResults parse(List<String> input) {
        ArgResults results = ArgResults();
        if (input.isEmpty) return results;

        if (_commands.containsKey(input.first)) {
          results.command = _commands[input.first];
        } else {
          // This is where we'll add our exception logic
        }
        return results;
      }

      // ... (existing code)
    }
    ```

    The `parse` method currently checks if the input is empty or if the first input word is a known command. We're focusing on the `else` block where an unknown command is detected.

    Now, let's add the `throw` statement within the `else` block to raise our custom `ArgumentException`.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      // ... (existing code)

      ArgResults parse(List<String> input) {
        ArgResults results = ArgResults();
        if (input.isEmpty) return results;

        if (_commands.containsKey(input.first)) {
          results.command = _commands[input.first];
        } else {
          throw ArgumentException(
            'The first word of input must be a command.',
            null,
            input.first,
          );
        }
        return results;
      }

      // ... (existing code)
    }
    ```

    By adding `throw ArgumentException(...)`, we're explicitly signaling an error when the first argument doesn't match a registered command. We provide a clear error message and pass `input.first` as the `argumentName` to give context about the invalid input. This ensures that any attempt to parse an unrecognized command will now result in a structured error.

3.  Update the `addCommand` method in `command_runner/lib/src/command_runner_base.dart` to throw an `ArgumentError` when a duplicate command name is added:

    We'll start with the existing `addCommand` method, focusing on the check for duplicate command names.

    ```dart
    class CommandRunner<T> {
      // ... (existing fields)
      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      void addCommand(Command<T> command) {
        if (_commands.containsKey(command.name)) {
          // This is where we'll add our error handling
        }

        _commands[command.name] = command;
        command.runner = this;
      }
      // ... (rest of the class)
    }
    ```

    The `addCommand` method ensures that each command added has a unique name. If a command with the same name already exists, we need to prevent it from being added, and signal that an invalid operation has occurred.

    Now, we'll introduce the `throw ArgumentError` statement. `ArgumentError` is a built-in Dart `Error` class suitable for indicating invalid arguments to a function, which applies here since providing a duplicate command name is an invalid argument to `addCommand`.

    ```dart
    class CommandRunner<T> {
      // ... (existing fields)
      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      void addCommand(Command<T> command) {
        if (_commands.containsKey(command.name)) {
          // This indicates a bug in the code of the consumer of this API that
          // needs to be caught at compile time.
          throw ArgumentError('Input ${command.name} already exists.');
        }

        _commands[command.name] = command;
        command.runner = this;
      }
      // ... (rest of the class)
    }
    ```

    By adding `throw ArgumentError(...)`, we ensure that if a developer tries to register a command with a name that already exists, an `ArgumentError` will be thrown. This immediately alerts the developer to a misuse of the API during development, rather than allowing for unexpected behavior at runtime. The error message clearly indicates which command name caused the problem.

### Task 4: Catch Exceptions

To handle the `ArgumentException` that the `parse` method might throw, we'll
use a `try/catch` block in the `run` method of the `CommandRunner` class.

1.  Modify the `run` method in `command_runner/lib/src/command_runner_base.dart`
    to include a `try/catch` block:

    Let's start by wrapping the core logic of the `run` method in a `try` block. This block will contain the code that might potentially throw an exception.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      // ... (existing code)

      Future<void> run(List<String> input) async {
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            T? output = await results.command!.run(results);
            print(output.toString());
          }
          // The catch block will go here
        } on Exception catch (exception) {
          // Exception handling logic will go here
        }
      }

      // ... (existing code)
    }
    ```

    The `try` block now encloses the call to `parse(input)` and the subsequent command execution. This ensures that any exception thrown during these operations will be captured.

    Now we'll add a `catch` block to handle exceptions. For now, we'll catch any `Exception` and then `rethrow` it. `rethrow` is important because it allows higher-level callers to still handle the exception, which is useful when you want to log or perform some immediate action but don't want to fully consume the exception at this level.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      // ... (existing code)

      Future<void> run(List<String> input) async {
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            T? output = await results.command!.run(results);
            print(output.toString());
          }
        } on Exception catch (exception) {
          // TODO: implement exception handling.
          rethrow;
        }
      }

      // ... (existing code)
    }
    ```

    The `on Exception catch (exception)` block specifies that we are catching any object that is an `Exception` (or a subclass of `Exception`). The `exception` variable gives us access to the caught exception object. The `rethrow` statement means that after this `catch` block potentially performs some actions (like logging, which we will add later), the exception will continue to propagate up the call stack as if it was never caught at this level. This allows for centralized error handling higher up in the application.

### Task 5: Add an `onError` handler

Right now, the `CommandRunner` will always rethrow any exceptions that it
catches. This is not ideal, as it doesn't allow the user of the
`CommandRunner` to customize the error handling behavior. To fix this, we'll
add an `onError` handler to the `CommandRunner` that the user can provide.

1.  Update the `CommandRunner` constructor to accept an optional `onError`
    handler:

    We'll begin by modifying the `CommandRunner` class to declare a new field for our `onError` handler.

    ```dart
    class CommandRunner<T> {
      // Constructor will be updated here
      // New field will be added here

      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      UnmodifiableSetView<Command<T>> get commands =>
          UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});

      // ... (existing methods)
    }
    ```

    This sets the stage for introducing a new way to handle errors within the `CommandRunner`.

    Now, we'll declare the `onError` field and update the `CommandRunner` constructor to accept it. The `onError` handler will be a function that takes an `Object` (the thrown error or exception) and returns `FutureOr<void>`. `FutureOr<void>` means it can either return `void` immediately or a `Future<void>` if the error handling is asynchronous. The `?` makes it nullable, meaning the user doesn't have to provide a handler.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      CommandRunner({this.onError}); // Update constructor

      final Map<String, Command<T>> _commands = <String, Command<T>>{};

      UnmodifiableSetView<Command<T>> get commands =>
          UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});

      FutureOr<void> Function(Object)? onError; // Declare the new field

      // ... (existing code)
    }
    ```

    The `CommandRunner({this.onError})` syntax in the constructor is a shorthand for initializing the `onError` instance variable with the value passed to the `onError` named parameter. This setup provides a flexible way for users of `CommandRunner` to inject their own error handling logic.

2.  Modify the `run` method to call the `onError` handler if one is provided:

    We'll go back to the `run` method's `catch` block, where we currently `rethrow` the exception. This is where we'll introduce the conditional call to `onError`.

    ```dart
    Future<void> run(List<String> input) async {
      try {
        final ArgResults results = parse(input);
        if (results.command != null) {
          T? output = await results.command!.run(results);
          print(output.toString());
        }
      } on Exception catch (exception) {
        // This is where we'll add the conditional call
      }
    }
    ```

    This is the point of interception where we can decide whether to delegate error handling or rethrow.

    Now, we'll add the logic to check if `onError` is provided. If it is, we call it; otherwise, we `rethrow` the exception.

    ```dart
    import 'dart:async';
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart';

    class CommandRunner<T> {
      // ... (existing code)

      Future<void> run(List<String> input) async {
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            T? output = await results.command!.run(results);
            print(output.toString());
          }
        } on Exception catch (exception) {
          if (onError != null) {
            onError!(exception); // Call the handler if it exists
          } else {
            rethrow; // Otherwise, rethrow the exception
          }
        }
      }

      // ... (existing code)
    }
    ```

    The `if (onError != null) { onError!(exception); }` block checks if the `onError` handler has been assigned. If it's not `null`, we safely call it with the caught `exception` object. The `!` is the null assertion operator, used because we've already checked for null. If `onError` is `null`, the `else { rethrow; }` block ensures that the default behavior of rethrowing the exception is maintained. This modification gives the consumer of the `CommandRunner` API the flexibility to handle exceptions as they see fit, without forcing them to catch every exception at the call site of `run`.

3.  Add `export 'src/exceptions.dart';` to `command_runner/lib/command_runner.dart` so that `ArgumentException` can be used outside the package:

    ```dart
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/exceptions.dart';
    export 'src/help_command.dart';

    // TODO: Export any libraries intended for clients of this package.
    ```

### Task 6: Implement `onError` in `cli/bin/cli.dart`

Now that you've added the `onError` handler to the `CommandRunner` class,
you can use it in your `cli/bin/cli.dart` file to customize the error
handling behavior.

1.  Open `cli/bin/cli.dart`.

2.  Modify the `main` function to provide an `onError` handler to the
    `CommandRunner`:

    Let's look at the initial `main` function and prepare to instantiate `CommandRunner` with an `onError` callback.

    ```dart
    import 'package:http/http.dart' as http; // Keep this import
    // Add new import for command_runner

    const version = '0.0.1';

    void main(List<String> arguments) async { // main is now async and awaits the runner
      var commandRunner = CommandRunner(); // Will update this line
      // Add command and run method calls
    }
    ```

    This sets the stage for integrating our new error handling capability into the CLI application's entry point.

    First, we need to import the `command_runner` package. Then, we'll instantiate `CommandRunner`, adding a generic type argument for `String` and chaining `addCommand` to register the `HelpCommand`.

    ```dart
    import 'package:http/http.dart' as http; // Keep this import
    import 'package:command_runner/command_runner.dart'; // Add this new import

    const version = '0.0.1';

    void main(List<String> arguments) async {
      var commandRunner = CommandRunner<String>() // Add <String> generic.
        ..addCommand(HelpCommand()); // Add ..addCommand call
      // Call its run method, awaiting its Future<void>
    }
    ```

    We've added the necessary import and initialized `CommandRunner<String>`, specifying that our commands will return `String` output. The `..addCommand(HelpCommand())` uses Dart's cascade operator to add the `HelpCommand` immediately after creating the runner instance. This prepares the runner to process commands.

    Now, let's add the `onError` handler directly within the `CommandRunner` constructor. This handler will define how our CLI application responds to uncaught exceptions.

    ```dart
    import 'package:http/http.dart' as http; // Keep this import
    import 'package:command_runner/command_runner.dart'; // Add this new import

    const version = '0.0.1';

    void main(List<String> arguments) async {
      var commandRunner = CommandRunner<String>(
        onError: (Object error) {
          if (error is Error) {
            throw error;
          }
          if (error is Exception) {
            print(error);
          }
        },
      )..addCommand(HelpCommand()); // Add <String> generic. Add ..addCommand call
      await commandRunner.run(arguments); // Call its run method, awaiting its Future<void>
    }
    ```

    We've provided an anonymous function as the `onError` handler. Inside this handler, we check the type of the `error` object. If it's an `Error` (representing serious, usually unrecoverable issues), we `throw` it again, allowing it to crash the application, which is typically the desired behavior for `Error`s. If it's an `Exception` (representing recoverable conditions), we simply `print(error)` to the console. This gives us a clear, user-friendly message for expected errors without terminating the application. Finally, `await commandRunner.run(arguments)` executes the command runner with the provided arguments, ensuring that the `main` function waits for the runner to complete its task, which might include handling errors.

### Task 7: Test the Error Handling

Now that you've implemented the error handling, let's test it out.

1.  Open your terminal and navigate to the `cli` directory.

2.  Run the command with an invalid command:

    ```bash
    dart run bin/cli.dart invalid_command
    ```

3.  You should see the following output:

    ```text
    Exception: The first word of input must be a command.
    ```

    This demonstrates that the `ArgumentException` is being thrown and caught
    correctly, and that the `onError` handler is printing the exception to the
    console.

### Task 8: Update Other Methods To Throw Exceptions

To provide greater code quality and information to the user, update the `_removeDash` method in `command_runner/lib/src/command_runner_base.dart` to throw an `ArgumentException` if the user provides an invalid command:

Let's look at the existing `_removeDash` method. Currently, it simply returns the input if it doesn't start with a dash. We want to make it stricter.

```dart
    String _removeDash(String input) {
    if (input.startsWith('--')) {
      return input.substring(2);
    }
    if (input.startsWith('-')) {
      return input.substring(1);
    }
    return input; // This is the line we'll change
  }
```

Now, let's update this method to throw an `ArgumentException` if the command doesn't start with a dash:

```dart
    String _removeDash(String input) {
    if (input.startsWith('--')) {
      return input.substring(2);
    }
    if (input.startsWith('-')) {
      return input.substring(1);
    }
    throw ArgumentException('The option "$input" is not valid.');
  }
```

Now, if the command doesn't start with `--` or `-`, it will throw an `ArgumentException` and display `The option "$input" is not valid`.

## Review

In this lesson, you learned about:

*   The distinction between **`Error`** and **`Exception`** in Dart.
*   Using **`try/catch`** blocks to handle exceptions.
*   Using **`throw`** to signal errors.
*   Using **`rethrow`** to propagate exceptions up the call stack.
*   Creating custom exception classes like **`ArgumentException`**.
*   Implementing custom error handling in the **`CommandRunner`** class.

## Quiz

**Question 1:** What is the main difference between an `Error` and an `Exception` in Dart?

*   A) Errors are recoverable, while exceptions are not.
*   B) Exceptions are recoverable, while errors are not.
*   C) Errors are used for input validation, while exceptions are used for network issues.
*   D) There is no difference between errors and exceptions in Dart.

**Question 2:** What does the `rethrow` keyword do in a `catch` block?

*   A) It ignores the exception.
*   B) It creates a new exception.
*   C) It propagates the exception up the call stack.
*   D) It terminates the program.

**Question 3:** Why might you create a custom exception class in Dart?

*   A) To simplify debugging.
*   B) To handle generic errors.
*   C) To represent specific error conditions in your application.
*   D) To improve performance.

## Next lesson

In the next lesson, you'll learn how to improve the output formatting and color in your Dart CLI application using enhanced enums and extensions.