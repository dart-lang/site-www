---
title: Object-oriented Dart programming
short-title: Object oriented Dart
description: >-
  Learn about object-oriented programming in Dart, including sealed and abstract
  classes, generics, inheritance, overrides, and enums. Build a framework for
  well-architected CLI apps.
prevpage:
  url: /get-started/packages-libs
  title: Packages and libraries
nextpage:
  url: /get-started/error-handling
  title: Error handling
---

{% include 'fwe-wip-warning.md' %}

In this chapter, you'll explore the power of object-oriented programming (OOP)
in Dart. You'll learn how to create classes and define relationships between
them, including **inheritance** and **abstract classes**. You'll also build a
foundation for creating well-structured CLI applications.

:::secondary What you'll learn

* Understand `sealed` and `abstract` classes and their use cases.
* Implement inheritance using the `extends` keyword and override methods.
* Work with generics to create reusable classes and methods.
* Use `FutureOr` for functions that can return a value synchronously or
    asynchronously.
* Define and use `enum` types to represent a fixed set of values.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* Have completed Chapter 4 and have a working Dart development environment with
    the `dartpedia` project.
* Are familiar with basic programming concepts like variables, functions, and
    control flow.
* Understand the concepts of packages and libraries in Dart.

## Tasks

You'll now begin building a robust command-line argument parsing framework using
OOP principles within your `command_runner` package. This involves defining
classes for commands, arguments, and options, and establishing relationships
between them.

### Task 1: Define the Argument hierarchy

First, you'll define an `Argument` class, an `Option` class, and a `Command`
class, establishing an inheritance relationship.

1.  Create the file `command_runner/lib/src/arguments.dart`. This file will
    contain the definitions for your `Argument`, `Option`, `Command`, and
    `ArgResults` classes.

2.  Define an `enum` called `OptionType`.

    ```dart title="command_runner/lib/src/arguments.dart"
    enum OptionType { flag, option }
    ```

    This `enum` represents the type of option, which can be either a **`flag`**
    (a boolean option) or a regular **`option`** (an option that takes a value).
    Enums are useful for representing a fixed set of possible values.

3.  Define a `sealed class` called `Argument`.

    Let's start by defining the basic structure of our `Argument` class. We'll
    declare it as `sealed`, which is a powerful keyword in Dart for creating
    restricted class hierarchies.

    Below the `enum` you just added, paste in the following code:

    ```dart title="command_runner/lib/src/arguments.dart"
    // Paste this new class below the enum you added
    sealed class Argument {
      String get name;
      String? get help;
    
      // In the case of flags, the default value is a bool
      // In other options and commands, the default value is String
      // NB: flags are just Option objects that don't take arguments
      Object? get defaultValue;
      String? get valueHelp;
    
      String get usage;
    }
    ```

    * The **`sealed`** keyword restricts which classes can extend or implement `Argument` to the same library, improving code safety.
    * **`name`** is a `String` that uniquely identifies the argument.
    * **`help`** is an optional `String` that provides a description.
    * **`defaultValue`** is of type `Object?` because it can be a `bool` (for flags) or a `String`.
    * **`valueHelp`** is an optional `String` to give a hint about the expected value.
    * The **`usage`** getter will provide a string showing how to use the argument.

    With the `Argument` class now fully defined, we have a common interface for
    all types of command-line arguments. Next, we'll build upon this by defining
    `Option`, a specific type of argument that extends `Argument`.

