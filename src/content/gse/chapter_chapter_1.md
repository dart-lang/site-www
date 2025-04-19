---
title: "Chapter 1: Anatomy of a Dart program"
description: "Learn about `main` function, `pubspec.yaml`, `analysis_options.yaml`"
---

# Chapter 1: Anatomy of a Dart program
Learn about `main` function, `pubspec.yaml`, `analysis_options.yaml`

[Video Placeholder]

In this lesson, you'll get your first look at a Dart program. We'll cover the basic structure of a Dart project, including the `main` function (the entry point of your program) and the important configuration files: `pubspec.yaml` and `analysis_options.yaml`. By the end of this lesson, you'll be able to create, run, and understand the basic components of a Dart application.

## Background / Key Concepts
* **`main` Function:** Every Dart program needs a `main` function. This is where your program starts executing. Think of it as the "ignition switch" for your app.
* **`pubspec.yaml`:** This file is the heart of your Dart project. It defines the project's name, version, dependencies (other packages your project needs), and other important metadata. It's like the manifest for your app.
* **`analysis_options.yaml`:** This file configures the Dart analyzer, a tool that helps you find potential problems in your code, enforce coding style, and improve code quality. It's like having a code reviewer built into your development environment.
* **Packages:** In Dart, code is organized into packages. A package is a reusable unit of code that can be shared across multiple projects.

## Set up

No setup is required for this chapter. We'll start from scratch by creating a new Dart project.

## Tasks

In this lesson, we'll create a new Dart project, explore its structure, and run the default application.

### Create a new Dart project

1.  Open your terminal or command prompt.

2.  Navigate to the directory where you want to create your project.

3.  Run the following command:

    ```bash
    dart create wikipedia
    ```

    This command uses the `dart create` tool to generate a basic Dart project named "wikipedia". This command scaffolds a CLI (Command Line Interface) application. It sets up the basic directory structure and files you need to get started.

    You should see output similar to this:

    ```bash
    Creating project 'wikipedia'...
    Running pub get in wikipedia...
    Wrote wikipedia/analysis_options.yaml.
    Wrote wikipedia/bin/wikipedia.dart.
    Wrote wikipedia/lib/wikipedia.dart.
    Wrote wikipedia/test/wikipedia_test.dart.
    Wrote wikipedia/pubspec.yaml.
    Wrote wikipedia/README.md.

    All done!
    ```

4.  Navigate into the newly created `wikipedia` directory:

    ```bash
    cd wikipedia
    ```

### Explore the project structure

The `dart create` command has generated the following directory structure:

```dart
wikipedia/
├── analysis_options.yaml
├── bin
│   └── wikipedia.dart
├── lib
│   └── wikipedia.dart
├── pubspec.yaml
├── README.md
└── test
    └── wikipedia_test.dart
```

Let's break down each file and directory:

*   **`analysis_options.yaml`:** We already discussed this file. This is where you configure the Dart analyzer. Open it and you'll see it includes `package:lints/recommended.yaml`. This enables a set of recommended "lints" (rules) that help you write better code.
*   **`bin/`:** This directory contains the executable code for your application. In this case, `bin/wikipedia.dart` is the main entry point.
*   **`lib/`:** This directory contains the library code for your application. This is where you'll put reusable code that can be shared across different parts of your application, or even across multiple projects. `lib/wikipedia.dart` is where our `calculate` function lives.
*   **`pubspec.yaml`:** We also discussed this file. This declares metadata and dependancies for the project.
*   **`README.md`:** This file contains a description of your project. It's good practice to keep this file updated with information about your application.
*   **`test/`:** This directory contains the tests for your application. Writing tests is crucial for ensuring that your code works as expected.

### Examine the `pubspec.yaml` file

Open the `pubspec.yaml` file in your code editor. You should see something like this:

```yaml
name: wikipedia
description: A sample command-line application.
version: 1.0.0
# repository: https://github.com/my_org/my_repo

environment:
  sdk: ^3.7.0

# Add regular dependencies here.
dependencies:
  # path: ^1.8.0

dev_dependencies:
  lints: ^2.0.0
  test: ^1.16.0
```

*   **`name`:** The name of your project.
*   **`description`:** A short description of your project.
*   **`version`:** The version number of your project.
*   **`environment`:** Specifies the Dart SDK version that your project requires.
*   **`dependencies`:** Lists the packages that your project depends on. Notice the comment `# path: ^1.8.0`.  If your project required a dependancy on the `path` package, you would uncomment this line.
*   **`dev_dependencies`:** Lists the packages that are only needed during development, such as testing frameworks and linters.

### Run the default application

1.  From the root directory of your project (`wikipedia`), run the following command:

    ```bash
    dart run bin/wikipedia.dart
    ```

    This command tells Dart to execute the `bin/wikipedia.dart` file.

2.  You should see the following output:

    ```bash
    Hello world: 42!
    ```

    Congratulations! You've successfully run your first Dart program!

### Analyze the code

Let's take a closer look at the code that generated this output. Open `bin/wikipedia.dart` in your code editor. You should see something like this:

```dart
import 'package:wikipedia/wikipedia.dart' as wikipedia;

void main(List<String> arguments) {
  print('Hello world: ${wikipedia.calculate()}!');
}
```

*   **`import 'package:wikipedia/wikipedia.dart' as wikipedia;`:** This line imports the code from `lib/wikipedia.dart`. The `as wikipedia` part gives the imported code a namespace, so you can refer to it as `wikipedia`.
*   **`void main(List<String> arguments) { ... }`:** This is the `main` function. It's the entry point of your program. The `List<String> arguments` part allows you to pass command-line arguments to your program (we'll cover this later).
*   **`print('Hello world: ${wikipedia.calculate()}!');`:** This line prints the text "Hello world: " followed by the result of calling the `calculate()` function (defined in `lib/wikipedia.dart`), followed by an exclamation point. The `${}` syntax is used for string interpolation, which allows you to embed the result of an expression directly into a string.

Now, open `lib/wikipedia.dart`. You should see something like this:

```dart
int calculate() {
  return 6 * 7;
}
```

This code defines a simple function called `calculate()` that returns the product of 6 and 7 (which is 42).

[Pop out placeholder: Try changing the value returned by the `calculate()` function and rerun the program. Observe the change in the output.]

## Review

In this lesson, you learned about the basic structure of a Dart project, including the `main` function, the `pubspec.yaml` and `analysis_options.yaml` files, and how to run a Dart program. You also got a glimpse of how code is organized into libraries and how to import code from other libraries.

**Quiz Question:**

Which file defines the dependencies of a Dart project?

*   [Option A] `analysis_options.yaml`
*   [Option B] `pubspec.yaml`
*   [Option C] `README.md`
*   [Option D] `bin/wikipedia.dart`

## Next lesson

In the next lesson, we'll dive deeper into Dart syntax and start building a more interactive command-line application. You'll learn how to read user input, use control flow statements, work with collections, and more!