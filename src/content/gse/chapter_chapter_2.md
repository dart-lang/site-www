---
title: "Chapter 2: Basic Dart Syntax"
description: "Learn about Control flow (`if/else`), collections (`List`, `isEmpty`, `.first`, `for-in`), variables, `const`, null checks, functions, strings, interpolation, `stdin`."
---

# Chapter 2: Basic Dart Syntax
Learn about Control flow (`if/else`), collections (`List`, `isEmpty`, `.first`, `for-in`), variables, `const`, null checks, functions, strings, interpolation, `stdin`.

[Video Placeholder]

In this lesson, you'll learn the fundamentals of Dart syntax, enabling you to build interactive command-line applications. We will cover control flow using `if/else` statements, working with collections like `List`, handling user input via `stdin`, defining functions, and manipulating strings. We'll put these concepts into practice by building a command-line tool that responds to user input and provides basic functionality.

## Background / Key Concepts
*   **Variables:** Variables are named storage locations in memory that hold data. In Dart, you can declare variables using `var`, `final`, or `const`.
*   **`const`:** Used to define compile-time constants. Their values must be known at compile time and cannot be changed during runtime.
*   **Control Flow (`if/else`):**  `if/else` statements allow you to execute different blocks of code based on whether a condition is true or false.
*   **Null Checks:** Dart has a strong type system that helps prevent null pointer exceptions. You can use the null-aware operator `?` and the null-assertion operator `!` to handle nullable variables.
*   **Collections (`List`):**  A `List` is an ordered collection of items. You can access elements by their index, add or remove elements, and iterate over the list.
*   **`isEmpty`:** A method on `List` that returns `true` if the list contains no elements.
*   **`.first`:** A property on `List` that returns the first element of the list.
*   **`for-in` Loop:** A convenient way to iterate over the elements of a collection.
*   **Functions:** Functions are reusable blocks of code that perform a specific task. They can accept arguments (inputs) and return values (outputs).
*   **Strings:** A sequence of characters. Dart provides rich string manipulation capabilities, including interpolation.
*   **Interpolation:**  A way to embed expressions directly into strings using the `${}` syntax.
*   **`stdin`:** A standard input stream that allows you to read data from the command line.

## Set up
Make sure you have completed Chapter 1 and have a working Dart project set up. We will be modifying the `bin/cli.dart` file in this chapter.  The name of your project may be different than `cli`, so be sure to adjust for that as you proceed.

## Tasks
In this lesson, we'll modify our Dart program to read user input, implement basic command-line arguments, and add a placeholder command.

### Update `pubspec.yaml`

1.  Navigate to the `cli` directory (or the name of your project)
2.  Open your `pubspec.yaml` file.
3.  Edit the `name:` field to be `cli`.
4.  The top of the file should look like this:

    ```yaml
    name: cli
    description: A sample command-line application.
    version: 1.0.0
    resolution: workspace
    publish_to: none
    ```

### Implement Command-Line Arguments

1.  Open `cli/bin/cli.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    import 'dart:io';

    const version = '0.0.1';

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'wikipedia') {
        // contrived
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        runApp(inputArgs);
      } else {
        printUsage();
      }
    }

    void printUsage() {
      print(
        "The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'",
      );
    }

    void runApp(List<String>? arguments) {
      late String? articleTitle;
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();
        return;
      } else {
        articleTitle = arguments.join(', ');
      }

      print('Looking up articles about $articleTitle. Please wait.');
      for (var arg in arguments) {
        print('Here ya go!');
        print('(Pretend this an article about $arg)');
      }
    }
    ```

3.  **Explanation:**
    *   **`import 'dart:io';`:** Imports the `dart:io` library, which provides access to input/output streams, including `stdin`.
    *   **`const version = '0.0.1';`:** Defines a constant variable `version` to store the application's version number. `const` ensures the value is known at compile time.
    *   **`main(List<String> arguments)`:** The `main` function now accepts a `List<String>` called `arguments`. This list contains the arguments passed to the program from the command line.
    *   **`if (arguments.isNotEmpty && arguments.first == 'version') { ... }`:** This `if` statement checks if the `arguments` list is not empty and if the first argument is equal to `'version'`. If both conditions are true, it prints the version number using string interpolation: `print('Dart Wikipedia version $version');`.
    *   **`else if (arguments.isNotEmpty && arguments.first == 'help') { ... }`:** Similarly, this `else if` statement checks for the `'help'` command and calls the `printUsage()` function.
    *   **`else { printUsage(); }`:** If no known command is passed, the `else` block is run, which prints the usage instructions.
    *   **`void printUsage() { ... }`:** This function prints the valid commands that the application accepts.
    *   **`void runApp(List<String>? arguments) { ... }`:**
        *   This function now takes a nullable `List<String>` called `arguments` as input.
        *   `late String? articleTitle;`: This declares a late-initialized nullable String named `articleTitle`. Late initialization means that the variable will be assigned a value before it's used, but not necessarily at the point of declaration.
        *   **`if (arguments == null || arguments.isEmpty) { ... }`:** This `if` statement checks if the `arguments` list is `null` or empty. If either condition is true, it prompts the user to enter an article title using `stdin.readLineSync()`.
        *   `stdin.readLineSync()`: This reads a line of text from the console. Because this operation can return `null` we need to guard against that.
        *   **`else { articleTitle = arguments.join(', '); }`:** If arguments are provided, the code joins them into a single string, separated by commas.
        *   The code then prints a message indicating that it's looking up articles about the provided title. It also iterates through the arguments, printing a placeholder message for each.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following commands and observe the output:

    ```bash
    dart run bin/cli.dart version
    ```

    Output:

    ```bash
    Dart Wikipedia version 0.0.1
    ```

    ```bash
    dart run bin/cli.dart help
    ```

    Output:

    ```bash
    The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'
    ```

    ```bash
    dart run bin/cli.dart wikipedia
    ```

    Output:

    ```bash
    Please provide an article title.
    // The program will now wait for you to enter input
    ```

    Enter an article title (e.g., "Dart Programming") and press Enter.

    ```bash
    Looking up articles about Dart Programming. Please wait.
    Here ya go!
    (Pretend this an article about Dart Programming)
    ```

    ```bash
    dart run bin/cli.dart wikipedia Dart is fun
    ```

    Output:

    ```bash
    Looking up articles about Dart is fun. Please wait.
    Here ya go!
    (Pretend this an article about Dart)
    Here ya go!
    (Pretend this an article about is)
    Here ya go!
    (Pretend this an article about fun)
    ```

[Pop out placeholder: Experiment with different command-line arguments and observe how the program responds. Try entering no arguments, or invalid commands to observe the `printUsage()` output.]

## Review
In this lesson, you learned how to:

*   Read command-line arguments using the `arguments` list in the `main` function.
*   Use `if/else` statements to implement control flow based on user input.
*   Define constant variables using `const`.
*   Read user input from the command line using `stdin.readLineSync()`.
*   Work with Lists.
*   Interpolate strings using `${}`.
*   Use functions to organize and reuse code.

**Quiz Question:**

What is the purpose of the `stdin.readLineSync()` function in Dart?

*   [Option A] To print text to the console.
*   [Option B] To read a line of text from the command line.
*   [Option C] To write data to a file.
*   [Option D] To perform mathematical calculations.

## Next lesson
In the next lesson, we'll introduce asynchronous programming and learn how to fetch data from the internet using the `http` package. This will allow us to retrieve real data from the Wikipedia API and display it in our command-line application.