---
title: Your first Dart program
shortTitle: Your first app
description: >-
  Create, run, and make your first change to a Dart command-line program.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started
  title: Get started
nextpage:
  url: /get-started/add-commands
  title: Add interactivity to your app
---

{% render 'fwe-wip-warning.md', site: site %}

Welcome to Dart!
In this chapter, you'll ensure your setup is complete, and
then work through creating your first Dart program.
This chapter starts simple but moves fast!

:::secondary What you'll learn

* Confirm your Dart SDK installation.
* Use `dart create` to generate a new command-line interface (CLI) project.
* Run your Dart program from the terminal using `dart run`.
* Identify the `main` function as the program's entry point.
* Make your first code change and see the updated output.

:::

## Prerequisites

Before you begin this chapter, ensure you:

* [Installed the Dart SDK](/get-dart).
* Reviewed the [Dart overview](/overview) (if you're new to Dart).

## Tasks

Create the classic Hello World in Dart to get your project started.

### Task 1: Confirm your Dart setup

First, make sure Dart is ready to go on your system by following these steps.

1.  Open a terminal (or command prompt).

2.  Run the following command to check your Dart SDK version:

    ```bash
    dart --version
    ```

3.  Make sure that you see output similar to this
    (the version numbers might be different):

    ```bash
    Dart SDK version: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "linux_x64"
    ```

    If you see an error like "command not found," refer to the
    [Dart installation guide](/get-dart) to set up your environment.

### Task 2: Create a new Dart project

Now, create your first Dart command-line application.

1.  In the same terminal,
    create a new directory called `dartpedia` to hold your project.
    Then switch into that directory.

    ```bash
    mkdir dartpedia
    cd dartpedia
    ```

1.  Run the following command:

    ```bash
    dart create cli
    ```

    The `dart create` command generates a basic Dart project named
    "cli" (for Command Line Interface).
    It sets up the essential files and directories you need.

1.  You should see output similar to this, confirming the project creation:

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

    Created project cli in cli! In order to get started, run the following commands:

      cd cli
      dart run
    ```

    :::note
    The `dart create` command created a number of files.
    Don't worry about these now.
    Their specifics will be covered in future chapters.
    :::

### Task 3: Run your first Dart program

Next, run your program to test it out.

1.  In the terminal, navigate into your new project directory:

    ```bash
    cd cli
    ```

1.  Run the default application:

    ```bash
    dart run
    ```

    This command tells Dart to execute your program.

1.  You should see the following output:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello world: 42!
    ```

    Congratulations! You've successfully run your first Dart program!

### Task 4: Make your first code change

Next, modify the code that generated `Hello world: 42!`.

1.  In a code editor, open the `bin/cli.dart` file.

    The `bin/` directory is where your executable code lives.
    `cli.dart` is the entry point of your application.

    Inside, you'll see the `main` function.
    Every Dart program [starts executing from its `main` function](/language#hello-world).

1.  Check to make sure that your `bin/cli.dart` looks like this:

    ```dart title="bin/cli.dart"
    import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello world: ${cli.calculate()}!');
    }
    ```

1.  Simplify the output for now.
    Delete the first line (you don't need this import statement), and change the
    `print` statement to display a simple greeting: 

    ```dart title="bin/cli.dart" highlightLines=1,4
    import 'package:cli/cli.dart' as cli; // Delete this entire line

    void main(List<String> arguments) {
      print('Hello, Dart!'); // Change this line
    }
    ```

2.  Save your file. Then in the terminal, run your program again:

    ```bash
    dart run
    ```

3.  Check to make sure that you see the following:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello, Dart!
    ```

    You've successfully modified and re-run your first Dart program!

## Review

In this lesson, you:

* Verified your Dart SDK installation.
* Used `dart create` to generate a new CLI project.
* Ran your Dart program from the terminal using `dart run`.
* Identified the `main` function as the
  program's entry point within `bin/cli.dart`.
* Made your first code change and saw the updated output.

## Quiz

Here's a quick quiz to solidify your learning.

:::note
You'll see these quizzes throughout this tutorial.
Feel free to skip them if you want.
:::

<Quiz title="Check your understanding">
- question: >-
    Which command generates a new Dart project
    with the necessary files and directory structure?
  options:
    - text: >-
        `dart create`
      correct: true
      explanation: >-
        `dart create` creates and scaffolds a new project.
        You can also use `-t` to specify a template,
        like `dart create -t console project_name`.
    - text: >-
        `dart new`
      correct: false
      explanation: >-
        There is no `dart new` command in Dart.
        Think about what action you want to perform
        when starting a fresh project.
    - text: >-
        `dart init`
      correct: false
      explanation: >-
        While some other tools use `init` for this purpose,
        Dart uses a different command.
        Review the lesson to see which command was used.
    - text: >-
        `dart build`
      correct: false
      explanation: >-
        `dart build` is used to build existing Dart applications for deployment,
        not for scaffolding new projects.
- question: >-
    Every Dart program starts executing from a specific function.
    What is this function called and why is it important?
  options:
    - text: >-
        The `main` function.
        It's the entry point where program execution begins.
      correct: true
      explanation: >-
        The `main` function is required in executable Dart programs.
        Without it, Dart wouldn't know where to begin running your code.
    - text: >-
        The `start` function.
        It initializes the runtime environment.
      correct: false
      explanation: >-
        Dart doesn't have a `start` function.
        The Dart runtime is automatically initialized before your code runs.
    - text: >-
        The `run` function.
        It's called by the `dart run` command.
      correct: false
      explanation: >-
        There's no required `run` function.
        The `dart run` command looks for and
        executes the standard entrypoint function.
    - text: >-
        The `init` function.
        It sets up variables before the program starts.
      correct: false
      explanation: >-
        Dart doesn't require an `init` function.
        Variables can be defined and intialized in any function.
- question: >-
    In a Dart CLI project,
    where should you place the file containing your `main` function?
  options:
    - text: >-
        In the `bin/` directory,
        because that's the standard location for Dart CLI entry points.
      correct: true
      explanation: >-
        The `bin/` directory contains a program's Dart entry points.
        When you run `dart run`, Dart looks here for your package's entry point.
    - text: >-
        In the `lib/` directory, because that's where all Dart code belongs.
      correct: false
      explanation: >-
        The `lib/` directory is for library code
        that can be imported by other packages.
    - text: >-
        In the `src/` directory, because that's the standard source folder.
      correct: false
      explanation: >-
        Dart projects typically use `lib/src/` for implementation details,
        not for executable entry points.
    - text: >-
        In the project root, next to `pubspec.yaml`.
      correct: false
      explanation: >-
        While technically possible,
        Dart projects have a conventional directory for executables.
        Check where `dart create` placed the entry point file.
</Quiz>

## Next lesson

In the next lesson, you'll learn how to
make your program respond to specific commands by
introducing command-line arguments and the `const` keyword.
