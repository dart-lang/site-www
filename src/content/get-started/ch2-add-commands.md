---
title: Making Your CLI Program Interactive
description: Add simple commands to your cli program. Learn the fundamentals of Dart syntax including control flow, collections, variables, functions, and more.
---

In this chapter, you'll get hands-on with Dart syntax. You'll cover control
flow, collections, variables, functions, and more. You'll learn how to read user
input, print usage information, and create a basic command-line interaction. By
the end, you'll have a foundational understanding of Dart syntax.

## Prerequisites

* Completed Chapter 1 and have a working Dart development environment.
* Familiarity with basic programming concepts (variables, data types, control
  low).

## Tasks

Start building your Wikipedia command-line application by adding some basic
functionality and exploring Dart syntax.

### Task 1: Implement `Version` and `Help` Commands

1.  **Implement the version command in `cli/bin/cli.dart`:** Add logic to handle
    a `version` command. Use an `if` statement to check if the first argument
    provided is `version`. You'll also need a `version` constant.
    
    First, above your main function, declare a `const` variable for the version:

    ```dart
    const version = '0.0.1'; // Add this line
    ```

    Next, modify your main function to check for the `version` argument:

    ```dart
    // ... (keep the const version = '0.0.1'; line above)

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else {
        print('Hello, Dart!'); // Keep this for now, we'll refine it.
      }
    }
    ```

1.  **Test the `version` command:** Run your application with the version
    argument:

    ```bash
    dart bin/cli.dart version
    ```

    You should now see:

    ```bash
    Dart Wikipedia version 0.0.1
    ```

    If you run your app without arguments, you'll still see "Hello, Dart!".

2.  **Add a `printUsage` function:** To make the output more user-friendly,
    create a separate function to display usage information. Place this function
    outside and below your main function.

    ```dart
    // ... (keep the main function above)

    void printUsage() { // Add this new function
      print(
        "The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'",
      );
    }
    ```

3.  **Implement the `help` command and refine `main`:** Now, integrate the
    `help` command using an `else if` statement, and clean up the default
    behavior to call `printUsage`.

    Modify your main function to look like this:

    ```dart
    // ... (keep const version = '0.0.1'; above)

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') { // Add this else if
        printUsage();
      } else {
        printUsage(); // Change this from 'Hello, Dart!'
      }
    }

    // ... (keep printUsage() below)
    ```

4.  **Understand the `if/else` structure:** You've now built an `if`, `else if`,
    and `else` structure for conditional execution.

    * `arguments.isNotEmpty` checks if any command-line arguments were
      provided.
    * `arguments.first` accesses the very first argument, which we're using as
      our command.

5.  **Variables and Constants:**
    * Notice the `version` variable is declared as a `const`. This means its
      value is known at compile time and you cannot change it during runtime.
    * `arguments`, on the other hand, is a regular (non-constant) variable
      because its content can change based on user input.

    Test the help command: Run your application with the help argument:

    ```bash
    dart bin/cli.dart help
    ```

    You should see the usage information printed.

    Also, try running it without any arguments:

    ```bash
    dart bin/cli.dart
    ```

    It should now also display the usage information.

### Task 2: Implement the `wikipedia` command

Next, implement a basic `wikipedia` command that takes an article title as
input. As you build this functionality, you'll work with `List` manipulation,
null checks, and string interpolation.

1.  **Integrate the `wikipedia` command into `main`:** First, modify your main
    function in `cli/bin/cli.dart` to include an `else if` branch that handles
    the `wikipedia` command. For now, we'll just print a placeholder message.

    ```dart
    // ... (your existing const version and printUsage() functions)

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'wikipedia') {
        // Add this new block:
        print('Wikipedia command recognized!');
      } else {
        printUsage();
      }
    }

    // ... (your existing printUsage() function)
    ```

1.  **Test the new command:** Run your application with the ``wikipedia``
    command:

    ```bash
    dart bin/cli.dart wikipedia
    ```

    You should see:

    ```bash
    Wikipedia command recognized!
    ```

1.  **Define the runApp function:** Your `wikipedia` command will eventually run
    the core logic of our application. Next create a new function called `runApp`
    that will house this logic. Initially, `runApp` will just take a list of
    arguments and print them. Place this new function below `main`.

    ```dart
    // ... (your existing main function)

    void runApp(List<String> arguments) { // Add this new function
      print('runApp received arguments: $arguments');
    }

    // ... (your existing printUsage() function)
    ```

