---
title: Define relationships with classes
shortTitle: Object-oriented Dart
description: >-
  Learn about object-oriented programming in Dart, including
  abstract classes, inheritance, overrides, and enums.
  Build a framework for well-architected CLI apps.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /learn/tutorial/packages-libs
  title: Organize code with packages and libraries
nextpage:
  url: /learn/tutorial/error-handling
  title: Handle errors gracefully
---

In this chapter, you'll explore the
power of object-oriented programming (OOP) in Dart.
You'll learn how to create classes and define relationships between them,
including **inheritance** and **abstract classes**.
You'll also build a foundation for creating well-structured CLI applications.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Design and understand abstract classes
    icon: schema
  - title: Extend parent classes and override methods
    icon: account_tree
  - title: Use enums to represent fixed sets of values
    icon: format_list_bulleted
  - title: Continue building out your CLI framework
    icon: terminal
</SummaryCard>

## Prerequisites

Before you begin this chapter, ensure you:

- Have completed Chapter 4 and have a
  working Dart development environment with the `dartpedia` project.
- Are familiar with basic programming concepts like
  variables, functions, and control flow.
- Understand the concepts of packages and libraries in Dart.

## Tasks

A command-line interface (CLI) is defined by the
commands, options, and arguments a user can type into their terminal.

By the end of this lesson, you will have
built a framework that can understand a command like this:

```bash
$ dartpedia help --verbose --command=search
```

Here is a breakdown of each part:

- `dartpedia`:
  This is the **executable**, the name of your application.
- `help`:
  This is a **command**, an action you want the application to perform.
