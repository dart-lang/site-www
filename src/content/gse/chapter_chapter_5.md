---
title: "Chapter 5: Object-Oriented Dart"
description: "Learn about `sealed` and `abstract` classes, generics, inheritance (`extends`), overrides, `FutureOr`, and `enum`."
---

# Chapter 5: Object-Oriented Dart
Learn about `sealed` and `abstract` classes, generics, inheritance (`extends`), overrides, `FutureOr`, and `enum`.

[Video Placeholder]

In this lesson, we'll be diving into the world of object-oriented programming (OOP) in Dart. We'll build a framework for creating well-architected command-line interface (CLI) apps. This involves creating classes for `CommandRunner`, `Command`, `Argument`, `ArgResults`, `Option`, and `HelpCommand`. We'll explore powerful Dart features like `sealed` and `abstract` classes, generics, inheritance, overrides, `FutureOr`, and `enum`. By the end of this lesson, you'll have a solid foundation for building robust and maintainable CLI applications in Dart.

## Background / Key Concepts

*   **Object-Oriented Programming (OOP):** A programming paradigm based on "objects," which contain data (fields) and code (methods) to manipulate that data. OOP promotes code reusability, modularity, and maintainability.
*   **Classes:** Blueprints for creating objects. They define the properties (fields) and behaviors (methods) that objects of that class will have.
*   **Objects:** Instances of a class. They are concrete entities that have their own state (values of their fields) and can perform actions (call their methods).
*   **`sealed` Classes:** Restrict which classes can extend or implement them. This provides more control over inheritance and helps prevent unexpected subtypes. Useful for modeling closed sets of types.
*   **`abstract` Classes:** Classes that cannot be instantiated directly. They often define a common interface for their subclasses, forcing them to implement certain methods.
*   **Generics:** Allow you to write code that can work with different types of data without having to write separate code for each type. This promotes code reuse and type safety.
*   **Inheritance (`extends`):** Enables you to create new classes based on existing classes, inheriting their properties and behaviors. This promotes code reuse and allows you to create a hierarchy of classes.
*   **Overrides:** Allows a subclass to provide a specific implementation of a method that is already defined in its superclass. This allows you to customize the behavior of inherited methods.
*   **`FutureOr`:** A type that can be either a `Future<T>` or a `T`. It's useful for functions that can return a value immediately or asynchronously.
*   **`enum`:** A special type that represents a fixed set of constant values. Enums can improve code readability and type safety.

## Set up

Make sure you have completed Chapter 4 and have a working Dart project set up with the `cli` and `command_runner` packages.

## Tasks

In this lesson, we'll define the core classes for our command-line framework within the `command_runner` package. This includes `Argument`, `Option`, `Command`, `ArgResults`, and `CommandRunner`. We'll also create a `HelpCommand` to display usage information.

### Define the `Argument` Classes

