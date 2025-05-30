---
title: Intro to async and HTTP
short-title: Async and HTTP
description: >-
  Learn about asynchronous programming in Dart and how to make HTTP requests.
prevpage:
  url: /get-started/add-commands
  title: Make your program interactive
nextpage:
  url: /get-started
  title: Packages and librarires
---

In this chapter, you'll explore asynchronous programming in Dart, allowing your
applications to perform multiple tasks concurrently. You'll learn how to fetch
data from the internet using the `http` package, specifically retrieving an
article summary from Wikipedia.

:::secondary What you'll learn

* Understand asynchronous programming, `Future`s, `async`, and `await`.
* Learn about the `http` package and import statements.
* Implement the `getWikipediaArticle` function step-by-step, including `http.Client`.
* Understand how the main logic function becomes `async` to handle `await`.
* Run the application to see HTTP data fetching in action.

:::

## Prerequisites

* Completion of Chapter 2, which covered basic Dart syntax and command-line
  interaction. You should have a `dartpedia` project set up.
* Familiarity with the concept of APIs (Application Programming Interfaces) as a
  way to retrieve data.

## Tasks

In this chapter, you will modify the existing `dartpedia` CLI application to fetch and
display an **article summary** using the `http` package and asynchronous
programming techniques.

### Task 1: Adding the http dependency

Before you can make HTTP requests, you need to add the `http` package
as a dependency to your project.

1.  Open the `dartpedia/pubspec.yaml` file within your project. This file is
    called the **pubspec**, and it manages your Dart project's metadata,
    dependencies (like the `http` package), and assets.
2.  Locate the `dependencies` section.
3.  Add `http: ^1.3.0` (or the latest stable version) under `dependencies`. The
    `^` symbol allows compatible versions to be used.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

4.  Save the `pubspec.yaml` file.
5.  Run `dart pub get` in your terminal from the `dartpedia` directory. This
    command fetches the newly added dependency and makes it available for
    use in your project.

    You should see output similar to this:

    ```bash
    Resolving dependencies...  
    Downloading packages...  
    + http 1.4.0
      lints 5.1.1 (6.0.0 available)
    Changed 1 dependency!
    1 package has newer versions incompatible with dependency constraints.
    Try `dart pub outdated` for more information.
    ```

### Task 2: Importing the http package

Now that you've added the `http` package, you need to import it into
your Dart file to use its functionalities.

1.  Open the `dartpedia/bin/cli.dart` file.
2.  Add the following `import` statement at the top of the file, along
    with the existing `dart:io` import:

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http; // Add this line
    ```

    This line imports the `http` package and gives it the alias `http`.
    This allows you to refer to classes and functions within the `http`
    package using `http.` (e.g., `http.Client`, `http.get`). The `as http`
    part is a standard convention to avoid naming conflicts if another
    imported library also has a similarly named class or function.

### Task 3: Implement the `getWikipediaArticle` function

You will now create a new function called `getWikipediaArticle` that
handles fetching data from an external API. This function will be `async`
because network requests are asynchronous operations.

1.  **Define the function signature:**
    Below your `main` function (and `printUsage` function), add the
    following function signature.
    The `Future<String>` return type indicates that this function will
    eventually produce a `String` result, but not immediately, because
    it's an asynchronous operation. The `async` keyword marks the
    function as asynchronous, allowing you to use `await` inside it.

    ```dart
    // ... (your existing printUsage() function)

    Future<String> getWikipediaArticle(String articleTitle) async {
      // We'll add more code here soon
    }
    ```

2.  **Construct the API URL and `http.Client`:**
    Inside your new `getWikipediaArticle` function, create an `http.Client()`
    instance and a `Uri` object. The `Uri` represents the endpoint of the
    Wikipedia API you'll be calling to get an article summary.

    Add these lines inside the `getWikipediaArticle` function:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final http.Client client = http.Client(); // Create an HTTP client
      final Uri url = Uri.https(
        'en.wikipedia.org', // Wikipedia API domain
        '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
      );
      // ...
    }
    ```

    :::note
    For applications making multiple HTTP requests or needing advanced
    features like persistent connections, it's generally more efficient and
    recommended to use an `http.Client()` instance and close it when no
    longer needed.
    :::

