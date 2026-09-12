---
title: Structure apps with inheritance and abstract classes
shortTitle: Inheritance and abstraction
description: >-
  Learn about inheritance, abstract classes, method overrides, and
  encapsulation in Dart. Build an extensible framework for CLI apps.
layout: learn
---

This chapter builds on the classes created in the previous lesson by
exploring inheritance and abstract classes in Dart.
Learn how to share behavior between classes using
[inheritance][], define contracts using
[abstract classes][], and
protect internal state with [encapsulation][].

<SummaryCard>
title: What you'll accomplish
items:
  - title: Design and understand abstract classes
    icon: schema
  - title: Extend parent classes and override methods
    icon: account_tree
  - title: Protect internal state with encapsulation
    icon: lock
  - title: Build an extensible command runner framework
    icon: terminal
</SummaryCard>

## Prerequisites

Before starting this chapter:

- Complete Chapter 5 and have a
  working Dart development environment with the `dartpedia` project.
- Understand basic object-oriented concepts in Dart,
  such as defining classes, constructors, fields, and getters.
- Understand packages and libraries in Dart.

## Abstract classes and inheritance

In Dart, an **abstract class** is a class that cannot be instantiated
directly (calling `CliElement()` causes a compile-time error).
Instead, it serves as a blueprint or contract that other classes extend.

In a CLI, options (`--verbose`) and commands (`help`) share common
features like a name and help description,
but a generic "CLI element" does not make sense on its own.
Declaring `CliElement` and `Command` as **abstract** ensures that code
only instantiates specific classes like `Option` and `HelpCommand`.

```
       ┌──────────────┐
       │  CliElement  │ (abstract: blueprint for all CLI elements)
       └──────┬───────┘
              │
      ┌───────┴───────┐
      ▼               ▼
┌───────────┐   ┌───────────┐
│  Option   │   │  Command  │ (abstract: blueprint for commands)
└───────────┘   └─────┬─────┘
                      │
                      ▼
               ┌─────────────┐
               │ HelpCommand │ (can be instantiated and run)
               └─────────────┘
```

### Share behavior with inheritance

**Inheritance** allows a class to adopt properties and behavior from a parent class.
Because both options (`Option`) and commands (`Command`) share a `name`,
`help` text, and a formatted `usage` message,
inheriting from a common `CliElement` parent eliminates duplicate code
across multiple classes.

Inheritance also enables **polymorphism**—the ability for the command runner
to treat any command or option uniformly through the shared `CliElement` interface.

## Tasks

In Chapter 5, the `Option` and `ArgResults` classes established
basic data structures for CLI options and parsed output.
This chapter establishes a shared hierarchy between commands and options,
and expands the placeholder `CommandRunner` from Chapter 4 into
a full-featured command parser.

The classes and logic in the following tasks
create the foundation for parsing and executing CLI commands.

### Task 1: Define the CliElement abstract class and update Option

Both options and commands share core attributes such as a `name`,
`help` text, and a formatted `usage` string.
Defining an abstract base class establishes a single contract for both.

1.  Open `command_runner/lib/src/arguments.dart`.

