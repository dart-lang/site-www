---
title: Making your CLI program interactive
description: Add simple commands to your cli program. Learn the fundamentals of Dart syntax including control flow, collections, variables, functions, and more.
---

In this chapter, you'll get hands-on practice with Dart syntax. You'll learn how
to read user input, print usage information, and create a basic command-line
interaction. By the end, you'll have a foundational understanding of Dart
syntax.

:::secondary What you'll learn

* Implement basic control flow with `if/else`.
* Work with collections, specifically `List`s, and perform common operations
  like checking if a list is empty.
* Declare and use variables with `const` and `late String?`.
* Handle nullability with null checks.
* Define and call functions.
* Use string interpolation for dynamic text.
* Read user input from the command line using `stdin`.

:::

## Prerequisites

Before you begin this chapter, ensure you have:

* Completed Chapter 1 and have a working Dart development environment.
* Familiarity with basic programming concepts (variables, data types, control
  flow).

## Tasks

Start building your **Dartpedia** command-line application by adding some basic
functionality and exploring Dart syntax.

### Task 1: Implement version and help commands

1.  **Implement the `version` command in `cli/bin/cli.dart`:** Add logic to
    handle a `version` command. Use an `if` statement to check if the first
    argument provided is `version`. You'll also need a `version` constant.

    First, above your `main` function, declare a `const` variable for the
    version:

    ```dart
    const version = '0.0.1'; // Add this line
    ```

    Next, modify your `main` function to check for the `version` argument:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else {
        print('Hello, Dart!'); // Keep this for now, we'll refine it.
      }
    }
    ```

2.  **Test the `version` command:** Run your application with the version
    argument:

    ```bash
    dart bin/cli.dart version
    ```

    You should now see:

    ```bash
    Dartpedia CLI version 0.0.1
    ```

    If you run your app without arguments, you'll still see "Hello, Dart!".

3.  **Add a `printUsage` function:** To make the output more user-friendly,
    create a separate function to display usage information. Place this function
    outside and below your `main` function.

    ```dart
    void printUsage() { // Add this new function
      print(
        "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'" // Changed to 'search'
      );
    }
    ```

4.  **Implement the `help` command and refine `main`:** Now, integrate the
    `help` command using an `else if` statement, and clean up the default
    behavior to call `printUsage`.

    Modify your `main` function to look like this:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else {
        printUsage(); // Change this from 'Hello, Dart!'
      }
    }
    ```

5.  **Understand the `if/else` structure and variables:** You've now built an
    `if`, `else if`, and `else` structure for conditional execution.

    * `arguments.isNotEmpty` checks if any command-line arguments were
        provided.
    * `arguments.first` accesses the very first argument, which we're using as
        our command.
    * Notice the `version` variable is declared as a `const`. This means its
        value is known at compile time and you cannot change it during runtime.
    * `arguments`, on the other hand, is a regular (non-constant) variable
        because its content can change based on user input.

    Test the `help` command: Run your application with the help argument:

    ```bash
    dart bin/cli.dart help
    ```

    You should see the usage information printed.

    Also, try running it without any arguments:

    ```bash
    dart bin/cli.dart
    ```

    It should now also display the usage information.

    :::note
    Any command-line argument that is not `version` or `help` will currently
    also print the usage information. This is expected behavior for now.
    :::

### Task 2: Implement the search command

Next, implement a basic `search` command that takes an article title as
input. As you build this functionality, you'll work with `List` manipulation,
null checks, and string interpolation.

1.  **Integrate the `search` command into `main`:** First, modify your `main`
    function in `cli/bin/cli.dart` to include an `else if` branch that handles
    the `search` command. For now, we'll just print a placeholder message.

    ```dart
    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'search') {
        // Add this new block:
        print('Search command recognized!');
      } else {
        printUsage();
      }
    }
    ```

2.  **Test the new command:** Run your application with the `search`
    command:

    ```bash
    dart bin/cli.dart search
    ```

    You should see:

    ```bash
    Search command recognized!
    ```

3.  **Define the `runApp` function:** Your `search` command will eventually run
    the core logic of our application. Next, create a new function called
    `runApp` that will house this logic. Initially, `runApp` will just take a
    list of arguments and print them. Place this new function below `main`.

    ```dart
    // ... (your existing main function)

    void runApp(List<String>? arguments) { // Add this new function and add ? to arguments type
      print('runApp received arguments: $arguments');
    }

    // ... (your existing printUsage() function)
    ```

    * The `List<String>? arguments` type signature means that the `arguments`
        list itself can be `null`. This is important for null safety in Dart.

4.  **Call `runApp` from `main`:** Now, modify the `search` command block in
    `main` to call `runApp` and pass it any arguments that come after the
    `search` command itself. We use `arguments.sublist(1)` to get all
    arguments starting from the second one. If no arguments are provided after
    `search`, we'll pass `null` to `runApp`.

    ```dart
    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'search') { // Changed to 'search'
        // Modify this block:
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        runApp(inputArgs);
      } else {
        printUsage();
      }
    }
    ```

    * **List manipulation:** `arguments.sublist(1)` creates a new list
        containing all elements of the `arguments` list *after* the first
        element (which was `search`).
    * **Conditional assignment to `null`:** The `arguments.length > 1 ? ... : null;`
        is a conditional (ternary) operator. It ensures that if no arguments
        are provided after `search`, `inputArgs` becomes `null`, matching the
        sample code's behavior for `runApp`'s `arguments` parameter.

5.  **Test `runApp` with arguments:** Run the application with a test article
    title:

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    You should see:

    ```bash
    runApp received arguments: [Dart, Programming]
    ```

    Run without extra arguments:

    ```bash
    dart bin/cli.dart search
    ```

    You should see:

    ```bash
    runApp received arguments: null
    ```

