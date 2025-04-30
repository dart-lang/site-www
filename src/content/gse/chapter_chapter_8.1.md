---
title: "Chapter 8.1: Setup for part 3"
description: "Learn about setting up a new Dart package for interacting with the Wikipedia API."
---

# Chapter 8.1: Setup for part 3

Learn about setting up a new Dart package for interacting with the Wikipedia API.

[Video Placeholder]

In this lesson, we'll take a break from enhancing our `command_runner` package and shift our focus to setting up the `wikipedia` package, which will contain the core logic for interacting with the Wikipedia API.  We will need this package set up to fully realize the `command_runner` framework. We'll revisit the familiar `dart create` command to generate a new package and integrate it into our existing workspace. By the end of this lesson, you'll have a dedicated `wikipedia` package ready for implementing the data models and API calls needed to build our Wikipedia CLI application.

## Background / Key Concepts
*   **Package Focus:** Creating a dedicated package allows us to cleanly separate the Wikipedia API interaction logic from the more generic command-line handling code in the `command_runner` package.
*   **Workspace Integration:**  Ensuring that the new package is properly integrated into our workspace so that it can be easily accessed and used by other parts of our application.

## Set up
Make sure you have completed Chapter 8, which finalized the `command_runner` package.

## Tasks
In this lesson, we'll create a new `wikipedia` package and integrate it into our existing workspace.

### Create the `wikipedia` Package
1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (the directory containing the `cli` and `command_runner` directories).

3.  Run the following command:

    ```bash
    dart create wikipedia
    ```

    This command uses the `dart create` tool to generate a basic Dart package named "wikipedia". 

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

### Update the workspace `pubspec.yaml`

1.  Open the `pubspec.yaml` file in the root of your workspace.
2.  Add the `wikipedia` directory to the workspace.

    ```yaml
    workspace:
      - cli
      - command_runner
      #  [Step 9 update]
      - wikipedia
    ```

    This tells dart that the directory should be part of the workspace. This setting allows each individual package (`cli`, `command_runner`, and `wikipedia`) to depend on one another using relative paths, which is useful for local development.

### Run `dart pub get`

1.  Run `dart pub get` in the root of your workspace.

    This command tells Dart to fetch the dependancies of every project declared in the `workspace:` field of the root `pubspec.yaml` file.

[Pop out placeholder: Create a new file `wikipedia/bin/wikipedia.dart`. Add the following text: `void main() => print('hello from wikipedia');`. Run the file using `dart run wikipedia/bin/wikipedia.dart`.]

## Review
In this lesson, you learned how to:

*   Create a new Dart package using the `dart create` tool.
*   Add a new project to the workspace using the `pubspec.yaml` file.

**Quiz Question:**

Why is it important to define a workspace in the root `pubspec.yaml` file?
*   [Option A] To define the dependencies of a Dart project.
*   [Option B] To configure the Dart analyzer.
*   [Option C] To group related packages for local development and dependency management.
*   [Option D] To specify the Dart SDK version that your project requires.

## Next lesson

In the next lesson, we'll start defining the data models for the Wikipedia API responses in the `wikipedia` package. We'll learn how to use `dart:convert` and pattern matching to deserialize JSON data into Dart objects.