1.  **Call `runApp` from main:** Now, modify the `wikipedia` command block in
    `main` to call `runApp` and pass it any arguments that come after the
    `wikipedia` command itself. We use `arguments.sublist(1)` to get all
    arguments starting from the second one.

    ```dart
    // ... (your existing const version and printUsage() functions)

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'wikipedia') {
        // Modify this block:
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : []; // Use empty list for no args
        runApp(inputArgs);
      } else {
        printUsage();
      }
    }

    // ... (your existing runApp and printUsage() functions)
    ```

    * **List Manipulation:** `arguments.sublist(1)` creates a new list containing
      all elements of the `arguments` list after the first element (which was
      `wikipedia`). We use a conditional (`? :`) to ensure `inputArgs` is an
      empty list if no further arguments are provided.

2.  **Test runApp with arguments:** Run the application with a test article
    title:

    ```bash
    dart bin/cli.dart wikipedia Dart Programming
    ```

    You should see:

    ```bash
    runApp received arguments: [Dart, Programming]
    ```

    Run without extra arguments:

    ```bash
    dart bin/cli.dart wikipedia
    ```

    You should see:

    ```bash
    runApp received arguments: []
    ```

3.  **Handle missing article title and user input:** It's more user-friendly to
    prompt the user if they don't provide an article title on the command line.
    We'll use `stdin.readLineSync()` for this.

    Update your `runApp` function. Notice that `stdin.readLineSync()` can return
    `null`, so we declare `articleTitle` as `late String?`. You'll need to
    import `dart:io` at the top of your `cli.dart` file.

    ```dart
    // Add this line at the top of cli/bin/cli.dart:
    import 'dart:io';

    // ... (your existing main function and const version)

    void runApp(List<String>? arguments) { // Add ? to arguments type
      late String? articleTitle; // Declare articleTitle with late and ?

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Read input from user
        if (articleTitle == null || articleTitle.isEmpty) { // Add basic check for empty input
          print('No article title provided. Exiting.');
          return; // Exit if no input
        }
      } else {
        articleTitle = arguments.join(', '); // Join command-line arguments
      }

      // We'll add more print statements here later
      print('Looking up articles about $articleTitle. Please wait.');
    }

    // ... (your existing printUsage() function)
    ```

    *   **Null Safety:** `List<String>? arguments` means that the `arguments`
    list itself can be `null` or contain strings. The
    `if (arguments == null ||arguments.isEmpty)` explicitly checks for both
    conditions.
    *   `stdin.readLineSync()`: This function reads a line of text typed by the
    user into the console.
    *   `late String? articleTitle`: We use `late` because we promise that
    `articleTitle` will definitely have a value before it's used. The `?`
    signifies that its value could be `null` (for instance, if
    `stdin.readLineSync()` returns `null`).

4.  **Test with and without command-line arguments:**

    Run without arguments:

    ```bash
    dart bin/cli.dart wikipedia
    ```

    The program will prompt you. Type `My Article Title` and press Enter.

    You should see:

    ```bash
    Please provide an article title.
    My Article Title
    Looking up articles about My Article Title. Please wait.
    ```

    Run with arguments:

    ```bash
    dart bin/cli.dart wikipedia Another Article
    ```

    You should see:

    ```bash
    Looking up articles about Another, Article. Please wait.
    ```

5.  **Simulate article lookup with `for-in` loop:** To complete the `wikipedia`
    command's current basic functionality, let's add a loop that pretends to find
    articles for each argument provided. We'll use the `arguments` list (which
    came from the command line) for this simulation.

    Modify your `runApp` function:

    ```dart
    // ... (beginning of runApp function)

    void runApp(List<String>? arguments) {
      late String? articleTitle;
      List<String> lookupArgs = []; // Create a new list for arguments to look up

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();
        if (articleTitle == null || articleTitle.isEmpty) {
          print('No article title provided. Exiting.');
          return;
        }
        lookupArgs = [articleTitle]; // If input from stdin, make it the single lookup argument
      } else {
        articleTitle = arguments.join(', ');
        lookupArgs = arguments; // If input from command line, use those
      }

      print('Looking up articles about $articleTitle. Please wait.');
      // Add or modify this for loop:
      for (var arg in lookupArgs) { // Loop over lookupArgs
        print('Here ya go!');
        print('(Pretend this is an article about $arg)');
      }
    }
    ```

    * `for-in loop`: The `for (var arg in lookupArgs)` loop iterates through
      each element in the `lookupArgs` list. This is a concise way to loop over
      collections in Dart.
    * **Updated Logic for `lookupArgs`:** We now create a `lookupArgs` list. If
      the input came from `stdin`, this list will contain just the single
      `articleTitle`. If it came from the command line, it will contain the
      `arguments` themselves.
    * **String Interpolation:** The
      `print('(Pretend this is an article about $arg)');` line uses string
      interpolation. The `$` sign allows you to embed variables directly into a
      string, making it easy to create dynamic output.

