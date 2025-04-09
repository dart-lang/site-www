---
title: "Chapter 7: Advanced OOP-adjacent features"
description: "Learn about enhanced enum, extension."
---

# Chapter 7: Advanced OOP-adjacent features
Learn about enhanced enum, extension.

[Video Placeholder]

In this lesson, we'll be exploring some advanced, but commonly used, Dart features that improve code readability and user experience: enhanced enums and extensions. We'll use these features to add color to our CLI app, making it more visually appealing and informative. By the end of this lesson, you'll understand how to use enhanced enums to create more powerful and flexible enumerations, and how to use extensions to add new functionality to existing classes without modifying their original code.

## Background / Key Concepts
*   **Enhanced Enums:**  Dart enums can have methods, fields, and constructors, making them more powerful than simple enumerations. This allows you to encapsulate logic and data within the enum itself.
*   **Extensions:**  A way to add new functionality to existing classes (even classes you don't control) without modifying their original source code. This promotes code reusability and avoids polluting the original class with extra methods.
*   **User Experience (UX):** Designing software with the user's needs and preferences in mind. A good UX makes the software more enjoyable and efficient to use.
*   **Console Output Formatting:** Using colors and other formatting techniques to make console output more readable and visually appealing.

## Set up
Make sure you have completed Chapter 6 and have a working Dart project set up with the `cli` and `command_runner` packages.

## Tasks
In this lesson, we'll improve the user experience of our CLI application by adding color to the console output. We'll use an enhanced enum to define a set of console colors, and an extension to add methods to the `String` class for applying these colors to text.

### Create a `ConsoleColor` Enhanced Enum
1.  Open `command_runner/lib/src/console.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

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

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in terminal default color
      /// print('AnsiColor.red.enableForeground');
      /// print('hello'); // prints in red color
      /// ```
      String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in red color
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

3.  **Explanation:**

    *   **`enum ConsoleColor { ... }`:**  Defines an enhanced enum called `ConsoleColor`.  It encapsulates data (RGB values) and methods related to console colors.
    *   **`lightBlue(184, 234, 254), red(242, 93, 80), ...`:** Declares several `ConsoleColor` constants, each with its own RGB values. These values will be used to format the console output.
    *   **`const ConsoleColor(this.r, this.g, this.b);`:** Defines a constructor for the `ConsoleColor` enum. Each enum value must call this constructor.
    *   **`final int r; final int g; final int b;`:** Declares final fields to store the RGB values for each color.
    *   **`String get enableForeground => ...;`**: Getter to return the ANSI escape code to set the foreground color.
    *   **`String get enableBackground => ...;`**: Getter to return the ANSI escape code to set the background color.
    *   **`static String get reset => ...;`**: A static getter to reset the color.
    *   **`String applyForeground(String text) { ... }`:** A method that applies the color to the provided text by wrapping it with ANSI escape codes.
    *   **`String applyBackground(String text) { ... }`:** A method that applies the background color to the provided text by wrapping it with ANSI escape codes.

### Create a `TextRenderUtils` Extension
1.  In the same file, `command_runner/lib/src/console.dart`, locate the `extension TextRenderUtils on String { ... }` block.

2.  **Explanation:**

    *   **`extension TextRenderUtils on String { ... }`:** Defines an extension called `TextRenderUtils` that extends the `String` class. This allows us to add new methods to the `String` class without modifying its original code.
    *   **`String get errorText => ConsoleColor.red.applyForeground(this);`:** A getter that applies the `red` color to the string using the `applyForeground` method.
    *   **`String get instructionText => ConsoleColor.yellow.applyForeground(this);`:** A getter that applies the `yellow` color to the string using the `applyForeground` method.
    *   **`String get titleText => ConsoleColor.lightBlue.applyForeground(this);`:** A getter that applies the `lightBlue` color to the string using the `applyForeground` method.
    *   **`List<String> splitLinesByLength(int length) { ... }`:** A method that splits a string into multiple lines, each with a maximum length. This is useful for formatting long text in the console.

### Export `console.dart`
1.  Open `command_runner/lib/command_runner.dart` in your code editor.

2.  Add the following line to the file:

    ```dart
    export 'src/console.dart';
    ```

    This line exports the `console.dart` file, making the `ConsoleColor` enum and the `TextRenderUtils` extension available to anyone who imports the `command_runner` package.

### Use the `ConsoleColor` and `TextRenderUtils` to change the output of your CLI program.
1.  Open `command_runner/lib/src/help_command.dart` in your code editor.

2.  Replace the `run` method with the following:

    ```dart
        @override
      FutureOr<String> run(ArgResults args) async {
        var usage = runner.usage.titleText;
        for (var command in runner.commands) {
          usage += '\n ${command.usage.instructionText}';
        }

        return usage;
      }
    ```
3.  **Explanation:**

    *   We can now use the extensions we defined in `command_runner/lib/src/console.dart`
    *   `runner.usage.titleText` colorizes the `usage` getter of the `CommandRunner` class.
    *   `command.usage.instructionText` colorizes the `usage` getter of each command.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following command and observe the output:

    ```bash
    dart run bin/cli.dart help
    ```

    You should now see the output formatted with colors:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?] (in light blue)
     help:  Prints usage information to the command line. (in yellow)
    ```

[Pop out placeholder: Experiment with different article titles. Try entering titles that don\'t exist to see the error message.]

## Review
In this lesson, you learned how to:

*   Create an enhanced enum with methods, fields, and constructors.
*   Use extensions to add new functionality to existing classes.
*   Improve the user experience of a command-line application by adding color to the console output.
*   Apply console output formatting to make your CLI program more readable.

**Quiz Question:**

What is the primary benefit of using extensions in Dart?
*   [Option A] To define constant variables.
*   [Option B] To add new functionality to existing classes without modifying their original code.
*   [Option C] To create new objects.
*   [Option D] To import a package.

## Next lesson

In the next lesson, we'll improve the output of the `HelpCommand`, add a parameter to the `CommandRunner`, and provide an example of how to use this `CommandRunner` library in your own code.