---
title: Packages and Libraries
description: Learn how to organize your Dart code into reusable libraries and packages.
---

In this chapter, you'll learn how to refactor your Dart code into reusable components by creating a separate package for handling command-line arguments. This involves understanding Dart libraries, `export` statements, and how to structure your project for better organization and maintainability. This refactoring will set the stage for building a more advanced command-line application in the next part of the guide.

## Prerequisites

* Completion of Chapter 3, which covered asynchronous programming and HTTP requests.
* Basic understanding of code organization principles.

## Background / Key Concepts

* **Libraries:** A way to encapsulate reusable code in Dart. Libraries can be distributed as packages.
* **Packages:** A collection of Dart code, along with a `pubspec.yaml` file that describes the package's metadata (name, version, dependencies, etc.). Packages are used to share code between projects.
* **`export` statement:** Allows you to make declarations from one library available in another library. This is useful for creating a public API for your package.
* **Code Refactoring:** The process of restructuring existing computer code—changing the factoring—without changing its external behavior. Done to improve code maintainability, readability, and sometimes performance.

## Tasks

In this chapter, you'll be refactoring the existing CLI application by extracting the command-line argument parsing logic into a separate package called `command_runner`. This will improve the structure of your project, making it more modular and maintainable.

### Task 1: Create the `command_runner` Package

First, you'll create a new Dart package to house the command-line argument parsing logic.

1.  Navigate to the root directory of your project (the one containing both your `cli` folder and the top-level `pubspec.yaml` for the workspace). If you set up your project as `dartpedia` in Chapter 1, this would be the `dartpedia` directory.
2.  Run the following command in your terminal:

    ```bash
    dart create -t package command_runner
    ```

    This command creates a new directory named `command_runner` with the basic structure of a Dart package.
    You should now see a new folder `command_runner` in your project root, alongside `cli`.

### Task 2: Move Code to the `command_runner` Package

Now that you have created the `command_runner` package, you need to add a placeholder class that will eventually handle the command-line argument parsing logic.

1.  Open the `command_runner/lib/command_runner.dart` file. Remove any existing placeholder code and add the following:

    ```dart
    /// A simple command runner to handle command-line arguments.
    ///
    /// More extensive documentation for this library goes here.
    library;

    export 'src/command_runner_base.dart';
    // TODO: Export any other libraries intended for clients of this package.
    ```
    * `library;`: Declares this file as a library.
    * `export 'src/command_runner_base.dart';`: This line is crucial. It makes declarations from `command_runner_base.dart` (and anything else declared in `command_runner_base.dart`) available to other packages that import the `command_runner` package. Without this `export` statement, the classes and functions within `command_runner_base.dart` would be private to the `command_runner` package, and you wouldn't be able to use them in your `cli` application.

2.  Create the file `command_runner/lib/src/command_runner_base.dart`.
3.  Add the following `CommandRunner` class to `command_runner/lib/src/command_runner_base.dart`:

    ```dart
    class CommandRunner {
      /// Runs the command-line application logic with the given arguments.
      Future<void> run(List<String> input) async {
        print('CommandRunner received arguments: $input');
      }
    }
    ```
    This `CommandRunner` class will serve as a simplified stand-in for now. Its `run` method currently just prints the arguments it receives. In later chapters, you'll expand this class to handle complex command parsing.

### Task 3: Add `command_runner` as a Dependency

Now that you've created the `command_runner` package and added a placeholder `CommandRunner` class, you need to tell your `cli` application that it depends on `command_runner`. Because the `command_runner` package is located locally within your project, you will use the `path` dependency option.

1.  Open the `cli/pubspec.yaml` file.
2.  Locate the `dependencies` section. Add the following lines:

    ```yaml
    dependencies:
      http: ^1.3.0 # Keep your existing http dependency
      command_runner:
        path: ../command_runner # Points to your local command_runner package
    ```

    This tells the `cli` application to depend on the `command_runner` package, and specifies that the package is located in the `../command_runner` directory (relative to the `cli` directory).
3.  Run `dart pub get` in the `cli` directory of your terminal to fetch the new dependency.

### Task 4: Import and Use the `command_runner` Package

Now that you've added `command_runner` as a dependency, you can import it into your `cli` application and replace your existing argument-handling logic with the new `CommandRunner` class.

1.  Open the `cli/bin/cli.dart` file.