3.  **Make the HTTP Request and handle the response:**
    Now, use the `http` client to make an HTTP `GET` request to the URL
    you just constructed. The `await` keyword pauses the execution of
    `getWikipediaArticle` until the `client.get(url)` call completes and
    returns an `http.Response` object.

    After the request completes, check the `response.statusCode` to
    ensure the request was successful (a status code of `200` means OK).
    If successful, return the `response.body`, which contains the
    fetched data (in this case, raw JSON). If the request failed, return
    an informative error message.

    Add these lines after the `Uri` construction within `getWikipediaArticle`:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final http.Client client = http.Client();
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final http.Response response = await client.get(url); // Make the HTTP request

      if (response.statusCode == 200) {
        return response.body; // Return the response body if successful
      }

      // Return an error message if the request failed
      return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
    }
    ```

### Task 4: Refactor `searchWikipedia` into `runApp` and integrate the API call

In Chapter 2, you added a `searchWikipedia` function. To make the code more organized and align with common Dart application patterns, you'll now rename that function to `runApp` and integrate the API call into it. This `runApp` function will house the core logic for handling the `wikipedia` command.

1.  **Rename `searchWikipedia` to `runApp` and update its signature:**
    Locate your `searchWikipedia` function and rename it to `runApp`. Also, update its signature to be `async` as it will now perform asynchronous operations.

    Your `runApp` function should now look like this (initial part):

    ```dart
    // ... (your existing main function)

    void runApp(List<String>? arguments) async { // Renamed from searchWikipedia and added 'async'
      late String? articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Await input from the user
        // We'll add error handling for null input here in a moment
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      // ... rest of the function
    }

    // ... (your existing printUsage() function)
    ```
    * `void runApp(List<String>? arguments) async`: Notice that the function is now `async`. This is essential because it will call `getWikipediaArticle`, which is an `async` function itself and we'll need to `await` its result.

2.  **Add `null` and empty string checks for user input:**
    Inside `runApp`, refine the `if` block that handles the case where no arguments are provided. If `stdin.readLineSync()` returns `null` (e.g., if the user presses Ctrl+D/Ctrl+Z) or an empty string, print a message and exit the function.

    ```dart
    void runApp(List<String>? arguments) async {
      late String? articleTitle;

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        final inputFromStdin = stdin.readLineSync(); // Read input
        if (inputFromStdin == null || inputFromStdin.isEmpty) {
          print('No article title provided. Exiting.');
          return; // Exit the function if no valid input
        }
        articleTitle = inputFromStdin;
      } else {
        articleTitle = arguments.join(' ');
      }

      // ... rest of the function
    }
    ```

3.  **Call `getWikipediaArticle` and print the result:**
    Now, modify the `runApp` function to call your new `getWikipediaArticle` function and print the result. Replace the previous placeholder print statements with the actual API call.

    ```dart
    // ... (beginning of runApp function, after determining articleTitle)

    void runApp(List<String>? arguments) async {
      late String? articleTitle;
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        final inputFromStdin = stdin.readLineSync();
        if (inputFromStdin == null || inputFromStdin.isEmpty) {
          print('No article title provided. Exiting.');
          return;
        }
        articleTitle = inputFromStdin;
      } else {
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');

      // Call the API and await the result
      var articleContent = await getWikipediaArticle(articleTitle);
      print(articleContent); // Print the full article response (raw JSON for now)
    }
    ```
    * `await getWikipediaArticle(articleTitle)`: Because `getWikipediaArticle` is an `async` function, we need to `await` its result. This pauses the `runApp` function until the `Future<String>` returned by `getWikipediaArticle` resolves into a `String` containing the article's contents.
    * `print(articleContent)`: Prints the fetched article summary (as a raw JSON string) to the console.

### Task 5: Update `main` to call `runApp`

Finally, you need to update your `main` function to call the new `runApp` function when the `wikipedia` command is used.

1.  Locate the `else if` block in your `main` function that currently handles the `search` command. Change the command name from `search` to `wikipedia` and update the function call.
    In the sample code, `main` does *not* `await` the call to `runApp`, meaning `main` itself does not need to be marked `async`.
    Your `main` function should now look like this:

    ```dart
    // ... (existing const version declaration and printUsage function)

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'wikipedia') { // Changed to 'wikipedia'
        // Pass all arguments *after* 'wikipedia' to runApp
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        runApp(inputArgs); // Call runApp (no 'await' needed here for main)
      } else {
        printUsage(); // Catch all for any unrecognized command.
      }
    }
    ```
    * `arguments.sublist(1)`: This extracts all elements from the `arguments` list starting from the second element (index 1). This effectively removes the `wikipedia` command itself, so `runApp` only receives the actual article title arguments.
    * `runApp(inputArgs)`: We call `runApp` directly. Since `main` doesn't need to do anything after `runApp` completes, we don't need to `await` it from `main` (and therefore `main` doesn't need to be `async`).

### Task 6: Running the application

Now that you've implemented the `http` request and integrated it into your application, let's test it out.

1.  Open your terminal and navigate to the `dartpedia` directory.
2.  Run the command `dart run bin/cli.dart wikipedia Dart`.
3.  The application should now fetch the summary of the "Dart" article from
    the Wikipedia API and print the raw JSON response to the console. You
    might see something like:

    ```json
    Looking up articles about "Dart". Please wait.
    {
      "type": "standard",
      "title": "Dart",
      "displaytitle": "Dart",
      "extract": "Dart is a client-optimized programming language developed by Google and certified by ECMA. It is used to build mobile, desktop, server, and web applications.",
      "content_urls": {
        "desktop": {
          "page": "[https://en.wikipedia.org/wiki/Dart](https://en.wikipedia.org/wiki/Dart)"
        }
      }
      // ... (rest of the JSON output will be present but truncated here)
    }
    ```
4.  Next, try running without arguments (type "Flutter Framework" when prompted):

    ```bash
    dart run bin/cli.dart wikipedia
    ```

    ```bash
    Please provide an article title.
    Flutter Framework
    Looking up articles about "Flutter Framework". Please wait.
    {
      "type": "standard",
      "title": "Flutter",
      "displaytitle": "Flutter",
      "extract": "Flutter is a free and open-source mobile UI framework developed by Google and released in May 2017. It allows developers to build native iOS and Android apps from a single codebase, as well as web, desktop and embedded applications.",
      "content_urls": {
        "desktop": {
          "page": "[https://en.wikipedia.org/wiki/Flutter](https://en.wikipedia.org/wiki/Flutter)"
        }
      }
      // ... (The API will likely return the "Flutter" article summary as it's a close match)
    }
    ```
    You have now successfully implemented the basic `wikipedia` command that fetches real data from an external API!

## Review

In this chapter, you learned about:

* **Asynchronous programming:** Understanding `Future`s, `async`, and `await` for operations that take time, like network requests.
* **External packages:** How to add dependencies using `pubspec.yaml` and import them into your Dart files.
* **HTTP requests:** Making network calls using the `package:http` library.
* **API interaction:** Fetching data from a public API (Wikipedia) and handling its response.
* **Code organization:** Refactoring logic into a dedicated `runApp` function for better structure.

## Quiz

**Question 1:** What keyword is used to mark a function as asynchronous in Dart?
* A) `sync`
* B) `async`
* C) `future`
* D) `thread`

**Question 2:** What does the `await` keyword do?
* A) Cancels the execution of an asynchronous function.
* B) Declares a new `Future` object.
* C) Pauses the execution of the current `async` function until a `Future`
    completes.
* D) Creates a new thread.

**Question 3:** Which package did we use to make HTTP requests?
* A) `dart:io`
* B) `dart:html`
* C) `package:http`
* D) `package:async`

## Next lesson

In the next chapter, we'll focus on organizing our code into reusable
libraries and packages. We'll refactor our application to improve its
structure and maintainability by creating a separate package for
handling command-line arguments.