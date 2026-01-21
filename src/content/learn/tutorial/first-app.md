---
title: Build your first app
shortTitle: Your first app
description: >-
  Create, run, and make your first change to a Dart command-line program.
sitemap: false
noindex: true
layout: learn
---

<YoutubeEmbed id="ulg4bjQQJi0" title="What is Dart?" fullWidth="true"></YoutubeEmbed>
Welcome to Dart! In this chapter, you'll
ensure your setup is complete and then
work through creating your first Dart program.
This chapter starts simple but moves fast!

<SummaryCard>
title: What you'll accomplish
items:
  - title: Verify your Dart SDK installation
    icon: check_circle
  - title: Create a CLI project with dart create
    icon: terminal
  - title: Run and modify your first program
    icon: play_arrow
</SummaryCard>

## Prerequisites

Before you begin this chapter, ensure you:

- [Installed the Dart SDK](/get-dart).
- Reviewed the [Dart overview](/overview) (if you're new to Dart).

## Tasks

Create the classic Hello World in Dart to get your project started.

### Task 1: Confirm your Dart setup

First, make sure Dart is ready to go on your system by following these steps.

1.  Open a terminal (or command prompt).

1.  Run the following command to check your Dart SDK version:

    ```bash
    dart --version
    ```

1.  Make sure that you see output similar to this
    (the version numbers might be different):

    ```bash
    Dart SDK version: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "linux_x64"
    ```

    If you see an error like "command not found," refer to the
    [Dart installation guide][] to set up your environment.

[Dart installation guide]: /get-dart

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
    Every Dart program starts executing from its `main` function.

1.  Check to make sure that your `bin/cli.dart` looks like this:

    ```dart title="bin/cli.dart"
    import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello world: ${cli.calculate()}!');
    }
    ```

1.  Simplify the output for now.
    Delete the first line (you don't need this import statement), and
    change the `print` statement to display a simple greeting:

    ```dart title="bin/cli.dart" highlightLines=1,4
    import 'package:cli/cli.dart' as cli; // Delete this entire line

    void main(List<String> arguments) {
      print('Hello, Dart!'); // Change this line
    }
    ```

1.  Save your file. Then in the terminal, run your program again:

    ```bash
    dart run
    ```

1.  Check to make sure that you see the following:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello, Dart!
    ```

    You've successfully modified and re-run your first Dart program!

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Verified your Dart SDK installation
    icon: check_circle
    details: >-
      You ran `dart --version` to confirm Dart is properly installed
      and accessible from your terminal.
  - title: Created your first CLI project
    icon: terminal
    details: >-
      You used `dart create` to generate a new command-line application.
      This command scaffolds a basic project with
      core files like `pubspec.yaml`.
      It also generates a `bin/cli.dart` file with a `main` function
      that acts as the entry point for your program.
  - title: Ran and modified your program
    icon: play_arrow
    details: >-
      You executed your app with `dart run` and saw the "Hello world" output.
      Then you modified the `main` function to print a custom greeting,
      experiencing Dart's edit-run cycle firsthand.
</SummaryCard>

## Quiz

Here's a quick quiz to solidify your learning.

:::note
You'll see these quizzes throughout this tutorial.
Feel free to skip them if you want.
:::

<Quiz title="Check your understanding" id="first-app" />

## Next lesson

In the next lesson, you'll learn how to
make your program respond to specific commands by
introducing command-line arguments and the `const` keyword.
