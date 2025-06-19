---
title: Advanced OOP
short-title: Advanced OOP
description: >-
  Improve output formatting and color in your Dart CLI application using enhanced enums and extensions.
prevpage:
  url: /get-started/error-handling
  title: Error Handling in Dart
nextpage:
  url: /get-started/command-runner-polish
  title: command_runner polish
---

{% include 'fwe-wip-warning.md' %}

In this chapter, you'll learn how to enhance your Dart CLI application's user experience by leveraging advanced, object-oriented-adjacent features. You'll focus on improving the formatting and presentation of output using enhanced enums and extensions.

:::secondary What you'll learn

* Use enhanced enums to associate data and behavior with a set of constant values.
* Create and apply extensions to add new functionality to existing types, including built-in types like `String`.
* Refactor your code to utilize these features for improved readability and maintainability.
* Apply color to the CLI output.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* Completed Chapter 6 and have a working `dartpedia` project with the `command_runner` package.
* Are familiar with the basic concepts of programming, like variables and functions.
* Understand what an enum is, as a way to list a few constant values.

## Tasks

Let's improve the look and feel of our CLI app by adding color and improving the formatting of the output using enhanced enums and extensions.

### Task 1: Add color using enhanced enums

First, you'll create an enhanced enum to define colors for your CLI output.

1.  Create the file `command_runner/lib/src/console.dart`.

2.  Start by defining the basic structure of the `ConsoleColor` enum. At its core, an enhanced enum allows you to associate data with each enum constant. Here, we'll store RGB values for each color.

    ```dart title="command_runner/lib/src/console.dart"
    const String ansiEscapeLiteral = '\x1B';

    /// RGB formatted colors that are used to style input
    enum ConsoleColor {
      // Define color constants with their RGB values
      lightBlue(184, 234, 254),
      red(242, 93, 80),
      yellow(249, 248, 196),
      grey(240, 240, 240),
      white(255, 255, 255);

      // Add a constructor to initialize the RGB values for each enum constant.
      const ConsoleColor(this.r, this.g, this.b);

      // Declare final fields to hold the red, green, and blue components.
      final int r;
      final int g;
      final int b;
    }
    ```

    In this initial skeleton, we've declared the `ConsoleColor` enum with its color constants and their associated RGB values. The `const ConsoleColor(this.r, this.g, this.b);` constructor allows us to assign these values directly when defining each enum constant. The `final int r;`, `final int g;`, and `final int b;` fields store these RGB values.

3.  Next, let's add properties that generate the ANSI escape codes for enabling foreground and background colors. These codes are special character sequences that terminals interpret to change text color.

    ```dart title="command_runner/lib/src/console.dart"
    const String ansiEscapeLiteral = '\x1B';

    /// RGB formatted colors that are used to style input
    enum ConsoleColor {
      lightBlue(184, 234, 254),
      red(242, 93, 80),
      yellow(249, 248, 196),
      grey(240, 240, 240),
      white(255, 255, 255);

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;

      /// Change text color for all future output (until reset)
      /// For example: `print('AnsiColor.red.enableForeground'); print('hello');`
      String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';

      /// Change background color for all future output (until reset)
      /// For example: `print('AnsiColor.red.enableBackground'); print('hello');`
      String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';
    }
    ```

    Here, we've added two getters: `enableForeground` and `enableBackground`. These getters construct the specific ANSI escape sequences using the stored `r`, `g`, and `b` values. When printed to a compatible terminal, these sequences will change the color of all subsequent text.