1.  **Final Test Run with both scenarios:**

    Run with arguments:

    ```bash
    dart bin/cli.dart wikipedia Dart Programming
    ```

    You should see:

    ```bash
    Looking up articles about Dart, Programming. Please wait.
    Here ya go!
    (Pretend this is an article about Dart)
    Here ya go!
    (Pretend this is an article about Programming)
    ```

    Run without arguments (type "Flutter" when prompted):

    ```bash
    dart bin/cli.dart wikipedia


    Please provide an article title.
    Flutter
    Looking up articles about Flutter. Please wait.
    Here ya go!
    (Pretend this is an article about Flutter)
    ```

    You have now successfully built the basic `wikipedia` command with user input
    handling.

### Task 3: Handle Null Input from `stdin`

In the previous step, you added a basic check for
`articleTitle == null || articleTitle.isEmpty` after reading from `stdin`. Let's
refine this to specifically handle the scenario where a user presses Enter
without typing anything at the prompt, which `stdin.readLineSync()` returns as
`null`.

1.  **Refine the `stdin` null check:** Open your `cli/bin/cli.dart` file and
    locate the `runApp` function. Modify the if condition that checks the
    `articleTitle` immediately after `stdin.readLineSync()`.

    ```dart
    import 'dart:io';

    // ... (your existing main and printUsage functions)

    void runApp(List<String>? arguments) {
      late String? articleTitle;
      List<String> lookupArgs = [];

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();

        // Modify this null check:
        if (articleTitle == null) { // This now specifically checks for null
          print('No article title provided. Exiting.');
          return; // Exit if no input
        }
        // If it's not null, but still empty (user just pressed Enter),
        // we can decide how to handle that. For now, let's allow it
        // but note the previous check for empty string still catches it later.
        lookupArgs = [articleTitle];
      } else {
        articleTitle = arguments.join(', ');
        lookupArgs = arguments;
      }

      print('Looking up articles about $articleTitle. Please wait.');
      for (var arg in lookupArgs) {
        print('Here ya go!');
        print('(Pretend this is an article about $arg)');
      }
    }
    ```

    The additional `if (articleTitle == null)` check now precisely handles the
    case where the user simply presses Enter at the `stdin.readLineSync()`
    prompt, which causes it to return a `null` value. This provides a clear
    message to the user for this specific scenario.

1.  **Test by providing no input:** Run your application without arguments and
    press Enter immediately when prompted:

    ```bash
    dart bin/cli.dart wikipedia
    ```

    The program will prompt you:

    ```bash
    Please provide an article title.
    ```

    Now, just press Enter without typing anything.

    You should see:

    ```bash
    No article title provided. Exiting.
    ```

    This confirms that your application now correctly handles the null input
    from `stdin.readLineSync()`, providing a robust user experience

## Review

In this chapter, you learned:

*   **Control flow:** Using `if/else` statements to control the execution flow
    of your program.
*   **Variables and Constants:** Declaring variables with `var` and `const`.
*   **Lists:**  Creating and manipulating lists using `.isNotEmpty`, `.first`,
    and `sublist`.
*   **Loops:** Iterating over collections using `for-in` loops.
*   **Null Safety:** Understanding nullability and using null checks (`?`).
*   **Functions:** Defining and calling functions.
*   **String interpolation:** Embedding variables in strings using `$`.
*   **Input/Output:** Reading user input from the console using `stdin`.

## Quiz

**Question 1:** Which keyword is used to declare a constant variable in Dart?
*   A) `var`
*   B) `final`
*   C) `const`
*   D) `static`

**Question 2:** How do you check if a list is empty in Dart?
*   A) `list.length == 0`
*   B) `list.isEmpty`
*   C) `list.size() == 0`
*   D) `list.empty()`

**Question 3:** How do you embed a variable named `name` into a string in Dart?
*   A) `"Hello, " + name + "!"`
*   B) `"Hello, ${name}!"`
*   C) `"Hello, $name!"`
*   D) Both B and C

## Next lesson

In the next chapter, you'll dive into asynchronous programming and learn how to
fetch data from the Wikipedia API using the `http` package. This will allow your
application to retrieve real data and display it to the user.