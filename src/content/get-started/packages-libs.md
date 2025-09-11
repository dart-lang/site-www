---
title: Organizing Dart code with packages and libraries
short-title: Packages and libraries
description: >-
  Learn how to organize your Dart code into reusable libraries and packages.
sitemap: false
noindex: true
showToc: false
prevpage:
  url: /get-started/async
  title: Introduction to async and HTTP
nextpage:
  url: /get-started
  title: Object oriented dart
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll level up from basic Dart syntax to building command-line
applications "the Dart way," embracing best practices. You'll learn to refactor
your code into reusable components by creating a dedicated package for handling
command-line arguments. This step sets you up for building a more advanced
command-line application in future chapters, which will integrate specialized
packages for Wikipedia logic and a robust `command_runner` framework. This
chapter helps you understand Dart libraries, export statements, and how to
structure your project for better organization and maintainability.

:::secondary What you'll learn

* Create new Dart packages using `dart create -t package`.
* Structure your project to include local packages.
* Add local packages as dependencies using the `path` option in `pubspec.yaml`.
* Use `export` statements to make library declarations available to other
  packages.
* Import and use classes from your new package in your `dartpedia` application.
* Recognize the benefits of separating code into packages.

:::

## Prerequisites

* Completion of Chapter 3, which covered asynchronous programming and HTTP
  requests.

## Tasks

In this chapter, you'll be refactoring the existing `dartpedia` CLI application
by extracting the command-line argument parsing logic into a separate package
called `command_runner`. This will improve the structure of your project, making
it more modular and maintainable.

:::note
There is a `command_runner` class that is part of the officially maintained
[`args` package]({{site.pub-pkg}}/args). For this tutorial we're
building our own `command_runner` class, but in a real project you would likely
use the class from `args`.
:::

### Task 1: Create the command_runner package

First, create a new Dart package to house the command-line argument
parsing logic.

1.  Navigate to the root directory of your project (`/dartpedia`).

1.  Run the following command in your terminal:

    ```bash
    dart create -t package command_runner
    ```

    This command creates a new directory named `command_runner` with the basic
    structure of a Dart package. You should now see a new folder
    `command_runner` in your project root, alongside `cli`.

### Task 2: Implement the CommandRunner class

Now that you have created the `command_runner` package, add a
placeholder class that will eventually handle the command-line argument parsing
logic.

1.  Open the `command_runner/lib/command_runner.dart` file. Remove any existing
    placeholder code and add the following:

    ```dart
    /// A simple command runner to handle command-line arguments.
    ///
    /// More extensive documentation for this library goes here.
    library;

    export 'src/command_runner_base.dart';
    // TODO: Export any other libraries intended for clients of this package.
    ```

    Highlights from the preceding code:

    * `library;` declares this file as a library, which helps define the
      boundaries and public interface of a reusable unit of Dart code.
    * `export 'src/command_runner_base.dart';` is a crucial line that makes
      declarations from `command_runner_base.dart` available to other packages
      that import the `command_runner` package. Without this `export` statement,
      the classes and functions within `command_runner_base.dart` would be
      private to the `command_runner` package, and you wouldn't be able to use
      them in your `dartpedia` application.

1.  Open the file `command_runner/lib/src/command_runner_base.dart`.

1.  Remove any existing placeholder code and add the following `CommandRunner`
    class to `command_runner/lib/src/command_runner_base.dart`:

    ```dart
    class CommandRunner {
      /// Runs the command-line application logic with the given arguments.
      Future<void> run(List<String> input) async {
        print('CommandRunner received arguments: $input');
      }
    }
    ```

    Highlights from the preceding code:

    * `CommandRunner` is a class that serves as a simplified stand-in for now. Its
      `run` method currently just prints the arguments it receives. In later
      chapters, you'll expand this class to handle complex command parsing.
    * `Future<void>` is a return type that indicates that this method might perform
      asynchronous operations, but doesn't return a value.

### Task 3: Add `command_runner` as a dependency

Now that you've created the `command_runner` package and added a placeholder
`CommandRunner` class, you need to tell your `cli` application that it depends
on `command_runner`. Because the `command_runner` package is located locally
within your project, use the `path` dependency option.

1.  Open the `cli/pubspec.yaml` file.

1.  Locate the `dependencies` section. Add the following lines:

    :::note
    Make sure you open the correct `/dartpedia/cli/pubspec.yaml` file. When you
    created the `command_runner` package, it also came with a
    `/dartpedia/command_runner/pubspec.yaml` file.
    :::

    ```yaml
    dependencies:
      http: ^1.3.0 # Keep your existing http dependency
      command_runner:
        path: ../command_runner # Points to your local command_runner package
    ```

    This section tells the `cli` application to depend on the
    `command_runner` package, and specifies that the package is located in the
    `../command_runner` directory (relative to the `cli` directory).