2.  Add the following import statement at the top of the file, alongside your other imports:

    ```dart
    import 'package:command_runner/command_runner.dart';
    ```

    This imports the `command_runner` package, making the `CommandRunner` class available for use.

3.  **Refactor the `main` function:**
    Currently, your `main` function from Chapter 3 contains an `if/else if` chain that directly handles commands like `version`, `help`, and `search`. You'll now replace this entire logic with a simpler call to `CommandRunner`.

    **Your existing `main` function should look similar to this:**
    ```dart
    // ... (imports and const version)

    // printUsage function needs to be here (above main)
    void printUsage() { /* ... */ }

    void main(List<String> arguments) async {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version'); // (Note: "Wikipedia" will be renamed later)
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'search') {
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : <String>[];
        await runApp(inputArgs);
      } else {
        printUsage();
      }
    }

    // ... (runApp and getArticleSummary functions)
    ```

    **Now, replace the entire `main` function with the following updated version:**

    ```dart
    // ... (keep your existing imports, and const version)
    // You can remove or comment out the printUsage, runApp, and getArticleSummary
    // functions for now, as they will be re-integrated into the command_runner
    // package in later chapters.

    void main(List<String> arguments) async { // Keep main as async
      var runner = CommandRunner(); // Create an instance of your new CommandRunner
      await runner.run(arguments); // Call its run method, awaiting its Future<void>
    }
    ```

    * `var runner = CommandRunner();`: This creates an instance of the `CommandRunner` class from your new `command_runner` package.
    * `await runner.run(arguments);`: This calls the `run` method on the `CommandRunner` instance, passing in the command-line arguments. Since `CommandRunner.run` returns a `Future<void>`, `main` must `await` its completion.

    **Note:** For this chapter, you can temporarily remove or comment out the `printUsage`, `runApp`, and `getArticleSummary` functions from `cli/bin/cli.dart`. They will be redesigned and moved into the `command_runner` package in future chapters, as part of building the full command-line framework.

### Task 5: Run the Application

Now that you've refactored the code and updated the `cli` application to use the `command_runner` package, you can run the application to verify that everything is working correctly at this stage.

1.  Open your terminal and navigate to the `cli` directory.
2.  Run the command with the `search` command:

    ```bash
    dart run bin/cli.dart search Dart
    ```

3.  The application should now execute without errors and print the arguments to the console, demonstrating that the control has successfully transferred to your new `command_runner` package.

    ```bash
    CommandRunner received arguments: [search, Dart]
    ```

    :::important
    **Important Note on Functionality:**
    You'll notice that the article-fetching functionality (from Chapter 3) is no longer active. This is expected! In this chapter, you've refactored the project structure by moving the command-handling responsibility. The next chapters will focus on rebuilding and enhancing that core application logic within the `command_runner` package.
    :::

    :::important
    **Important Note on Naming:**
    In this guide, the example project's root directory is `dartpedia`, and the primary command for finding information is `search`. The API endpoint for fetching articles uses `en.wikipedia.org` temporarily. As this guide progresses to more advanced topics, these names and the specific API endpoint will be updated to a project-specific, legally-safe alternative based on team decisions.
    :::

## Review

In this chapter, you learned about:

* Creating Dart packages using `dart create -t package`.
* Using `export` statements to make declarations from one library available in another.
* Adding local packages as dependencies using the `path` option in `pubspec.yaml`.
* Importing packages into your Dart code using `import` statements.
* Refactoring code to improve organization and maintainability.

## Quiz

**Question 1:** What is the purpose of the `export` statement in a Dart library?

* A) To hide declarations from other libraries.
* B) To make declarations available to other libraries.
* C) To specify the version of the Dart SDK required by the library.
* D) To define the entry point of the library.

**Question 2:** How do you add a local package as a dependency in `pubspec.yaml`?

* A) By specifying the package name and version.
* B) By specifying the package name and the path to the package.
* C) By using the `git` option and specifying the URL of the Git repository.
* D) By using the `hosted` option and specifying the URL of the package server.

**Question 3:** What command do you use to create a new Dart package?

* A) `dart create -t application`
* B) `dart create -t library`
* C) `dart create -t package`
* D) `dart create -t console`

## Next lesson

In the next chapter, you'll dive into object-oriented programming (OOP) concepts in Dart. You'll learn how to create classes, define inheritance relationships, and build a more robust command-line argument parsing framework using OOP principles within your new `command_runner` package.