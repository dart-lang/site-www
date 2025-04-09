---
title: "Chapter 4: Packages and Libraries"
description: "Learn about Libraries and `export` statements."
---

# Chapter 4: Packages and Libraries
Learn about Libraries and `export` statements.

[Video Placeholder]

In this lesson, you'll learn how to refactor your code into reusable components using Dart libraries and packages. We'll focus on creating a separate package for our command-line logic, which will help organize our project and make it more maintainable. By the end of this lesson, you'll understand how to create a new package, move code into it, and import it into your main application. You'll also learn about the `export` statement, which allows you to control which parts of your library are visible to other parts of your application.

## Background / Key Concepts
*   **Packages:** A package is a reusable unit of code that can be shared across multiple projects. Packages typically contain libraries, executables, tests, and other assets.
*   **Libraries:** A library is a collection of related code, such as functions, classes, and variables, that can be imported and used in other parts of your application. Libraries help organize code and promote reusability.
*   **`export` statement:** The `export` keyword in Dart allows you to re-export symbols (classes, functions, variables, etc.) from one library to another. This means that you can create a library that acts as a facade, exposing a subset of symbols from other libraries.
*   **Code Organization:** Structuring your code into well-defined packages and libraries makes it easier to understand, maintain, and test. It also promotes code reuse, which can save time and effort in the long run.
*   **Modularity:** Breaking down a large application into smaller, independent modules (packages and libraries) improves its overall structure and reduces dependencies.

## Set up
Make sure you have completed Chapter 3 and have a working Dart project set up. We will be creating a new package called `command_runner` in this chapter, and modifying both the root `pubspec.yaml` file and `cli/bin/cli.dart` file.

## Tasks
In this lesson, we'll create a new `command_runner` package, move the command-line handling logic from `cli/bin/cli.dart` into the new package, and update `cli/bin/cli.dart` to import and use the new package.

### Create a new Dart package
1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (the directory containing the `cli` directory).

3.  Run the following command:

    ```bash
    dart create -t package command_runner
    ```

    This command uses the `dart create` tool to generate a basic Dart package named "command_runner". The `-t package` flag specifies that we want to create a package, not a standalone application.

    You should see output similar to this:

    ```bash
    Creating package 'command_runner'...
    Running pub get in command_runner...
    Wrote command_runner/analysis_options.yaml.
    Wrote command_runner/lib/command_runner.dart.
    Wrote command_runner/test/command_runner_test.dart.
    Wrote command_runner/pubspec.yaml.
    Wrote command_runner/README.md.

    All done!
    ```

### Update the workspace `pubspec.yaml`
1.  Open the `pubspec.yaml` file in the root of your workspace.
2.  Add the following workspace entry.

    ```yaml
    workspace:
      - cli
      - command_runner
    ```

### Move the CommandRunner logic

1.  Create the directory `command_runner/lib/src`.

2.  Create the file `command_runner/lib/src/command_runner_base.dart`.

3.  Add the following code to the file.

    ```dart
    class CommandRunner {
      Future<void> run(List<String> input) async {
        print(input);
      }
    }
    ```

4.  Open `command_runner/lib/command_runner.dart` and add the following code.

    ```dart
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;

    export 'src/command_runner_base.dart';

    // TODO: Export any libraries intended for clients of this package.
    ```

    *   **`library;`**: Declares the current file as a library. This is generally good practice.
    *   **`export 'src/command_runner_base.dart';`**: Re-exports the contents of `src/command_runner_base.dart`. This line makes the `CommandRunner` class available to anyone who imports the `command_runner` package. This is a core concept when making packages, since code that is not exported is, by definition, private.

### Update `cli/pubspec.yaml` to depend on `command_runner`

1.  Open `cli/pubspec.yaml` in your code editor.

2.  Add a dependency on the `command_runner` package in the `dependencies` section.  Since `command_runner` is part of the same workspace, we can use a `path` dependency.

    ```yaml
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
    ```

    This tells Dart that the `cli` package depends on the `command_runner` package, and that the `command_runner` package can be found in the `../command_runner` directory (relative to the `cli/pubspec.yaml` file).

3.  Run `dart pub get` in your terminal from the `cli` directory to update the dependencies.

### Update `cli/bin/cli.dart` to use the `command_runner` package

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

    void main(List<String> arguments) {
      var runner = CommandRunner();
      runner.run(arguments);
    }
    ```

    *   **`import 'package:command_runner/command_runner.dart';`:** This line imports the `command_runner` package, which we created in the previous steps.
    *   **`var runner = CommandRunner();`:** This line creates an instance of the `CommandRunner` class from the `command_runner` package.
    *   **`runner.run(arguments);`:** This line calls the `run` method on the `CommandRunner` instance, passing in the command-line arguments.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following command and observe the output:\

    ```bash
    dart run bin/cli.dart hello world
    ```

    Output:

    ```bash
    [hello, world]
    ```

[Pop out placeholder: Experiment with different command-line arguments and observe the output. The output should be the same as before, but now the command-line handling logic is in a separate package.]

## Review
In this lesson, you learned how to:

*   Create a new Dart package using the `dart create` tool.
*   Move code into a package.
*   Depend on a package using the `pubspec.yaml` file and `dart pub get`.
*   Import a package using the `import` statement.
*   Use the `export` statement to control which parts of a library are visible to other parts of your application.
*   Organize code into packages and libraries to improve code structure and maintainability.

**Quiz Question:**

What is the purpose of the `export` keyword in Dart?

*   [Option A] To define a constant variable.
*   [Option B] To re-export symbols from one library to another.
*   [Option C] To create a new object.
*   [Option D] To import a package.

## Next lesson
In the next lesson, we'll dive deeper into object-oriented programming in Dart and learn how to create more complex and flexible command-line applications. We'll introduce concepts like `sealed` and `abstract` classes, generics, inheritance, and overrides.