1.  Define an `abstract class` called `CliElement` below the `OptionType` enum:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class CliElement {
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

    The `abstract` keyword marks `CliElement` as a base class that cannot
    be instantiated directly (`CliElement()`).
    Getters without bodies (`String get name;`) define required properties
    that every subclass must implement.
    The `defaultValue` getter uses type `Object?` so it can return either a
    `bool` (for flags) or a `String` (for options that accept values).

1.  Update the `Option` class to extend `CliElement`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option extends CliElement {
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

    The `extends` keyword establishes an inheritance relationship where `Option`
    becomes a subtype of `CliElement`.
    In Dart, every field has an implicit getter.
    Declaring `@override final String name;` satisfies the abstract getter
    `String get name;` declared in `CliElement`.
    The `abbr` and `type` fields remain specific to `Option`.

### Task 2: Define the Command abstract class

Commands represent actions that users can perform, such as `help` or `search`.
Because commands share properties with `Option` (like `name` and `usage`),
they also extend `CliElement`.

1.  Add required imports to the top of `command_runner/lib/src/arguments.dart`:

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';
    import 'command_runner_base.dart';
    ```

1.  Start by defining the core `Command` abstract class with its properties and runner reference:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
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

    - **`abstract class Command extends CliElement`**:
      Establishes `Command` as an abstract subtype of `CliElement`,
      providing a template for all specific commands to follow.
    - **`late CommandRunner runner;`**:
      A command needs a reference to the `CommandRunner` executing it,
      so it can access global runner state.
      The `late` keyword promises Dart that this non-nullable variable will be
      assigned before use (when added to the runner via `command.runner = this;`).

1.  Next, add encapsulated option storage and helper methods to `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
      // ... existing properties ...

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());

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

    - **Encapsulation with `_options`**:
      Prefixing `_options` with an underscore (`_`) makes it library-private,
      preventing code outside `arguments.dart` from modifying the list directly.
    - **`UnmodifiableSetView`**:
      Exposes a read-only view of the command's options,
      ensuring callers cannot mutate internal state directly.
    - **`addFlag` and `addOption`**:
      Provide controlled methods to create and register valid `Option` instances
      into the command.

1.  Finally, add the abstract `run` method and `usage` getter to complete `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
      // ... existing properties and helper methods ...

      FutureOr<Object?> run(ArgResults args);

      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    - **`FutureOr<Object?> run(...)`**:
      Defines the abstract method where a command's execution logic lives.
      `FutureOr` allows the method to return either a raw synchronous value
      or a `Future` for asynchronous operations (connecting back to Chapter 3).
    - **`usage` getter**:
      Formats the command's name and description for CLI help output.

1.  Update the `ArgResults` class at the bottom of
    `command_runner/lib/src/arguments.dart` to reference `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class ArgResults {
      Command? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // ... existing flag, hasOption, and getOption methods ...
    }
    ```

    In Chapter 5, `ArgResults.command` was a `String?` before `Command` existed.
    Now that `Command` exists, changing its type to `Command?` allows the
    command runner to store and execute the resolved `Command` object directly.

### Task 3: Update the CommandRunner class

In Chapter 4, you created a placeholder `CommandRunner` in
`command_runner/lib/src/command_runner_base.dart` that simply printed arguments.
Now, replace that placeholder with the real command coordinator.

1.  Open `command_runner/lib/src/command_runner_base.dart`.

1.  Replace the file contents with the following code:

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
        _commands[command.name] = command;
        command.runner = this;
      }

      ArgResults parse(List<String> input) {
        var results = ArgResults();
        results.command = _commands[input.first];
        return results;
      }

      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }
    }
    ```

    Highlights from the preceding code:

    - **Spread operator (`..._commands.values`)**:
      Unpacks the values of the private `_commands` map into a new set,
      preventing callers from modifying the underlying map.
    - **`command.runner = this;`**:
      Assigns the runner instance to the command when registered,
      fulfilling the promise made by the `late` keyword in `Command`.
    - **Null assertion operator (`!`)**:
      In `results.command!.run(results)`, the `!` asserts that `command`
      is guaranteed non-null because of the `if (results.command != null)` check.

1.  Open `command_runner/lib/command_runner.dart` and update the exports:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for command-line parsing and execution.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';
    ```

    These export statements make `arguments.dart`, `command_runner_base.dart`,
    and `help_command.dart` part of the public API of the `command_runner` package.

### Task 4: Create a HelpCommand

Create a `HelpCommand` that extends `Command` and prints usage information.

1.  Create `command_runner/lib/src/help_command.dart`.

1.  Add the following code:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';
    import 'arguments.dart';

    class HelpCommand extends Command {
      HelpCommand() {
        addFlag(
          'verbose',
          abbr: 'v',
          help: 'When true, prints each command and its options.',
        );
        addOption(
          'command',
          abbr: 'c',
          help: 'Prints verbose usage for the specified command.',
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

    The `HelpCommand` constructor calls inherited helper methods `addFlag` and
    `addOption` to configure its supported options.
    Its `run` method reads `runner.usage` and iterates over `runner.commands`
    to assemble and return the complete CLI usage message dynamically.

### Task 5: Update cli.dart to use CommandRunner

Connect `CommandRunner` and `HelpCommand` in the executable entry point.

1.  Open `cli/bin/cli.dart`.

1.  Replace the file contents with the following code:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    The cascade notation `..addCommand(...)` calls `addCommand` on the
    newly constructed `CommandRunner` and returns that runner instance,
    enabling concise method chaining before passing `arguments` to `run()`.

### Task 6: Run the application

Test the `CommandRunner` and `HelpCommand`.

1.  From the `cli` directory, run:

    ```bash
    dart run bin/cli.dart help
    ```

    The console outputs:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    This confirms that `CommandRunner` dispatches to `HelpCommand`
    and prints the expected usage output.

    :::note
    Always supply a command argument (such as `help`) when running this step.
    Chapter 7 introduces error handling to manage empty or
    invalid input gracefully.
    :::

## Review

<SummaryCard>
title: What you accomplished
subtitle: A summary of the concepts and code introduced in this lesson.
completed: true
items:
  - title: Designed and understood abstract classes
    icon: schema
    details: >-
      Created the abstract `CliElement` and `Command` classes as base contracts
      that cannot be instantiated directly.
  - title: Extended parent classes and overrode methods
    icon: account_tree
    details: >-
      Used `extends` to create `Option`, `Command`, and `HelpCommand` subtypes,
      using `@override` to provide required implementations.
  - title: Protected internal state with encapsulation
    icon: lock
    details: >-
      Stored options in private lists (`_options`, `_commands`) and exposed
      them via `UnmodifiableSetView` to prevent unintended mutations.
  - title: Built an extensible command runner framework
    icon: terminal
    details: >-
      Applied object-oriented principles to implement a polymorphic
      CLI framework capable of dispatching commands dynamically.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="inheritance" />

## Next lesson

The next chapter covers handling errors and exceptions in Dart.
Create a custom exception class, and
add error handling to `CommandRunner` to make the application more robust.

[inheritance]: /language/extend
[abstract classes]: /language/class-modifiers#abstract
[encapsulation]: /resources/glossary#encapsulation