4.  Define a class called `Option` that `extends` `Argument`.

    The `Option` class will represent command-line options like `--verbose` or `--output=file.txt`. It will inherit from our `Argument` class.

    Add the following `Option` class to the bottom of your file:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option extends Argument {
      Option(
        this.name, {
        required this.type,
        this.help,
        this.abbr,
        this.defaultValue,
        this.valueHelp,
      });
    
      @override
      final String name;
    
      final OptionType type;
    
      @override
      final String? help;
    
      final String? abbr;
    
      @override
      final Object? defaultValue;
    
      @override
      final String? valueHelp;
    
      @override
      String get usage {
        if (abbr != null) {
          return '-$abbr,--$name: $help';
        }
    
        return '--$name: $help';
      }
    }
    ```

    The **`extends`** keyword establishes the inheritance relationship. The constructor uses `@override` to provide concrete implementations for the properties defined in `Argument`. It also adds `type` (using our `OptionType` enum) and an optional `abbr` for a short-form of the option. The `usage` getter is implemented to provide clear instructions to the user.

    With `Option` complete, we have a specialized type of argument. Next, we'll
    define the `Command` class, another type of argument that will represent the
    main actions a user can perform in our CLI application.

5.  Define an `abstract class` called `Command` that also `extends` `Argument`.

    The `Command` class will represent an executable action. Since it provides a template for other commands to follow, we'll declare it as **`abstract`**.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class below the Option class
    abstract class Command<T> extends Argument {
      // Properties and methods will go here
    }
    ```

    The **`abstract`** keyword means that `Command` cannot be instantiated directly. It serves as a blueprint for other classes. The `<T>` after `Command` indicates that it's a **generic** class, allowing us to specify the return type of the command's execution.

    Now, let's add the core properties. A command needs a `name` and `description`. It also needs a reference back to the `CommandRunner` that executes it.

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command<T> extends Argument {
      @override
      String get name;
    
      String get description;
    
      bool get requiresArgument => false;
    
      late CommandRunner<T> runner;
    
      @override
      String? help;
    
      @override
      String? defaultValue;
    
      @override
      String? valueHelp;
    }
    ```

    The `runner` property is of type `CommandRunner<T>`, which we will define later in `command_runner_base.dart`. To make Dart aware of this class, you must import its defining file. Add the following import to the top of `command_runner/lib/src/arguments.dart`:

    ```dart
    import '../command_runner.dart';
    ```

    Next, to give commands their own set of options, we'll use a private list and expose a read-only, **unmodifiable view** of it. This uses the `UnmodifiableSetView` class, which is part of Dart's core collections library. To use it, we must import that library.

    Update the imports at the top of your file to include `dart:collection`:

    ```dart
    import 'dart:collection'; // New import
    import '../command_runner.dart';
    ```

    Now, add the `options` list and getter to your `Command` class:

    ```dart
    abstract class Command<T> extends Argument {
      // ... existing properties ...

      @override
      String? valueHelp;


      // Add the following lines to the bottom of your Command class 

      final List<Option> _options = [];
    
      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());
    }
    ```

    To make adding options easier, we'll provide two helper methods, `addFlag` and `addOption`.

    ```dart
    abstract class Command<T> extends Argument {
      // ... existing properties and getters ...

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());
    

      // Add the following lines to the bottom of your Command class

      // A flag is an [Option] that's treated as a boolean.
      void addFlag(String name, {String? help, String? abbr, String? valueHelp}) {
        _options.add(
          Option(
            name,
            help: help,
            abbr: abbr,
            defaultValue: false,
            valueHelp: valueHelp,
            type: OptionType.flag,
          ),
        );
      }
    
      // An option is an [Option] that takes a value.
      void addOption(
        String name, {
        String? help,
        String? abbr,
        String? defaultValue,
        String? valueHelp,
      }) {
        _options.add(
          Option(
            name,
            help: help,
            abbr: abbr,
            defaultValue: defaultValue,
            valueHelp: valueHelp,
            type: OptionType.option,
          ),
        );
      }
    }
    ```

    Finally, every command must have logic to execute. The `run` method should be flexible, allowing it to return a value either immediately (synchronously) or after a delay (asynchronously). For this, we use the `FutureOr<T>` type from Dart's `async` library. This is our final required import.

    Update the imports at the top of your file to include `dart:async`:

    ```dart
    import 'dart:async'; // New import
    import 'dart:collection';
    import '../command_runner.dart';
    ```

    Now you can add the abstract `run` method and provide the `usage` implementation to complete the `Command` class.

    ```dart
    abstract class Command<T> extends Argument {
      // ... existing properties, getters, and methods ...

      void addOption(
        String name, {
        String? help,
        String? abbr,
        String? defaultValue,
        String? valueHelp,
      }) {
        _options.add(
          Option(
            name,
            help: help,
            abbr: abbr,
            defaultValue: defaultValue,
            valueHelp: valueHelp,
            type: OptionType.option,
          ),
        );
      }


      // Add the following lines to the bottom of your Command class
      FutureOr<T> run(ArgResults args);
    
      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    * **`run(ArgResults args)`**: This abstract method is where a command's logic resides. Concrete subclasses *must* implement it.
    * **`usage`**: This getter provides a simple usage string, combining the command's `name` and `description`.

    The `Command` class now provides a robust foundation for all commands in our CLI app. With our class hierarchy in place, we're ready to define `ArgResults` to hold the parsed input.

6.  Define a class called `ArgResults`.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class to the end of the file
    class ArgResults {
      Command? command;
      String? commandArg;
      Map<Option, Object?> options = {};
    
      // Returns true if the flag exists
      bool flag(String name) {
        // Only check flags, because we're sure that flags are booleans
        for (var option in options.keys.where(
          (option) => option.type == OptionType.flag,
        )) {
          if (option.name == name) {
            return options[option] as bool;
          }
        }
        return false;
      }
    
      bool hasOption(String name) {
        return options.keys.any((option) => option.name == name);
      }
    
      ({Option option, Object? input}) getOption(String name) {
        var mapEntry = options.entries.firstWhere(
          (entry) => entry.key.name == name || entry.key.abbr == name,
        );
    
        return (option: mapEntry.key, input: mapEntry.value);
      }
    }
    ```

    This class represents the results of parsing command-line arguments. It holds the detected command, any argument to that command, and a map of options. It also provides convenient helper methods like `flag`, `hasOption`, and `getOption`.

    Now you have defined the basic structure for handling commands, arguments, and options in your command-line application.

### Task 2: Update the CommandRunner class

Next, update the `CommandRunner` class to use the new `Argument` hierarchy.

1.  Open the `command_runner/lib/src/command_runner_base.dart` file.

2.  Replace the existing `CommandRunner` class with the following:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    import 'dart:collection';
    import 'dart:io';
    import 'arguments.dart';
    
    class CommandRunner<T> {
      final Map<String, Command<T>> _commands = <String, Command<T>>{};
    
      UnmodifiableSetView<Command<T>> get commands =>
          UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});
    
      Future<void> run(List<String> input) async {
        final ArgResults results = parse(input);
        if (results.command != null) {
          T? output = await results.command!.run(results);
          print(output.toString());
        }
      }
    
      void addCommand(Command<T> command) {
        // TODO: handle error (Command's can't have names that conflict)
        _commands[command.name] = command;
        command.runner = this;
      }
    
      ArgResults parse(List<String> input) {
        var results = ArgResults();
        results.command = _commands[input.first];
        return results;
      }
    
      /// Returns usage for the executable only.
      /// Should be overridden if you aren't using [HelpCommand]
      /// or another means of printing usage.
      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }
    }
    ```

    This updated `CommandRunner` class now uses the `Command` class from the `Argument` hierarchy. It includes methods for adding commands, parsing arguments, and running the appropriate command based on user input.

3.  Open `command_runner/lib/command_runner.dart`, and add the following
    exports:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;
    
    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';
    
    // TODO: Export any libraries intended for clients of this package.
    ```

    This makes the `arguments.dart`, `command_runner_base.dart`, and
    `help_command.dart` files available to other packages that depend on
    `command_runner`.

### Task 3: Create a HelpCommand

Create a `HelpCommand` that extends the `Command` class and prints usage
information.

1.  Create the file `command_runner/lib/src/help_command.dart`.

2.  Add the following code to `command_runner/lib/src/help_command.dart`:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';

    import 'arguments.dart';

    /// Prints program and argument usage.
    ///
    /// When given a command as an argument, it prints the usage of
    /// that command only, including its options and other details.
    /// When the flag 'verbose' is set, it prints options and details for all commands.
    ///
    /// This command isn't automatically added to CommandRunner instances.
    /// Packages users should add it themselves with [CommandRunner.addCommand],
    /// or create their own command that prints usage.
    class HelpCommand extends Command<String> {
      HelpCommand() {
        addFlag(
          'verbose',
          abbr: 'v',
          help: 'When true, this command will print each command and its options.',
        );
        addOption(
          'command',
          abbr: 'c',
          help:
              "When a command is passed as an argument, prints only that command's verbose usage.",
        );
      }
      @override
      String get name => 'help';
    
      @override
      String get description => 'Prints usage information to the command line.';
    
      @override
      String? get help => 'Prints this usage information';
    
      @override
      FutureOr<String> run(ArgResults args) async {
        var usage = runner.usage;
        for (var command in runner.commands) {
          usage += '\n ${command.usage}';
        }
    
        return usage;
      }
    }
    ```

    This `HelpCommand` class extends `Command` and implements the `run` method to print usage information. It also uses the `addFlag` and `addOption` methods to define its own options for controlling the output.

### Task 4: Update cli.dart to use the new CommandRunner

Modify `cli/bin/cli.dart` to use the new `CommandRunner` and `HelpCommand`.

1.  Open the `cli/bin/cli.dart` file.

2.  Replace the existing code with the following:

    ```dart title="cli/bin/cli.dart"    
    import 'package:command_runner/command_runner.dart';
    
    const version = '0.0.1';
    
    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    This code creates a `CommandRunner` instance, adds the `HelpCommand` to it using method cascading (`..addCommand`), and then runs the command runner with the command-line arguments.

### Task 5: Run the application

Test the new `CommandRunner` and `HelpCommand`.

1.  Open your terminal and navigate to the `cli` directory.

2.  Run the command `dart run bin/cli.dart help`.

    You should see the usage information printed to the console:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    This confirms that the `CommandRunner` and `HelpCommand` are working correctly.

## Review

In this lesson, you learned about:

* Defining **`sealed`** and **`abstract`** classes to create a type hierarchy.
* Implementing inheritance using the **`extends`** keyword.
* Using **generics** to create reusable classes and methods.
* Defining and using **`enum`** types to represent a fixed set of values.
* Building a basic command-line argument parsing framework using OOP principles.

## Quiz

**Question 1:** What is the purpose of a `sealed` class in Dart?

* A) To prevent a class from being instantiated.
* B) To restrict which classes can extend or implement a class.
* C) To make a class immutable.
* D) To hide the implementation details of a class.

**Question 2:** What is the difference between an `abstract` class and a regular
class in Dart?

* A) An `abstract` class cannot have any methods.
* B) An `abstract` class cannot be instantiated directly.
* C) An `abstract` class can only have private methods.
* D) There is no difference between an `abstract` class and a regular class.

**Question 3:** What is the purpose of generics in Dart?

* A) To allow methods to accept any type of argument.
* B) To create reusable classes and methods that can work with different types.
* C) To define constants that can be used throughout a program.
* D) To create anonymous functions.

## Next lesson

In the next lesson, you'll learn how to handle errors and exceptions in your
Dart code. You'll create a custom exception class and add error handling to your
`CommandRunner` to make your application more robust.