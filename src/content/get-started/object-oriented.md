---
title: Object-oriented Dart programming
short-title: Object oriented Dart
description: >-
  Learn about object-oriented programming in Dart, including `sealed` and
  `abstract` classes, generics, inheritance, overrides, and enums. Build a
  framework for well-architected CLI apps.
prevpage:
  url: /get-started/packages-libs
  title: Packages and libraries
nextpage:
  url: /get-started
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

    ```dart title="command_runner/lib/src/arguments.dart"
    sealed class Argument {
      // Properties and methods will go here
    }
    ```

    The **`sealed`** keyword restricts which classes can extend or implement
    `Argument`. This means all possible direct subclasses of `Argument` must be
    defined within the same library. This restriction allows the Dart compiler
    to know all possible subtypes at compile time, which can improve code safety
    and enable exhaustive `switch` statements later on.

    Every command-line argument needs a name and can optionally have a help
    description. Let's add these as properties.

    ```dart title="command_runner/lib/src/arguments.dart"
    sealed class Argument {
      String get name;
      String? get help;
    }
    ```

    We've added **`name`**, which is a `String` that uniquely identifies the
    argument, and **`help`**, an optional `String` that provides a description
    of the argument's purpose. Both are defined as getters, meaning their values
    will be provided by concrete subclasses.

    Arguments can also have a default value if not explicitly provided, and a
    description for what kind of value they expect.

    ```dart title="command_runner/lib/src/arguments.dart"
    sealed class Argument {
      String get name;
      String? get help;

      // In the case of flags, the default value is a bool
      // In other options and commands, the default value is String
      Object? get defaultValue;
      String? get valueHelp;
    }
    ```

    **`defaultValue`** is of type `Object?` because a default can be a `bool`
    (for flags) or a `String` (for other options and commands). **`valueHelp`**
    is an optional `String` to give a hint about the expected format or type of
    the argument's value.

    Finally, each argument should be able to provide a string describing its
    usage in the command line.

    ```dart title="command_runner/lib/src/arguments.dart"
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

    The **`usage`** getter provides a concise string representation of how the
    argument should be used in the command line. This will be implemented
    differently by `Option` and `Command` to reflect their specific syntax.

    With the `Argument` class now fully defined, we have a common interface for
    all types of command-line arguments. Next, we'll build upon this by defining 
    `Option`, a specific type of argument that extends `Argument`.

4.  Define a class called `Option` that `extends` `Argument`.

    The `Option` class will represent command-line options like `--verbose` or `--output=file.txt`. It will inherit from our `Argument` class.

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option extends Argument {
      // Constructor and properties will go here
    }
    ```

    The **`extends`** keyword establishes an inheritance relationship, meaning
    `Option` will inherit all the public and protected members of `Argument`.
    This allows `Option` to reuse the properties defined in `Argument` and also
    fulfill the contract of being an `Argument`.

    Let's add the constructor for `Option` and declare its specific properties,
    including overriding those from `Argument`.

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
    }
    ```

    The **`Option` constructor** takes `name` as a required positional argument
    and several optional named arguments. The `@override` annotation explicitly
    indicates that `name`, `help`, `defaultValue`, and `valueHelp` are
    overriding getters from the `Argument` class. **`type`** (using our
    `OptionType` enum) distinguishes between flag options and value-taking
    options, and **`abbr`** allows for short-form options (e.g., `-v`). We use
    `final` for these properties because they are set once during object
    creation.

    Now, let's provide a concrete implementation for the `usage` getter, which
    was declared in `Argument`.

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

    The **`usage` getter** now constructs a string that shows how to use the
    option. If an `abbr` (abbreviation) is provided, it includes both the short
    and long forms (e.g., `-v,--verbose`). Otherwise, it just shows the long
    form (e.g., `--output`). This provides clear instructions for the user.

    With `Option` complete, we have a specialized type of argument. Next, we'll
    define the `Command` class, another type of argument that will represent the
    main actions a user can perform in our CLI application.

5.  Define an `abstract class` called `Command` that also `extends` `Argument`.

    The `Command` class will represent an executable command within our CLI
    application. Since `Command` objects will have specific execution logic that
    varies per command, we'll declare it as `abstract`.

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart'; // This import will be used later

    abstract class Command<T> extends Argument {
      // Properties and methods will go here
    }
    ```

    The **`abstract`** keyword means that `Command` cannot be instantiated
    directly. It serves as a blueprint for other classes. Concrete subclasses of 
    `Command` *must* implement any abstract methods declared in `Command`. The
    `<T>` after `Command` indicates that it's a generic class, allowing us to
    specify the return type of the command's execution.

    Let's add the core properties for a command, including those inherited from `Argument` and some new ones specific to commands.

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart';

    abstract class Command<T> extends Argument {
      @override
      String get name;

      String get description;

      bool get requiresArgument => false;

      late CommandRunner<T> runner;

      @override
      String? help; // Note: help is redefined here to allow direct assignment

      @override
      String? defaultValue;

      @override
      String? valueHelp;
    }
    ```

    Here are the properties we've added for a command:
    * **`name`**: The unique identifier for the command (e.g., 'help',
    'create').
    * **`description`**: A brief summary of what the command does.
    * **`requiresArgument`**: A boolean indicating if the command *must* be
    followed by an additional argument (defaults to `false`).
    * **`runner`**: A `late` initialized reference back to the `CommandRunner`
    instance that owns this command. This will be set externally when the
    command is added to the runner.
    * **`help`**, **`defaultValue`**, **`valueHelp`**: These are overridden from
    `Argument`, but here they are explicitly declared as `String?` for `help`,
    `defaultValue`, and `valueHelp`. Note that `help` is declared as a settable
    property (`String? help;`) instead of a getter, allowing subclasses to
    directly assign its value.

    Commands can have their own set of options. We'll use a private list and
    expose an unmodifiable view of it.

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart';

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

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());
    }
    ```

    `_options` is a private `List<Option>` to store the options associated with
    this specific command. The **`options` getter** provides an
    `UnmodifiableSetView` of these options. This prevents external code from
    directly modifying the command's options list, ensuring data integrity,
    while still allowing access to the options.

    To make it easy to add options to a command, we'll provide helper methods.

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart';

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

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());

      /// A flag is an [Option] that's treated as a boolean.
      /// All flags have a default value of false, and are
      /// considered true if the flag is passed into the
      /// command at all.
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

    * **`addFlag`**: This convenience method simplifies adding boolean options
    (flags) to the command. It automatically sets `defaultValue` to `false` and
    `type` to `OptionType.flag`.
    * **`addOption`**: This method is used to add options that take a value. It
    allows specifying a `defaultValue` and ensures `type` is
    `OptionType.option`. Both methods add a new `Option` instance to the
    `_options` list.

    Every command must have a way to execute its logic. We'll define an abstract
    `run` method and provide an initial `usage` getter.

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart';

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

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());

      /// A flag is an [Option] that's treated as a boolean.
      /// All flags have a default value of false, and are
      /// considered true if the flag is passed into the
      /// command at all.
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

      FutureOr<T> run(ArgResults args);

      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    * **`run(ArgResults args)`**: This is an abstract method that concrete
    `Command` subclasses *must* implement. It's where the command's core logic
    resides. The `FutureOr<T>` return type indicates that the method can return
    a `T` (the result of the command) either synchronously or asynchronously
    (via a `Future`). `ArgResults` will contain the parsed command-line
    arguments specific to this command.
    * **`usage`**: This overridden getter provides a basic usage string for the
    command, combining its `name` and `description`. Subclasses can further
    customize this.

    The `Command` abstract class provides a robust foundation for defining
    various executable commands in our CLI application. With `Argument`,
    `Option`, and `Command` in place, we're ready to define the `ArgResults`
    class to hold the parsed input, completing the basic argument parsing
    structure.

