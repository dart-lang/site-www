---
title: Your first Dart program
description: Create, run, and make your first change to a Dart command-line program.
---

Welcome to Dart. In this chapter, you'll ensure your setup is complete, and then
work through creating your first Dart program. This chapter starts simple, but
moves fast!

:::secondary What you'll learn

* Confirm your Dart SDK installation.
* Use `dart create` to generate a new command-line interface (CLI) project.
* Run your Dart program from the terminal using `dart run`.
* Identify the `main` function as the program's entry point.
* Make your first code change and see the updated output.

:::

## Prerequisites

Before you begin this chapter, ensure you have:

* [Installed the Dart SDK](https://dart.dev/tools/sdk).
* Reviewed the [Dart overview page](https://dart.dev/overview) (if you're new
  to Dart).

## Task 1: Confirm your Dart setup

First, make sure Dart is ready to go on your system by following these steps.

1.  Open a terminal (or command prompt).

2.  Run the following command to check your Dart SDK version:

    ```bash
    dart --version
    ```

3.  Make sure that you see output similar to this (the version numbers might be
    different):

    ```bash
    Dart SDK version: 3.8.0 (stable) (None) on "linux_x64"
    ```

    If you see an error like "command not found," refer to the Dart
    installation guide to set up your environment.

## Task 2: Create a new Dart project

Now, create your first Dart command-line application.

1.  In the same terminal, create a new directory called "dartpedia" to hold your
    project. Then switch into that directory.

    ```bash
    mkdir dartpedia
    cd dartpedia
    ```

2.  Run the following command:

    ```bash
    dart create cli
    ```

    The `dart create` command generates a basic Dart project named "cli" (for
    Command Line Interface). It sets up the essential files and directories you
    need.

3.  You should see output similar to this, confirming the project creation:

    ```bash
    Creating cli using template console...

      .gitignore
      analysis_options.yaml
      CHANGELOG.md
      pubspec.yaml
      README.md
      bin/cli.dart
      lib/cli.dart
      test/cli_test.dart

    Running pub get...                     1.2s
      Resolving dependencies...
      Downloading packages...
      Changed 49 dependencies!
      1 package has newer versions incompatible with dependency constraints.
      Try `dart pub outdated` for more information.

    Created project cli in cli! In order to get started, run the following commands:

      cd cli
      dart run
    ```

    :::note
    The `dart create` command created a number of files. Don't worry about these
    now. Their specifics will be covered in future chapters.
    :::

## Task 3: Run your first Dart program

Next, run your program to test it out.

1.  In the terminal, navigate into your new project directory:

    ```bash
    cd cli
    ```

2.  Run the default application:

    ```bash
    dart run
    ```

    This command tells Dart to execute your program.

3.  You should see the following output:

    ```bash
    Building package executable... 
    Built cli:cli.
    Hello world: 42!
    ```

    Congratulations! You've successfully run your first Dart program!

## Task 4: Make your first code change

Next, modify the code that generated `Hello world: 42!`.

1.  In a code editor, open the `bin/cli.dart` file.

    The `bin/` directory is where your executable code lives. `cli.dart` is the
    entry point of your application.

    Inside, you'll see the `main` function. Every Dart program starts executing from
    its `main` function.

2.  Check to make sure that your `bin/cli.dart` looks like this:

    ```dart
    import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello world: ${cli.calculate()}!');
    }
    ```

3.  Simplify the output for now. Comment out the first line (you don't need
    this import statement), and change the `print` statement to display a simple
    greeting:

    ```dart
    // import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello, Dart!'); // Change this line
    }
    ```

    :::note
    You commented out the `import 'package:cli/cli.dart'` line to avoid an
    unused import warning. You will learn about this soon and then fully remove
    the line later.
    :::

4.  In the terminal, save your file and run your program again:

    ```bash
    dart run
    ```

5.  Check to make sure that you see the following:

    ```bash
    Building package executable... 
    Built cli:cli.
    Hello, Dart!
    ```

    You've successfully modified and re-run your first Dart program!

## Review

In this lesson, you:

* Confirmed your Dart SDK installation.
* Used `dart create` to generate a new CLI project.
* Ran your Dart program from the terminal using `dart run`.
* Identified the `main` function as the program's entry point within
    `bin/cli.dart`.
* Made your first code change and saw the updated output.

## Quiz

Here's a quick quiz to solidify your learning.

:::note
You'll see these quizzes throughout this tutorial. Feel free to skip them if you
want.
:::

Which command is used to create a new Dart project from a template?

* A) `dart new`
* B) `dart build`
* C) `dart create`
* D) `dart init`

## Next lesson

In the next lesson, you'll learn how to make your program respond to specific
commands by introducing command-line arguments and the `const` keyword.