2.  Run `dart pub get` in the `/dartpedia/cli` directory of your terminal to
    fetch the new dependency.

### Task 4: Import and use the `command_runner` package

Now that you've added `command_runner` as a dependency, you can import it into
your `cli` application and replace your existing argument-handling logic with
the new `CommandRunner` class. This step also fixes the program exit behavior
discussed at the end of Chapter 3.

1.  Open the `cli/bin/cli.dart` file.

1.  Add the following import statement at the top of the file, alongside
    your other imports:

    ```dart
    import 'package:command_runner/command_runner.dart';
    ```

    This statement imports the `command_runner` package, making the `CommandRunner`
    class available for use.

1.  **Refactor the `main` function and remove old logic:**
    Currently, your `main` function from Chapter 3 directly handles commands
    like `version`, `help`, and `wikipedia`, and then calls `searchWikipedia`.
    You'll now replace all of this custom command-handling logic with a single
    call to the new `CommandRunner` class.

    **Your `cli/bin/cli.dart` file (from Chapter 3) should currently look like
    this:**

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http;
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'wikipedia') {
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs);
      } else {
        printUsage();
      }
    }

    void searchWikipedia(List<String>? arguments) async { /* ... existing logic ... */ }
    void printUsage() { /* ... existing logic ... */ }
    Future<String> getWikipediaArticle(String articleTitle) async { /* ... existing logic ... */ }
    ```

    **Now, replace the entire contents of `cli/bin/cli.dart` (except for the `http` import) with the following updated version:**

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http;
    import 'package:command_runner/command_runner.dart';

    void main(List<String> arguments) async { // main is now async and awaits the runner
      var runner = CommandRunner(); // Create an instance of your new CommandRunner
      await runner.run(arguments); // Call its run method, awaiting its Future<void>
    }
    ```

    Highlights from the preceding code:

    * `void main(List<String> arguments) async` directly addresses
      the program not exiting cleanly issue from Chapter 3.
      Notice that `main` is now declared `async`. This is essential because
      `runner.run()` returns a `Future`, and `main` must `await` its completion
      to ensure the program waits for all asynchronous tasks to finish before exiting. 
    * `var runner = CommandRunner();` creates an instance of the
      `CommandRunner` class from your new `command_runner` package.
    * `await runner.run(arguments);` calls the `run` method on the
      `CommandRunner` instance, passing in the command-line arguments.
    
    Removed Functions:

    The `printUsage`, `searchWikipedia`, and
    `getWikipediaArticle` functions are now completely removed from
    `cli/bin/cli.dart`. Their logic will be redesigned and moved into the
    `command_runner` package in future chapters, as part of building the full 
    command-line framework.

### Task 5: Run the application

Now that you've refactored the code and updated the `cli` application to use the
`command_runner` package, run the application to verify that everything
is working correctly at this stage.

1.  Open your terminal and navigate to the `cli` directory.

1.  Run the `wikipedia` command:

    ```bash
    dart run bin/cli.dart wikipedia Computer_programming
    ```

1.  Ensure that the application now executes without errors and print the arguments
    to the console, demonstrating that the control has successfully transferred
    to your new `command_runner` package.

    ```bash
    CommandRunner received arguments: [wikipedia, Computer_programming]
    ```

    :::important
    **Important note on functionality:**
    You'll notice that the article-fetching functionality (from Chapter 3) is no
    longer active. This is expected! In this chapter, you've refactored the
    project structure by moving the command-handling responsibility. The next
    chapters will focus on rebuilding and enhancing that core application logic
    within the `command_runner` package.
    :::

## Review

In this chapter, you learned about:

* Creating Dart packages using `dart create -t package`.
* Using `export` statements to make declarations from one library available in
  another.
* Adding local packages as dependencies using the `path` option in
  `pubspec.yaml`.
* Importing packages into your Dart code using `import` statements.
* Refactoring code to improve organization and maintainability, including making
  `main` `async` to correctly `await` asynchronous operations.

## Quiz

**Question 1:** What is the purpose of the `export` statement in a Dart library?

* A) To hide declarations from other libraries.
* B) To make declarations available to other libraries.
* C) To specify the version of the Dart SDK required by the library.
* D) To define the entry point of the library.

**Question 2:** How do you add a local package as a dependency in
`pubspec.yaml`?

* A) By specifying the package name and version.
* B) By specifying the package name and the path to the package.
* C) By using the `git` option and specifying the URL of the Git repository.
* D) By using the `hosted` option and specifying the URL of the package server.

## Next lesson

In the next chapter, you'll dive into object-oriented programming (OOP) concepts
in Dart. You'll learn how to create classes, define inheritance relationships,
and build a more robust command-line argument parsing framework using OOP
principles within your new `command_runner` package.