1.  Define a class called `ArgResults`.

    ```dart title="command_runner/lib/src/arguments.dart"
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

    This class represents the results of parsing command-line arguments. It
    contains properties like `command`, `commandArg`, and `options`. It also
    defines methods like `flag`, `hasOption`, and `getOption` to access the
    parsed arguments.

    Now you have defined the basic structure for handling commands, arguments,
    and options in your command-line application.

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

    This updated `CommandRunner` class now uses the `Command` class from the
    `Argument` hierarchy. It includes methods for adding commands, parsing
    arguments, and running the appropriate command based on user input. The
    `<T>` syntax introduces **generics**, allowing the `CommandRunner` to work
    with different types of results.

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

    This `HelpCommand` class extends the `Command` class and implements the
    `run` method to print usage information. It also uses the `addFlag` and
    `addOption` methods to define command-line options for controlling the
    output.

### Task 4: Update cli.dart to use the new CommandRunner

Modify `cli/bin/cli.dart` to use the new `CommandRunner` and `HelpCommand`.

1.  Open the `cli/bin/cli.dart` file.

2.  Replace the existing code with the following:

    ```dart title="cli/bin/cli.dart"
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    // [Step 5 updates] Added <String> generic. Added ..addCommand call
    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    This code creates a `CommandRunner` instance, adds the `HelpCommand` to it,
    and then runs the command runner with the command-line arguments.

### Task 5: Run the application

Test the new `CommandRunner` and `HelpCommand`.

1.  Open your terminal and navigate to the `cli` directory.

2.  Run the command `dart run bin/cli.dart help`.

    You should see the usage information printed to the console:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    This confirms that the `CommandRunner` and `HelpCommand` are working
    correctly.

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