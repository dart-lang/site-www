---
title: Making your CLI program interactive
short-title: Add commands
description: >-
  Add simple commands to your cli application. Learn the fundamentals of Dart
  syntax including control flow, collections, variables, functions, and more.
prevpage:
  url: /get-started/hello-world
  title: Build your first app
nextpage:
  url: /get-started/async
  title: Intro to async and HTTP
---

In this chapter, you'll get hands-on practice with Dart syntax. You'll learn how
to read user input, print usage information, and create a basic command-line
interaction.

:::secondary What you'll learn

* Implement basic control flow with `if/else` statements.
* Work with collections, specifically `List` objects, and perform common operations
  like checking if a list is empty.
* Declare and use variables with `const` and `late String?`.
* Handle nullability with null checks.
* Define and call functions.
* Use string interpolation for dynamic text.
* Read user input from the command line using the `stdin` command.

:::

## Prerequisites

Before you begin this chapter, ensure you have:

* Completed Chapter 1 and have a working Dart development environment.
* Familiarity with basic programming concepts (variables, data types, control
  flow).

## Tasks

Add some basic functionality to your **Dartpedia** command-line application and then
explore the Dart syntax for it.

### Task 1: Implement version and help commands

1.  **Implement the `version` command in `cli/bin/cli.dart`:** Add logic to
    handle a `version` command, which prints the current version of the CLI.
    Use an `if` statement to check if the first
    argument provided is `version`. You'll also need a `version` constant.

    First, above your `main` function, declare a `const` variable for the
    version. The value of a `const` variable can never be changed after it's
    been set:

    ```dart
    const version = '0.0.1'; // Add this line
    ```

    Next, modify your `main` function to check for the `version` argument:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty) {
        print('Hello, Dart!');
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
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
    Dartpedia CLI version 0.0.1
    ```

    If you run your app without arguments, you'll still see "Hello, Dart!".

1.  **Add a `printUsage` function:** To make the output more user-friendly,
    create a separate function to display usage information. Place this function
    outside and below your `main` function.

    ```dart
    void printUsage() { // Add this new function
      print(
        "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
      );
    }
    ```

    `search` is the command that will eventually search from Wikipedia.

1.  **Implement the `help` command and refine `main`:** Now, integrate the
    `help` command using an `else if` statement, and clean up the default
    behavior to call the `printUsage` function.

    Modify your `main` function to look like this:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage(); // Change this from 'Hello, Dart!'
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else {
        printUsage(); // Catch all for any unrecognized command.
      }
    }
    ```

1.  **Understand the `if/else` structure and variables:** Now that
    you've implemented control flow in the `main` function, review the
    code that was added for it.

    * `arguments.isNotEmpty` checks if any command-line arguments were
        provided.
    * `arguments.first` accesses the very first argument, which you're using as
        our command.
    * `version` is declared as a `const`. This means its
        value is known at compile time and you can't change it during runtime.
    * `arguments` is a regular (non-constant) variable
        because its content can change during runtime based on user input.

    Run your application with the help argument. You should see the
    usage information printed:

    ```bash
    dart bin/cli.dart help
    ```

    Also, try running it without any arguments:

    ```bash
    dart bin/cli.dart
    ```

    Notice that it continues to display usage information.
    At this point, any command you haven't defined will also
    print usage information. This is expected behavior for now.

### Task 2: Implement the search command

Next, implement a basic `search` command that takes an article title as
input. As you build this functionality, you'll work with `List` manipulation,
null checks, and string interpolation.

1.  **Integrate the `search` command into `main`:** First, modify the `main`
    function in `cli/bin/cli.dart` to include an `else if` branch that handles
    the `search` command. For now, just print a placeholder message.

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage(); 
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'search') {
        // Add this new block:
        print('Search command recognized!');
      } else {
        printUsage();
      }
    }
    ```

1.  **Test the new command:** Run your application with the `search`
    command:

    ```bash
    dart bin/cli.dart search
    ```

    You should see:

    ```bash
    Search command recognized!
    ```

1.  **Define the `searchWikipedia` function:** The `search` command
    will eventually run the core logic of your application by calling
    a function called `searchWikipedia`. For now, have
    `searchWikipedia` print the arguments passed into it with the
    `search` command. Place this new function below `main`.

    ```dart
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) { // Add this new function and add ? to arguments type
      print('searchWikipedia received arguments: $arguments');
    }

    // ... (your existing printUsage() function)
    ```

    Highlights from the preceding code:

    * `List<String>? arguments` means that the `arguments` list itself
       can be `null`. 
       
       :::note
       Dart enforces [sound null safety][], which means you
       have to explicity state when a variable can be null. Any
       variable that isn't marked as nullable is *guarateed* to never
       be null, even in production. The purpose of null-safety isn't
       to stop you from ever using null in your code, because
       representing the absense of a value can be valuable. Rather,
       it's to force you to consider nullability and therefor be more
       careful about it. Along with the analyzer, this helps prevent
       one of the most common runtime crashes in programming:
       null-pointer errors.
       ::: 

1.  **Call the `searchWikipedia` function from the `main` function:**
    Now, modify the `search` command block in `main` to call
    `searchWikipedia` and pass it any arguments that come after the
    `search` command itself. Use `arguments.sublist(1)` to get all
    arguments starting from the second one. If no arguments are
    provided after `search`, pass `null` to `searchWikipedia`.

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage(); 
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'search') {
        // Add this new block:
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs);
      } else {
        printUsage();
      }
    }
    ```

    Highlights from the preceding code:

    * `arguments.sublist(1)` creates a new list
        containing all elements of the `arguments` list *after* the first
        element (which was `search`).
    * `arguments.length > 1 ? ... : null;`
        is a conditional (ternary) operator. It ensures that if no arguments
        are provided after the `search` command, `inputArgs` becomes `null`, matching the
        sample code's behavior for `searchWikipedia`'s `arguments` parameter of `List<String>?`.

