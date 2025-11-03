---
title: Advanced OOP-adjacent features
shortTitle: Advanced OOP Features
description: >-
  Enhance your Dart skills by exploring advanced features like enhanced enums
  and extensions. Improve your application's output formatting and color,
  making it more user-friendly.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/error-handling
  title: Error handling
nextpage:
  url: /get-started/command-runner-polish
  title: command_runner polish
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll explore advanced Dart features that improve the user
experience of your command-line application. You'll learn how to use enhanced
enums to manage console colors and extensions to add new functionality to
existing types, making your application more interactive and visually appealing.

:::secondary What you'll learn

*   Use enhanced enums to define and manage console colors.
*   Apply extensions to add new methods to the `String` class.
*   Improve output formatting and color for a better user experience.

:::

## Prerequisites

Before you begin this chapter, ensure you:

*   Have completed Chapter 6 and have a working Dart development environment
    with the `dartpedia` project.
*   Are familiar with basic programming concepts like variables, functions, and
    control flow.
*   Understand the concepts of packages and libraries in Dart.
*   Have a basic understanding of object-oriented programming concepts like
    classes and enums.

## Tasks

You will improve the user experience of your Dartpedia CLI application by adding
color to the output and improving text formatting.

### Task 1: Enhance the console color enum

First, add color to the console output. The
`ConsoleColor` enum will include RGB values and methods for applying
colors to text.

1.  Create the `command_runner/lib/src/console.dart` file.

2.  Add the following code to define the `ConsoleColor` enum:

    ```dart title="command_runner/lib/src/console.dart"
    import 'dart:io';

    const String ansiEscapeLiteral = '\x1B';

    /// Splits strings on `\n` characters, then writes each line to the
    /// console. [duration] defines how many milliseconds there will be
    /// between each line print.
    Future<void> write(String text, {int duration = 50}) async {
      final List<String> lines = text.split('\n');
      for (final String l in lines) {
        await _delayedPrint('$l \n', duration: duration);
      }
    }

    /// Prints line-by-line
    Future<void> _delayedPrint(String text, {int duration = 0}) async {
      return Future<void>.delayed(
        Duration(milliseconds: duration),
        () => stdout.write(text),
      );
    }

    /// RGB formatted colors that are used to style input
    ///
    /// All colors from Dart's brand styleguide
    ///
    /// As a demo, only includes colors this program cares about.
    /// If you want to use more colors, add them here.
    enum ConsoleColor {
      /// Sky blue - #b8eafe
      lightBlue(184, 234, 254),

      /// Accent colors from Dart's brand guidelines
      /// Warm red - #F25D50
      red(242, 93, 80),

      /// Light yellow - #F9F8C4
      yellow(249, 248, 196),

      /// Light grey, good for text, #F8F9FA
      grey(240, 240, 240),

      ///
      white(255, 255, 255);

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;
    }
    ```

    This enum defines a set of console colors with their corresponding RGB
    values. Each color is a constant instance of the `ConsoleColor` enum.