4.  Now, let's add a static getter to reset the text and background colors to their default terminal settings, and methods to apply foreground and background colors directly to a given string, ensuring the color is reset afterward.

    ```dart title="command_runner/lib/src/console.dart"
    const String ansiEscapeLiteral = '\x1B';

    /// RGB formatted colors that are used to style input
    enum ConsoleColor {
      lightBlue(184, 234, 254),
      red(242, 93, 80),
      yellow(249, 248, 196),
      grey(240, 240, 240),
      white(255, 255, 255);

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;

      String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';
      String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';

      /// Reset text and background color to terminal defaults
      static String get reset => '$ansiEscapeLiteral[0m';

      /// Sets text color for the input and then resets the color change.
      String applyForeground(String text) {
        return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$reset';
      }

      /// Sets background color for the input and then resets the color change.
      String applyBackground(String text) {
        return '$ansiEscapeLiteral[48;2;$r;$g;${b}m$text$ansiEscapeLiteral[0m';
      }
    }
    ```

    We've introduced `static String get reset => '$ansiEscapeLiteral[0m';` which provides the ANSI escape code to return the terminal to its default colors. Additionally, `applyForeground` and `applyBackground` methods are added. These methods are convenient for wrapping a string with color codes, ensuring that the color is applied only to that specific string and then reset, preventing subsequent output from being unexpectedly colored.

This completes the `ConsoleColor` enhanced enum, allowing you to easily manage and apply colors in your CLI application.

### Task 2: Add text formatting with an extension

Next, you'll create an extension on the `String` class to add formatting capabilities.

1.  Add the following code to `command_runner/lib/src/console.dart`. Start by defining the basic structure of an extension. An extension allows you to add functionality to existing types (like `String`) without modifying their original source code.

    ```dart title="command_runner/lib/src/console.dart"
    // ... (previous ConsoleColor enum code) ...

    extension TextRenderUtils on String {
      // This is where we'll add new methods and getters for String.
    }
    ```

    We've declared an extension named `TextRenderUtils` that operates on the `String` type. This means any methods or getters we add inside this extension will be available on all `String` objects.

2.  Now, let's add some simple getters to apply specific colors to strings using the `ConsoleColor` enum we just created.

    ```dart title="command_runner/lib/src/console.dart"
    // ... (previous ConsoleColor enum code) ...

    extension TextRenderUtils on String {
      /// Applies red foreground color to the string.
      String get errorText => ConsoleColor.red.applyForeground(this);

      /// Applies yellow foreground color to the string.
      String get instructionText => ConsoleColor.yellow.applyForeground(this);

      /// Applies light blue foreground color to the string.
      String get titleText => ConsoleColor.lightBlue.applyForeground(this);
    }
    ```

    We've added three getters: `errorText`, `instructionText`, and `titleText`. Each of these getters uses the `applyForeground` method from our `ConsoleColor` enum to wrap the string (referred to as `this` within the extension) with the appropriate color codes. This makes it very convenient to color specific types of text in your CLI output.

3.  Finally, let's add a more complex method to this extension: `splitLinesByLength`. This method will help us format long strings into multiple lines, ensuring better readability in the console.

    ```dart title="command_runner/lib/src/console.dart"
    // ... (previous ConsoleColor enum code) ...

    extension TextRenderUtils on String {
      String get errorText => ConsoleColor.red.applyForeground(this);
      String get instructionText => ConsoleColor.yellow.applyForeground(this);
      String get titleText => ConsoleColor.lightBlue.applyForeground(this);
    
      /// Splits the string into multiple lines based on a maximum `length`.
      /// Words are kept together, and lines are wrapped to fit the specified length.
      List<String> splitLinesByLength(int length) {
        final List<String> words = split(' ');
        final List<String> output = <String>[];
        final StringBuffer strBuffer = StringBuffer();
        for (int i = 0; i < words.length; i++) {
          final String word = words[i];
          if (strBuffer.length + word.length <= length) {
            strBuffer.write(word.trim());
            if (strBuffer.length + 1 <= length) {
              strBuffer.write(' ');
            }
          }
          // If the next word surpasses length, start the next line
          if (i + 1 < words.length &&
              words[i + 1].length + strBuffer.length + 1 > length) {
            output.add(strBuffer.toString().trim());
            strBuffer.clear();
          }
        }
    
        // Add any remaining text as the last line.
        output.add(strBuffer.toString().trim());
        return output;
      }
    }
    ```

    We've now included the `splitLinesByLength` method. This method takes an `int length` as an argument and returns a `List<String>`, where each string in the list represents a line formatted to be no longer than the specified `length`. This is particularly useful for ensuring that your CLI output doesn't overflow horizontally, making it much more user-friendly.

This completes the `TextRenderUtils` extension, providing powerful string manipulation and formatting capabilities for your CLI application.

### Task 3: Apply the extension

Apply the new `TextRenderUtils` extension to format output in the CLI.

1.  Open the `command_runner/lib/src/help_command.dart` file.

2.  Update the `HelpCommand` class to use the `TextRenderUtils` extension for formatting the output:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';

    import 'arguments.dart';
    import 'console.dart';

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
        var usage = runner.usage.titleText;
        for (var command in runner.commands) {
          usage += '\n ${command.usage}';
        }

        return usage;
      }
    }
    ```

    In this change, you're using the `titleText` extension getter on the `usage` string, which will apply the `lightBlue` color to the title in the console output. The rest of the commands in the `help` command will not have a color for now.

3.  Also, make sure to export the console from the `command_runner`.

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/console.dart';
    export 'src/exceptions.dart';
    export 'src/help_command.dart';

    // TODO: Export any libraries intended for clients of this package.
    ```

### Task 4: Run the application

Test the enhanced enums and extensions.

1.  Open your terminal and navigate to the `cli` directory.

2.  Run the command `dart run bin/cli.dart help`.

    You should now see the title text in `lightBlue`:

    ```text
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

## Review

In this lesson, you learned about:

* Using **enhanced enums** to define colors and associate them with behavior.
* Creating and applying **extensions** to add new functionality to existing types.
* Refactoring code to utilize these features for improved readability and maintainability.

## Quiz

**Question 1:** What is an enhanced enum in Dart?

* A) A class that can only have constant values.
* B) An enum that can have associated data and behavior.
* C) A type of variable that can only store primitive types.
* D) A function that can only be called once.

**Question 2:** What is an extension in Dart?

* A) A way to add new functionality to existing types.
* B) A way to create new classes.
* C) A type of variable that can store multiple values.
* D) A function that can be called from any class.

## Next lesson

In the next lesson, you'll learn how to polish the `command_runner` package by improving the `HelpCommand`, completing the `CommandRunner`, adding an `onOutput` argument, and providing an example.