1.  Open `command_runner/lib/src/arguments.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:async';
    import 'dart:collection';

    import '../command_runner.dart';

    // [Step 5 updates] entire file
    enum OptionType { flag, option }

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

3.  **Explanation:**

    *   **`enum OptionType { flag, option }`:** Defines an enumeration called `OptionType` with two possible values: `flag` and `option`. Enums provide a way to represent a fixed set of values in a type-safe manner.  In this case, we use it to differentiate between flags and options.
    *   **`sealed class Argument { ... }`:** Defines a sealed class called `Argument`. Sealed classes are implicitly abstract, and their subclasses must be defined in the same file. This restricts the possible types of arguments and allows for more exhaustive checking at compile time.
        *   `String get name;`: An abstract getter for the argument's name.
        *   `String? get help;`: An abstract getter for the argument's help text.
        *   `Object? get defaultValue;`: An abstract getter for the argument's default value.
        *   `String? get valueHelp;`: An abstract getter for the argument's value help text.
        *   `String get usage;`: An abstract getter for the argument's usage information.
    *   **`class Option extends Argument { ... }`:** Defines a class called `Option` that inherits from the `Argument` sealed class. This class represents a command-line option.
        *   `Option(this.name, {required this.type, this.help, this.abbr, this.defaultValue, this.valueHelp});`:  The constructor for the `Option` class. It takes the option's name, type, help text, abbreviation, default value, and value help text as parameters.  Note the use of the `required` keyword.
        *   `@override final String name;`: Overrides the `name` getter from the `Argument` class.  The `@override` annotation ensures that the method is actually overriding a method from the superclass. The `final` keyword means that this value cannot be changed after the `Option` object is created.
        *   `final OptionType type;`:  A final field that stores the type of the option (either `flag` or `option`).
        *   `@override String get usage { ... }`: Overrides the `usage` getter from the `Argument` class. This method returns a string that describes how to use the option.
    *   **`abstract class Command<T> extends Argument { ... }`:** Defines an abstract class called `Command` that inherits from the `Argument` sealed class. This class represents a command that can be executed from the command line.
        *   `@override String get name;`: An abstract getter for the command's name.
        *   `String get description;`: An abstract getter for the command's description.
        *   `bool get requiresArgument => false;`: A getter that indicates whether the command requires an argument.
        *   `late CommandRunner<T> runner;`: A `late` field that will be initialized with the `CommandRunner` instance that the command is associated with.  The `late` keyword means that the variable will be assigned a value before it's used, but not necessarily at the point of declaration.
        *   `final List<Option> _options = [];`: A private list of `Option` objects that are associated with the command.
        *   `UnmodifiableSetView<Option> get options => UnmodifiableSetView(_options.toSet());`: A getter that returns an unmodifiable set view of the command's options.
        *   `void addFlag(String name, {String? help, String? abbr, String? valueHelp}) { ... }`: A method that adds a flag to the command. A flag is an option that doesn't take a value.
        *   `void addOption(String name, {String? help, String? abbr, String? defaultValue, String? valueHelp}) { ... }`: A method that adds an option to the command.
        *   `FutureOr<T> run(ArgResults args);`: An abstract method that executes the command. The `FutureOr<T>` return type indicates that the method can return either a `Future<T>` (if it needs to perform asynchronous operations) or a `T` (if it can return a value immediately).  `T` is a generic type, which will be specified later.
        *   `@override String get usage { ... }`: Overrides the `usage` getter from the `Argument` class. This method returns a string that describes how to use the command.
    *   **`class ArgResults { ... }`:** Defines a class called `ArgResults` that stores the results of parsing the command-line arguments.
        *   `Command? command;`: The command that was executed.
        *   `String? commandArg;`: The argument that was passed to the command.
        *   `Map<Option, Object?> options = {};`: A map that stores the values of the options that were passed to the command.
        *   `bool flag(String name) { ... }`: A method that returns `true` if the flag with the given name was passed to the command.
        *   `bool hasOption(String name) { ... }`: A method that returns `true` if the option with the given name was passed to the command.
        *   `({Option option, Object? input}) getOption(String name) { ... }`: A method that returns the option with the given name and its value.

### Update `command_runner_base.dart`

1.  Open `command_runner/lib/src/command_runner_base.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';

    // [Step 5 updates] Entire file

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

3.  **Explanation:**

    *   **`class CommandRunner<T> { ... }`:** Defines a class called `CommandRunner` that is responsible for running commands.
        *   `final Map<String, Command<T>> _commands = <String, Command<T>>{};`: A private map that stores the commands that are available to the command runner.  The key is the command name, and the value is the `Command` object. Note the use of generics here.  The `CommandRunner` class is generic, and the `_commands` map stores `Command` objects of type `T`.
        *   `UnmodifiableSetView<Command<T>> get commands => UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});`: A getter that returns an unmodifiable set view of the commands that are available to the command runner.
        *   `Future<void> run(List<String> input) async { ... }`: A method that runs a command.
            *   `final ArgResults results = parse(input);`: Parses the command-line arguments.
            *   `if (results.command != null) { ... }`: Checks if a command was found.
            *   `T? output = await results.command!.run(results);`: Executes the command and stores the result in the `output` variable.  Note the use of the `await` keyword, as the `run` method can return a `Future<T>`.
            *   `print(output.toString());`: Prints the output of the command to the console.
        *   `void addCommand(Command<T> command) { ... }`: A method that adds a command to the command runner.
            *   `_commands[command.name] = command;`: Adds the command to the `_commands` map, using the command's name as the key.
            *   `command.runner = this;`: Sets the command's `runner` property to the current `CommandRunner` instance.
        *   `ArgResults parse(List<String> input) { ... }`: A method that parses the command-line arguments.
            *   `var results = ArgResults();`: Creates a new `ArgResults` object.
            *   `results.command = _commands[input.first];`: Sets the `command` property of the `ArgResults` object to the command that was found in the `_commands` map.
        *   `String get usage { ... }`: A getter that returns the usage information for the command runner.
            *   `final exeFile = Platform.script.path.split('/').last;`: Gets the name of the executable file.
            *   `return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';`: Returns the usage information.