- `--verbose`:
  This is a **flag** (a type of option that doesn't take a value),
  which modifies the command's behavior.
- `--command=search`:
  This is an **option** that takes a value.
  Here, the `option` is named `command`, and its value is `search`.

The classes and logic you build in the following tasks
create the foundation for parsing and executing commands just like this one.

### Task 1: Define the argument hierarchy

First, you'll define an `Argument` class,
an `Option` class, and a `Command` class,
establishing an inheritance relationship.

1.  Create the file `command_runner/lib/src/arguments.dart`.
    This file will
    contain the definitions for your `Argument`, `Option`, `Command`, and
    `ArgResults` classes.

1.  Define an `enum` called `OptionType`.

    ```dart title="command_runner/lib/src/arguments.dart"
    enum OptionType { flag, option }
    ```

    This `enum` represents the type of option, which can be either a **`flag`**
    (a boolean option) or a regular **`option`** (an option that takes a value).
    Enums are useful for representing a fixed set of possible values.

1.  Define an `abstract class` called `Argument`.

    Start by defining the basic structure of your `Argument` class.
    You'll declare it as `abstract`, which means it serves as a blueprint that
    other classes can extend, but it can't be instantiated on its own.

    Below the `enum` you just added, paste in the following code:

    ```dart title="command_runner/lib/src/arguments.dart"
    // Paste this new class below the enum you added
    abstract class Argument {
      String get name;
      String? get help;

      // In the case of flags, the default value is a bool.
      // In other options and commands, the default value is a String.
      // NB: flags are just Option objects that don't take arguments
      Object? get defaultValue;
      String? get valueHelp;

      String get usage;
    }
    ```

    - **`name`** is a `String` that uniquely identifies the argument.
    - **`help`** is an optional `String` that provides a description.
    - **`defaultValue`** is of type `Object?` because it
      can be a `bool` (for flags) or a `String`.
    - **`valueHelp`** is an optional `String` to
      give a hint about the expected value.
    - The **`usage`** getter will provide a string showing how
      to use the argument.

    With the `Argument` class fully defined,
    you have a common interface for all types of command-line arguments.
    Next, you'll build upon this by defining `Option`,
    a specific type of argument that extends `Argument`.

1.  Define a class called `Option` that `extends` `Argument`.

    The `Option` class will represent command-line options like
    `--verbose` or `--output=file.txt`.
    It will inherit from your `Argument` class.

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

    The **`extends`** keyword establishes the inheritance relationship.
    The constructor uses `@override` to provide concrete implementations for
    the properties defined in `Argument`.
    It also adds `type` (using the `OptionType` enum) and an
    optional `abbr` for a short-form of the option.
    The `usage` getter is implemented to provide clear instructions to the user.

    With `Option` complete, you have a specialized type of argument. Next,
    you'll define the `Command` class, another type of argument that will
    represent the main actions a user can perform in your CLI application.

1.  Define an `abstract class` called `Command` that also `extends` `Argument`.

    The `Command` class will represent an executable action.
    Since it provides a template for other commands to follow,
    you'll declare it as **`abstract`**.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class below the Option class
    abstract class Command extends Argument {
      // Properties and methods will go here
    }
    ```

    The **`abstract`** keyword means that
    `Command` can't be instantiated directly.
    It serves as a blueprint for other classes.

    Now, add the core properties.
    A command needs a `name` and `description`.
    It also needs a reference back to the `CommandRunner` that executes it.

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends Argument {
      @override
      String get name;

      String get description;

      bool get requiresArgument => false;

      late CommandRunner runner;

      @override
      String? help;

      @override
      String? defaultValue;

      @override
      String? valueHelp;
    }
    ```

    The `runner` property is of type `CommandRunner`,
    which you will define later in `command_runner_base.dart`.
    To make Dart aware of this class, you must import its defining file.
    Add the following import to the
    top of `command_runner/lib/src/arguments.dart`:

    ```dart
    import '../command_runner.dart';
    ```

    Next, to give commands their own set of options, you'll use a
    private list and expose a read-only, **unmodifiable view** of it.
    This uses the `UnmodifiableSetView` class, which is
    part of Dart's core collection library.
    To use it, you must import that library.

    Update the imports at the top of your file to include `dart:collection`:

    ```dart
    import 'dart:collection'; // New import
    import '../command_runner.dart';
    ```

    Now, add the `options` list and getter to your `Command` class:

    ```dart
    abstract class Command extends Argument {
      // ... existing properties ...

      @override
      String? valueHelp;


      // Add the following lines to the bottom of your Command class:

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());
    }
    ```

    To make adding options easier, we'll provide
    two helper methods, `addFlag` and `addOption`.

    ```dart
    abstract class Command extends Argument {
      // ... existing properties and getters ...

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());


      // Add the following lines to the bottom of your Command class:

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

    Finally, every command must have logic to execute.
    The `run` method should be flexible, allowing it to return a value either
    immediately (synchronously) or after a delay (asynchronously).
    The `FutureOr<Object?>` type from `dart:async` serves this purpose.
    This means the method must return a value (of any type or `null`) either
    synchronously or asynchronously. This is your final required import.

    Update the imports at the top of your file to include `dart:async`:

    ```dart
    import 'dart:async'; // New import
    import 'dart:collection';
    import '../command_runner.dart';
    ```

    Now you can add the abstract `run` method and
    provide the `usage` implementation to complete the `Command` class.

    ```dart
    abstract class Command extends Argument {
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


      // Add the following lines to the bottom of your Command class:
      FutureOr<Object?> run(ArgResults args);

      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    - **`run(ArgResults args)`**:
      This abstract method is where a command's logic resides.
      Concrete subclasses *must* implement it.
    - **`usage`**:
      This getter provides a simple usage string,
      combining the command's `name` and `description`.

    The `Command` class now provides a
    robust foundation for all commands in your CLI app.
    With the class hierarchy in place, you're ready to
    define `ArgResults` to hold the parsed input.

1.  Define a class called `ArgResults`.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class to the end of the file
    class ArgResults {
      Command? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // Returns true if the flag exists.
      bool flag(String name) {
        // Only check flags, because we're sure that flags are booleans.
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

    This class represents the results of parsing command-line arguments.
    It holds the detected command, any argument to that command, and
    a map of the specified options.
    It also provides convenient helper methods like
    `flag`, `hasOption`, and `getOption`.

    Now you have defined the basic structure for handling
    commands, arguments, and options in your command-line application.

### Task 2: Update the CommandRunner class

Next, update the `CommandRunner` class to use the new `Argument` hierarchy.

1.  Open the `command_runner/lib/src/command_runner_base.dart` file.

1.  Replace the existing `CommandRunner` class with the following:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    import 'dart:collection';
    import 'dart:io';
    import 'arguments.dart';

    class CommandRunner {
      final Map<String, Command> _commands = <String, Command>{};

      UnmodifiableSetView<Command> get commands =>
          UnmodifiableSetView<Command>(<Command>{..._commands.values});

      Future<void> run(List<String> input) async {
        final ArgResults results = parse(input);
        if (results.command != null) {
          Object? output = await results.command!.run(results);
          print(output.toString());
        }
      }

      void addCommand(Command command) {
        // TODO: handle error (Commands can't have names that conflict)
        _commands[command.name] = command;
        command.runner = this;
      }

      ArgResults parse(List<String> input) {
        var results = ArgResults();
        results.command = _commands[input.first];
        return results;
      }

      // Returns usage for the executable only.
      // Should be overridden if you aren't using [HelpCommand]
      // or another means of printing usage.

      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }
    }
    ```

    This updated `CommandRunner` class now
    uses the `Command` class from the `Argument` hierarchy.
    It includes methods for adding commands, parsing arguments, and
    running the appropriate command based on user input.

1.  Open `command_runner/lib/command_runner.dart`, and
    add the following exports:

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
    `help_command.dart` files available to other packages that
    depend on `command_runner`.

### Task 3: Create a HelpCommand

Create a `HelpCommand` that extends the `Command` class and
prints usage information.

1.  Create the file `command_runner/lib/src/help_command.dart`.

1.  Add the following code to `command_runner/lib/src/help_command.dart`:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';

    import 'arguments.dart';

    // Prints program and argument usage.
    //
    // When given a command as an argument, it prints the usage of
    // that command only, including its options and other details.
    // When the flag 'verbose' is set, it prints options and details for all commands.
    //
    // This command isn't automatically added to CommandRunner instances.
    // Packages users should add it themselves with [CommandRunner.addCommand],
    // or create their own command that prints usage.

    class HelpCommand extends Command {
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
      FutureOr<Object?> run(ArgResults args) async {
        var usage = runner.usage;
        for (var command in runner.commands) {
          usage += '\n ${command.usage}';
        }

        return usage;
      }
    }
    ```

    This `HelpCommand` class extends `Command` and
    implements the `run` method to print usage information.
    It also uses the `addFlag` and `addOption` methods to
    define its own options for controlling the output.

### Task 4: Update cli.dart to use the new CommandRunner

Modify `cli/bin/cli.dart` to use the new `CommandRunner` and `HelpCommand`.

1.  Open the `cli/bin/cli.dart` file.

1.  Replace the existing code with the following:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    This code creates a `CommandRunner` instance,
    adds the `HelpCommand` to it using method cascading (`..addCommand`), and
    then runs the command runner with the command-line arguments.

### Task 5: Run the application

Test the new `CommandRunner` and `HelpCommand`.

1.  Open your terminal and navigate to the `cli` directory.

1.  Run the command `dart run bin/cli.dart help`.

    You should see the usage information printed to the console:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    This confirms that the `CommandRunner` and `HelpCommand` are
    working correctly.

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Designed and understood abstract classes
    icon: schema
    details: >-
      You created an abstract `Argument` class as a blueprint that
      can't be instantiated directly.
      Abstract classes define a contract that subclasses must fulfill,
      ensuring consistency across your class hierarchy.
  - title: Extended parent classes and overrode methods
    icon: account_tree
    details: >-
      You used `extends` to create `Option` and `Command` subclasses of
      the abstract `Argument` class.
      Within those subclasses, you used `@override` to
      provide concrete implementations of abstract members.
  - title: Used enums to represent fixed sets of values
    icon: format_list_bulleted
    details: >-
      You defined an `OptionType` enum to represent a fixed set of values.
      In Dart, enums are type-safe and help prevent invalid values from
      being used where only specific options are valid.
  - title: Continued building out your CLI framework
    icon: terminal
    details: >-
      You applied object-oriented programming principles to implement a
      robust and extensible framework for parsing command-line arguments.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="object-oriented" />

## Next lesson

In the next lesson, you'll learn how to
handle errors and exceptions in your Dart code.
You'll create a custom exception class and
add error handling to your `CommandRunner` to
make your application more robust.