6.  **Handle missing article title and user input with `stdin`:** It's more
    user-friendly to prompt the user if they don't provide an article title on
    the command line. We'll use `stdin.readLineSync()` for this.

    First, add the necessary import at the top of your `cli/bin/cli.dart` file:

    ```dart
    import 'dart:io'; // Add this line at the top
    ```

    Now, update your `runApp` function. This next code block introduces a few
    key concepts:
    * It declares a `late String? articleTitle` variable which will hold the
        full search query, whether it comes from the command line or user input.
    * An `if/else` statement then checks if command-line arguments for the
        search were provided.
    * If arguments are missing, it prompts the user, reads input using
        `stdin.readLineSync()`, and performs null and empty checks.
    * If arguments *are* present, it uses `arguments.join(' ')` to combine
        them into a single search string.

    ```dart
    void runApp(List<String>? arguments) {
      late String? articleTitle; // Declare articleTitle as late nullable

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Read input from user
        return; // Exit the function immediately after reading input from stdin
      } else {
        // We'll handle command-line arguments and their simulation here later.
        articleTitle = arguments.join(' '); // Join arguments into a single string
      }

      // We'll add the "Looking up..." and final simulation here later.
      print('Current article title: $articleTitle'); // This line will only run if arguments were provided
    }
    ```

    * `stdin.readLineSync()`: This function reads a line of text typed by the
        user into the console. Its return type is `String?`.
    * The `if (inputFromStdin == null || inputFromStdin.isEmpty)` performs a
        null check and an empty string check. If either is true, the program
        prints a message and `return`s, exiting the function.
    * `arguments.join(' ')`: This `List` method concatenates all elements of
        the `arguments` list into a single string, using a space as the
        separator. For example, `['Dart', 'Programming']` becomes
        `"Dart Programming"`. This is crucial for treating multi-word
        command-line inputs as a single search phrase.

7.  **Introduce `for-in` loops (separate demonstration):** While the `search`
    command itself will operate on a single combined phrase, understanding how
    to iterate over collections is fundamental. Here's a quick example of a
    `for-in` loop:

    ```dart
    // Example: Iterating over a list of strings
    void demonstrateForInLoop() {
      List<String> planets = ['Mercury', 'Venus', 'Earth', 'Mars'];
      print('\n--- Demonstrating for-in loop ---');
      for (var planet in planets) {
        print('Found: $planet');
      }
      print('--- End of for-in loop demonstration ---\n');
    }
    ```

    * **`for-in` loop:** The `for (var item in collection)` syntax provides a
        concise way to iterate through each element in a collection like a
        `List`. On each iteration, the `item` variable takes on the value of the
        current element. You can place this function anywhere outside `main` or
        `runApp`. You don't need to call it from anywhere for now; it's just to
        show the syntax.

8.  **Finalize `runApp` with single article simulation:** Now, let's complete
    the `runApp` function to print the simulation messages. Note that these
    messages will only appear if command-line arguments were provided (as
    `runApp` returns early for `stdin` input).

    ```dart
    void runApp(List<String>? arguments) {
      late String? articleTitle;

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();
        return; // Exits here if input is from stdin
      } else {
        articleTitle = arguments.join(' ');
      }

      // This section runs only if arguments were originally provided (not from stdin)
      print('Looking up articles about "$articleTitle". Please wait.'); // Using string interpolation
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")'); // Simulates finding the combined article
    }
    ```


9.  **Final Test Run with both scenarios:**

    Run with arguments (note the quotes around the search term in the output):

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    You should see:

    ```bash
    Looking up articles about "Dart Programming". Please wait.
    Here ya go!
    (Pretend this is an article about "Dart Programming")
    ```

    Run without arguments (type "Flutter Framework" when prompted):

    ```bash
    dart bin/cli.dart search
    ```

    ```bash
    Please provide an article title.
    Flutter Framework
    ```
    
    :::note
    The program will exit after you type "Flutter Framework" because `runApp`
    returns immediately after `stdin` input as per the sample code's behavior.

    :::

    You have now successfully built the basic `search` command with user input
    handling, correctly treating multi-word command-line inputs as a single
    search phrase in the output, and learned about `for-in` loops.

## Review

In this chapter, you learned:

* **Control flow:** Using `if/else` statements to control the execution flow
    of your program.
* **Variables and Constants:** Declaring variables with `var`, `const`, and `late String?`.
* **Lists:** Creating and manipulating lists using `.isNotEmpty`, `.first`,
    `.sublist`, and `.join()`.
* **Loops:** Iterating over collections using `for-in` loops.
* **Null Safety:** Understanding nullability (`?`) and using null checks.
* **Functions:** Defining and calling functions.
* **String interpolation:** Embedding variables in strings using `$`.
* **Input/Output:** Reading user input from the console using `stdin.readLineSync()`.

## Quiz

**Question 1:** Which keyword is used to declare a constant variable in Dart whose value is known at compile time?
* A) `var`
* B) `final`
* C) `const`
* D) `static`

**Question 2:** How do you check if a list named `myList` is empty in Dart?
* A) `myList.length == 0`
* B) `myList.isEmpty`
* C) `myList.size() == 0`
* D) Both A and B

**Question 3:** What is the primary purpose of `stdin.readLineSync()` in a CLI application?
* A) To print output to the console.
* B) To read a single line of text input from the user.
* C) To execute a command.
* D) To check if a file exists.

## Next lesson

In the next chapter, you'll dive into asynchronous programming and learn how to
fetch data from the Wikipedia API using the `http` package. This will allow your
application to retrieve real data and display it to the user.