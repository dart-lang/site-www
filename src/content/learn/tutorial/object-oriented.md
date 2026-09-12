---
title: Define classes and objects
shortTitle: Classes and objects
description: >-
  Learn about object-oriented programming in Dart, including
  classes, constructors, getters, and enums.
  Build data models for command-line arguments.
layout: learn
---

This chapter covers the fundamentals of
object-oriented programming (OOP) in Dart.
Explore how to create [classes][],
define constructors and fields,
compute properties with [getters][], and
use [enums][] to represent fixed sets of values.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Define classes to model data and behavior
    icon: view_in_ar
  - title: Create constructors with initializing formals and named parameters
    icon: build
  - title: Use getters to compute properties dynamically
    icon: functions
  - title: Use enums to represent fixed sets of values
    icon: format_list_bulleted
</SummaryCard>

## Prerequisites

Before starting this chapter:

- Complete Chapter 4 and have a
  working Dart development environment with the `dartpedia` project.
- Understand basic programming concepts,
  such as variables, functions, and control flow.
- Understand packages and libraries in Dart.

## Tasks

A command-line interface (CLI) is defined by the
commands, options, and arguments typed into a terminal.

This lesson and the next build a framework
capable of parsing a command such as:

```bash
$ dartpedia help --verbose --command=search
```

Each part serves a distinct purpose:

- `dartpedia`:
  The **executable**, or the name of the application.
- `help`:
  A **command**, representing an action to perform.
- `--verbose`:
  A **flag** (a boolean option without a value),
  modifying the command's behavior.
- `--command=search`:
  An **option** that accepts a value (`search`).

This chapter builds the data models representing options and parsed results.

### Task 1: Define the OptionType enum

Command-line options fall into two distinct categories:
flags (which evaluate to boolean `true` or `false`) and
regular options (which accept a string value).
Using an enum ensures that code only allows these two valid categories.

1.  Create `command_runner/lib/src/arguments.dart`.

1.  Define the `OptionType` enum:

    ```dart title="command_runner/lib/src/arguments.dart"
    enum OptionType { flag, option }
    ```

    This enumeration defines two members: `flag` and `option`.
    Enums provide compile-time type safety,
    ensuring code accepts only valid option types.

### Task 2: Define the Option class

Classes in Dart define blueprints for objects,
combining state (fields) and behavior (methods and getters).
The `Option` class models command-line options such as
`--verbose` or `--command=search`.

1.  Add the `Option` class to `command_runner/lib/src/arguments.dart`
    below the enum:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option {
      Option(
        this.name, {
        required this.type,
        this.help,
        this.abbr,
        this.defaultValue,
        this.valueHelp,
      });

      final String name;
      final OptionType type;
      final String? help;
      final String? abbr;
      final Object? defaultValue;
      final String? valueHelp;

      String get usage {
        if (abbr != null) {
          return '-$abbr,--$name: $help';
        }

        return '--$name: $help';
      }
    }
    ```

    Highlights from the preceding code:

    - **Generative constructor (`Option(...)`)**:
      Instantiates new `Option` objects.
    - **Initializing formals (`this.name`, `this.type`)**:
      Directly assigns incoming arguments to instance fields
      before the constructor body executes, avoiding repetitive assignment code.
    - **Named parameters (`{required this.type, ...}`)**:
      Curly braces `{}` enclose named parameters.
      Callers pass arguments by name in any order
      (for example, `Option('verbose', type: OptionType.flag)`).
    - **`required` keyword**:
      Enforces that callers must supply the `type` parameter,
      while other parameters remain optional.
    - **Nullable types (`String?`, `Object?`)**:
      The question mark `?` indicates that a field can hold a value or `null`.
      Optional attributes like `abbr` default to `null` when omitted.
    - **`final` fields**:
      Guarantees that field values cannot change after initialization,
      ensuring that option definitions remain immutable.
    - **`usage` getter**:
      Computes the help string on demand.
      If an abbreviation exists, it formats the output as `-$abbr,--$name: $help`.
      Otherwise, it formats it as `--$name: $help`.

### Task 3: Define the ArgResults class

The `ArgResults` class stores the output of parsing command-line input.
It maps each `Option` to its user-supplied value.

1.  Add `ArgResults` to the bottom of `command_runner/lib/src/arguments.dart`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class ArgResults {
      String? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // Returns true if the flag exists and is true.
      bool flag(String name) {
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

    Highlights from the preceding code:

    - **`options` map (`Map<Option, Object?>`)**:
      Associates each `Option` instance with its parsed user input.
    - **`where()` method in `flag()`**:
      Filters map keys to inspect only boolean flags (`option.type == OptionType.flag`),
      ignoring options that take string arguments.
    - **Type cast (`as bool`)**:
      Tells the type checker to treat the value as a `bool` because
      flags always store boolean values.
    - **Record return type (`({Option option, Object? input})`)**:
      Returns a lightweight, named record grouping both the `Option`
      and its value without declaring a separate class.

### Task 4: Export arguments from the package

Export `arguments.dart` from the package entry point to
allow other packages to import `Option` and `ArgResults`.

1.  Open `command_runner/lib/command_runner.dart`.

1.  Add the export statement:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for command-line parsing and execution.
    library;

    export 'src/arguments.dart';
    ```

    This `export` statement makes declarations in `arguments.dart` accessible
    to any package that imports `package:command_runner/command_runner.dart`.

### Task 5: Test the classes in cli.dart

Verify that `Option` instantiates and computes its `usage` string correctly.

1.  Open `cli/bin/cli.dart`.

1.  Replace the file contents with the following test code:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    void main() {
      final verboseOption = Option(
        'verbose',
        type: OptionType.flag,
        abbr: 'v',
        help: 'Display extra logging information.',
      );

      print('Defined option: ${verboseOption.name}');
      print('Usage: ${verboseOption.usage}');
    }
    ```

    This code calls the `Option` constructor to create an instance,
    and then prints its `name` field and computed `usage` getter.

1.  Run the application from the `cli` directory:

    ```bash
    dart run bin/cli.dart
    ```

    The console outputs:

    ```bash
    Defined option: verbose
    Usage: -v,--verbose: Display extra logging information.
    ```

    This confirms that the `Option` class and getter function as expected.

## Review

<SummaryCard>
title: What you accomplished
subtitle: A summary of the concepts and code introduced in this lesson.
completed: true
items:
  - title: Defined classes to model data and behavior
    icon: view_in_ar
    details: >-
      Created the `Option` and `ArgResults` classes to structure command-line
      arguments and parsed output.
  - title: Created constructors with initializing formals and named parameters
    icon: build
    details: >-
      Used `this.fieldName` syntax for automatic field initialization and
      defined optional and required named parameters with `{}` and `required`.
  - title: Used getters to compute properties dynamically
    icon: functions
    details: >-
      Implemented the `usage` getter to format option help text on demand
      without storing duplicate string state.
  - title: Used enums to represent fixed sets of values
    icon: format_list_bulleted
    details: >-
      Defined the `OptionType` enum to represent valid option types
      (`flag` and `option`), ensuring compile-time safety.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="object-oriented" />

## Next lesson

The next chapter covers sharing behavior between classes
using inheritance and abstract classes.
Define an abstract `CliElement` base class, and
build out the `Command` and `CommandRunner` architecture.

[classes]: /language/classes
[getters]: /resources/glossary#getter
[enums]: /language/enums