1.  **Test `searchWikipedia` with arguments:** Using the command line, run the application with a test article
    title:

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    You should see:

    ```bash
    searchWikipedia received arguments: [Dart, Programming]
    ```

    Next, run the same command without the extra arguments:

    ```bash
    dart bin/cli.dart search
    ```

    You should see:

    ```bash
    searchWikipedia received arguments: null
    ```

1.  **Handle the missing article title and user input with the `stdin` command:** It's more
    user-friendly to prompt the user if they don't provide an article title on
    the command line. Use `stdin.readLineSync()` for this.

    First, add the necessary import at the top of your `cli/bin/cli.dart` file:

    ```dart
    import 'dart:io'; // Add this line at the top
    ```

    `dart:io` is core library in the Dart SDK, and provides APIs to
    deal with files, directories, sockets, and
    HTTP clients and servers, and more. 

    Now, update your `searchWikipedia` function.

    ```dart
    void searchWikipedia(List<String>? arguments) {
      late String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Await input from the user
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      print('Current article title: $articleTitle');
    }
    ```

    This preceding code block introduces a few
    key concepts:

    * It declares a `late String? articleTitle` variable which will
        hold the full search query, whether it comes from the command
        line or user input. `late` is a keyword that tells the
        analyzer that you, the programmer, promise that this variable
        won't be null by the time it's used.
    * An `if/else` statement then checks if command-line arguments for the
        search were provided.
    * If arguments are missing, it prompts the user, reads input using
        `stdin.readLineSync()`, and performs null and empty checks.
    * If arguments *are* present, it uses `arguments.join(' ')` to combine
        them into a single search string.

    Highlights from the preceding code:

    * `stdin.readLineSync()` reads a line of text typed by the user into the
      console. Its return type is `String?`.
    * `if (inputFromStdin == null || inputFromStdin.isEmpty)` performs a
      null check and an empty string check. If either is true, the program
      prints a message and `return`s, exiting the function.
    * `arguments.join(' ')`: concatenates all elements of the `arguments` list
      into a single string, using a space as the separator. For example,
      `['Dart', 'Programming']` becomes `"Dart Programming"`. This is crucial
      for treating multi-word command-line inputs as a single search phrase.

1.  **Finish `searchWikipedia` to print mock search results:** Update `searchWikipedia` to display
    messages that look like our program found something. This helps us see what
    our finished program will do without actually building everything right now.
    You'll only see these messages if you include a search query when you run
    the program.
    
    For example: `dart bin/cli.dart search Dart Programming`.

    ```dart
    void searchWikipedia(List<String>? arguments) {
      late String? articleTitle;

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();
        return; // Exits here if input is from stdin
      } else {
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }
    ```

1.  **Final Test Run with both scenarios:**

    Now that the article simulation is set up, test the `searchWikipedia` function in a
    few different ways:

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

    You have now successfully built the basic `search` command with user input
    handling, correctly treating multi-word command-line inputs as a single
    search phrase in the output.

## Review

In this chapter, you learned:

* **Control flow:** Using `if/else` statements to control the execution flow
    of your program.
* **Variables and Constants:** Declaring variables with `var`, `const`, and `late String?`.
* **Lists:** Creating and manipulating lists using `.isNotEmpty`, `.first`,
    `.sublist`, and `.join()`.
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

**Question 2:** What is the primary purpose of `stdin.readLineSync()` in a CLI application?
* A) To print output to the console.
* B) To read a single line of text input from the user.
* C) To execute a command.
* D) To check if a file exists.

## Next lesson

In the next chapter, you'll dive into asynchronous programming and learn how to
fetch data from the Wikipedia API using the `http` package. This will allow your
application to retrieve real data and display it to the user.

[sound null safety]: https://dart.dev/null-safety