3.  Add methods to the `ConsoleColor` enum for applying colors to text:

    ```dart title="command_runner/lib/src/console.dart"
    enum ConsoleColor {
      // ... (existing enum values)

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in terminal default color
      /// print('AnsiColor.red.enableForeground');
      /// print('hello'); // prints in red color
      /// ```
      String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in terminal default color
      /// print('AnsiColor.red.enableForeground');
      /// print('hello'); // prints in red color
      /// ```
      String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';

      /// Reset text and background color to terminal defaults
      static String get reset => '$ansiEscapeLiteral[0m';

      /// Sets text color for the input
      String applyForeground(String text) {
        return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$reset';
      }

      /// Sets background color and then resets the color change
      String applyBackground(String text) {
        return '$ansiEscapeLiteral[48;2;$r;$g;${b}m$text$ansiEscapeLiteral[0m';
      }
    }
    ```

    These methods use [ANSI escape codes][] to apply foreground and background
    colors to text. The `applyForeground` and `applyBackground` methods return
    a string with the ANSI escape codes applied.

### Task 2: Create a String extension

Next, create an extension on the `String` class to add utility methods
for applying console colors and formatting text.

1.  Add the following code to the `command_runner/lib/src/console.dart` file:

    ```dart title="command_runner/lib/src/console.dart"
    // Add this code to the bottom of the file
    extension TextRenderUtils on String {
      String get errorText => ConsoleColor.red.applyForeground(this);
      String get instructionText => ConsoleColor.yellow.applyForeground(this);
      String get titleText => ConsoleColor.lightBlue.applyForeground(this);

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

        // Add left overs
        output.add(strBuffer.toString().trim());
        return output;
      }
    }
    ```

    This code defines an extension called `TextRenderUtils` on the `String`
    class. It adds three getter methods for applying console colors:
    `errorText`, `instructionText`, and `titleText`. It also adds a method for
    splitting a string into lines of a specified length called `splitLinesByLength`.

### Task 3: Update command_runner package

Update the `command_runner` package to export `console.dart`.

1.  Open `command_runner/lib/command_runner.dart` and add the following line:

    ```dart title="command_runner/lib/command_runner.dart"
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/exceptions.dart';
    export 'src/help_command.dart';
    export 'src/console.dart'; // Add this line

    // TODO: Export any libraries intended for clients of this package.
    ```

### Task 4: Implement colorful echo command

Finally, implement an example command to test the print. It's
good practice to implement example usage of a package in Dart for
developers that will use your package.  This example creates a command
that makes console output colorful.

1.  Open the `example/command_runner_example.dart` file.
2.  Replace the contents of the file with the following code:

    ```dart title="command_runner/example/command_runner_example.dart"
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    class PrettyEcho extends Command<String> {
      PrettyEcho() {
        addFlag(
          'blue-only',
          abbr: 'b',
          help: 'When true, the echoed text will all be blue.',
        );
      }

      @override
      String get name => 'echo';

      @override
      bool get requiresArgument => true;

      @override
      String get description => 'Print input, but colorful.';

      @override
      String? get help =>
          'echos a String provided as an argument with ANSI coloring,';

      @override
      String? get valueHelp => 'STRING';

      @override
      FutureOr<String> run(ArgResults arg) {
        if (arg.commandArg == null) {
          throw ArgumentException(
            'This argument requires one positional argument',
            name,
          );
        }

        List<String> prettyWords = [];
        var words = arg.commandArg!.split(' ');
        for (var i = 0; i < words.length; i++) {
          var word = words[i];
          switch (i % 3) {
            case 0:
              prettyWords.add(word.titleText);
            case 1:
              prettyWords.add(word.instructionText);
            case 2:
              prettyWords.add(word.errorText);
          }
        }

        return prettyWords.join(' ');
      }
    }

    void main(List<String> arguments) {
      final runner = CommandRunner<String>()..addCommand(PrettyEcho());

      runner.run(arguments);
    }
    ```

    This code defines a `PrettyEcho` command that extends the `Command` class.
    It takes a string as an argument and applies different colors to each word
    based on its position in the string. The `run` method uses the `titleText`,
    `instructionText`, and `errorText` getter methods from the `TextRenderUtils`
    extension to apply the colors.

3.  Navigate to `/dartpedia/command_runner` and run the following command:

    ```bash
    dart run example/command_runner_example.dart echo "hello world goodbye"
    ```

    You should see the following text printed to the console, with the first
    word appearing in light blue, the second in yellow, and the third in red.

    ```bash
    hello world goodbye
    ```

## Review

In this lesson, you learned about:

*   Using enhanced enums to define and manage console colors.
*   Applying extensions to add new methods to the `String` class.
*   Improving output formatting and color for a better user experience.

## Quiz

**Question 1:** What is an enhanced enum in Dart?

*   A) An enum that can only have string values.
*   B) An enum that can have methods and properties.
*   C) An enum that is automatically generated by the Dart compiler.
*   D) An enum that can only be used in Flutter applications.

**Question 2:** What is a Dart extension?

*   A) A way to add new methods to existing classes.
*   B) A way to create new classes from existing classes.
*   C) A way to define new operators in Dart.
*   D) A way to create new variables in Dart.

## Next lesson

In the next lesson, you'll learn how to further improve the
`command_runner` package by polishing the `HelpCommand`, completing the
`CommandRunner` class, adding the `onOutput` argument, and providing a complete
example.

[ANSI escape codes]: https://en.wikipedia.org/wiki/ANSI_escape_code