### Create `HelpCommand`

1.  Create `command_runner/lib/src/help_command.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:async';

    import 'arguments.dart';

    // [Step 5 updates] The entire file

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

3.  **Explanation:**

    *   **`class HelpCommand extends Command<String> { ... }`:** Defines a class called `HelpCommand` that inherits from the `Command` abstract class.  We are passing the generic type `String` in this case.
        *   `HelpCommand() { ... }`: The constructor for the `HelpCommand` class.
            *   `addFlag('verbose', abbr: 'v', help: 'When true, this command will print each command and its options.');`: Adds a flag called `verbose` to the command.
            *   `addOption('command', abbr: 'c', help: "When a command is passed as an argument, prints only that command's verbose usage.");`: Adds an option called `command` to the command.
        *   `@override String get name => 'help';`: Overrides the `name` getter from the `Command` class.
        *   `@override String get description => 'Prints usage information to the command line.';`: Overrides the `description` getter from the `Command` class.
        *   `@override FutureOr<String> run(ArgResults args) async { ... }`: Overrides the `run` method from the `Command` class.
            *   `var usage = runner.usage;`: Gets the usage information from the `CommandRunner`.
            *   `for (var command in runner.commands) { ... }`: Iterates over the commands that are available to the command runner.
            *   `usage += '\n ${command.usage}';`: Adds the usage information for each command to the `usage` variable.
            *   `return usage;`: Returns the usage information.

### Export `help_command.dart`

1.  Open `command_runner/lib/command_runner.dart` in your code editor.

2.  Add the following line to the file:

    ```dart
    export 'src/help_command.dart';
    ```

    This line exports the `help_command.dart` file, making the `HelpCommand` class available to anyone who imports the `command_runner` package.

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

    // [Step 5 updates] Added <String> generic. Added ..addCommand call
    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

3.  **Explanation:**

    *   `var commandRunner = CommandRunner<String>()..addCommand(HelpCommand());`: Creates an instance of the `CommandRunner` class with a generic type of `String`, and then adds the `HelpCommand` to it using cascade notation (`..`).

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following command and observe the output:

    ```bash
    dart run bin/cli.dart help
    ```

    Output:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

[Pop out placeholder: Experiment with different command-line arguments and observe the output.  Try adding additional commands to the `CommandRunner` and observe how the `help` command output changes.]

## Review

In this lesson, you learned how to:

*   Use `sealed` and `abstract` classes to define a hierarchy of classes.
*   Use generics to write code that can work with different types of data.
*   Use inheritance (`extends`) to create new classes based on existing classes.
*   Use overrides to customize the behavior of inherited methods.
*   Use `FutureOr` to define methods that can return a value immediately or asynchronously.
*   Use `enum` to represent a fixed set of constant values.
*   Create a `CommandRunner` class that is responsible for running commands.
*   Create a `Command` abstract class that defines the interface for commands.
*   Create a `HelpCommand` class that prints usage information.

**Quiz Question:**

What is the purpose of the `sealed` keyword in Dart?

*   [Option A] To define a constant variable.
*   [Option B] To restrict which classes can extend or implement a class.
*   [Option C] To create a new object.
*   [Option D] To import a package.

## Next lesson

In the next lesson, we'll explore error handling in Dart and learn how to make our command-line application more robust. We'll introduce custom exceptions, `try/catch` blocks, and techniques for throwing and rethrowing exceptions.