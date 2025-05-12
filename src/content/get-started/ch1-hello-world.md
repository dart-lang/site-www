---
title: Your First Dart Program
description: Create, run, and make your first change to a Dart command-line program.
---

Welcome to Dart. This chapter starts simple, but moves fast. First, it ensures
your setup is complete, and then guides you through creating your first Dart
program.

Setup: Make sure you have installed Dart and reviwed the overview page.

## Task 1: Confirm Your Dart Setup

First, make sure Dart is ready to go on your system by following these steps.

Open your terminal (or command prompt).

Run the following command to check your Dart SDK version:

```bash
dart --version
```

You should see output similar to this (the version numbers might be different):

```bash
Dart SDK version: 3.7.2 (stable) (Tue Mar 11 04:27:50 2025 -0700) on "linux_x64"
```

If you see an error like "command not found," refer to the Dart
installation guide to set up your environment.

## Task 2: Create a New Dart Project

Now, create your first Dart command-line application.

In your terminal, create a new directory called "wikipedia" to hold your
project. Then switch into that directory.

```bash
mkdir wikipedia
cd wikipedia
```

Run the following command:

```bash
dart create cli
```

This command uses the `dart create` command to generate a basic Dart project
named "cli" (for Command Line Interface). It sets up the essential files and
directories you need.

You should see output similar to this, confirming the project creation:

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

Notice the last two lines suggesting how to get started: `cd cli` and `dart run`.

That's your next step!

:::note
The `dart create` command created a number of files. Don't worry about these
now. Their specifics will be covered in future chapters.
:::

## Task 3: Run Your First Dart Program

Navigate into your new project directory:

```bash
cd cli
```

Run the default application:

```bash
dart run
```

This command tells Dart to execute your program.

You should see the following output:

```bash
Building package executable... 
Built cli:cli.
Hello world: 42!
```

Congratulations! You've successfully run your first Dart program!

## Task 4: Make Your First Code Change

Next, modify the code that generated `Hello world: 42!`.

Open the `bin/cli.dart` file in your editor.

The `bin/` directory is where your executable code lives. `cli.dart` is the
entry point of your application.

Inside, you'll see the `main` function. Every Dart program starts executing from
its `main` function.

Your `bin/cli.dart` should look like this:

```dart
import 'package:cli/cli.dart' as cli;

void main(List<String> arguments) {
  print('Hello world: ${cli.calculate()}!');
}
```

Simplify the output for now. Comment out the first line (you don't need
this import statement), and change the `print` statement to display a simple
greeting:

```dart
// import 'package:cli/cli.dart' as cli;

void main(List<String> arguments) {
  print('Hello, Dart!'); // Change this line
}
```

:::note
For now, comment out the `import 'package:cli/cli.dart'` line to avoid
an unused import warning. You will learn about this and fully remove the line
later.
:::

Run your program again:

```bash
dart run
```

You should now see:

```bash
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

## Quiz:

Here's a quick quiz to solidify your learning.

:::note
You'll see these quizzes throughout this tutorial. Feel free to skip them if you
want.
:::

Which command is used to create a new Dart project from a template?

* [Option A] `dart new`
* [Option B] `dart build`
* [Option C] `dart create`
* [Option D] `dart init`

## Next Lesson

In the next lesson, you'll learn how to make your program respond to specific
commands by introducing command-line arguments and the `const` keyword.