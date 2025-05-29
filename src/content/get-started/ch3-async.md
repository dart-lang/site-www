---
title: Intro to Async and HTTP
description: Learn about asynchronous programming in Dart and how to make HTTP requests.
---

In this chapter, you'll **explore** the world of asynchronous programming in Dart, allowing your applications to perform multiple tasks concurrently. You'll learn how to fetch data from the internet using the `http` package, specifically retrieving an **article summary from a knowledge database**. This involves understanding `async/await`, `Future`, and how to import external packages.

## Prerequisites

* Completion of Chapter 2, which covered basic Dart syntax and command-line interaction.
* Familiarity with the concept of APIs (Application Programming Interfaces) as a way to retrieve data.

## Background / Key Concepts

* **Asynchronous Programming:** A programming paradigm that allows a program to initiate a potentially long-running task and continue executing other tasks without waiting for the first one to complete.
* **`Future`:** Represents the result of an asynchronous computation. It's an object that will eventually hold a value (or an error) that isn't immediately available.
* **`async` and `await`:** Keywords that simplify working with `Future` objects. `async` marks a function as asynchronous, allowing the use of `await`. `await` pauses the execution of the function until the `Future` it's waiting on completes.
* **`package:http`:** A Dart package that provides a simple way to make HTTP requests to servers.
* **`import` statement:** Used to include external libraries or packages in your Dart code, granting access to their functionalities.

## Tasks

In this chapter, you will modify the existing CLI application to fetch and display an **article summary** using the `http` package and asynchronous programming techniques.

### Task 1: Adding the `http` Dependency

Before you can make HTTP requests, you need to add the `http` package as a dependency to your project.

1.  Open the `cli/pubspec.yaml` file within your project. This file is called the **pubspec**, and it manages your Dart project's metadata, dependencies (like the `http` package), and assets.
2.  Locate the `dependencies` section.
3.  Add `http: ^1.3.0` (or the latest version) under `dependencies`. The `^` symbol allows compatible versions to be used.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

4.  Save the `pubspec.yaml` file.
5.  Run `dart pub get` in the `cli` directory of your terminal. This command fetches the newly added dependency and makes it available for use in your project.

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

### Task 2: Importing the `http` Package

Now that you've added the `http` package, you need to import it into your Dart file to use its functionalities.

1.  Open the `cli/bin/cli.dart` file.
2.  Add the following `import` statement at the top of the file, along with the existing `dart:io` import:

    ```dart
    import 'package:http/http.dart' as http;
    ```

    This line imports the `http` package and gives it the alias `http`. This allows you to refer to classes and functions within the `http` package using `http.` (e.g., `http.Client`, `http.get`). The `as http` part is a standard convention to avoid naming conflicts if another imported library also has a similarly named class or function.

### Task 3: Implement the `getArticleSummary` Function

You will now create a new function called `getArticleSummary` that handles fetching data from an external API. You'll build this function step-by-step.

1.  **Define the function signature:**
    Add the following function to the `cli/bin/cli.dart` file. The `Future<String>` return type indicates that this function will eventually produce a `String` result, but not immediately, because it's an asynchronous operation. The `async` keyword marks the function as asynchronous, allowing you to use `await` inside it.

    ```dart
    Future<String> getArticleSummary(String articleTitle) async {
      // We'll add more code here soon
    }
    ```

2.  **Construct the API URL:**
    Inside your new `getArticleSummary` function, create a `Uri` object. This `Uri` represents the endpoint of the (example) API you'll be calling. For now, we'll use the Wikipedia API for demonstration.

    ```dart
        // ... (inside getArticleSummary function)

        final Uri url = Uri.https(
          'en.wikipedia.org', // Wikipedia API domain
          '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
        );

        // ...
    ```

3.  **Make the HTTP Request:**
    Now, use the `http` package to make an HTTP GET request to the URL you just constructed. The `await` keyword pauses the execution of `getArticleSummary` until the `http.get(url)` call completes and returns an `http.Response` object.

    ```dart
        // ... (inside getArticleSummary function, after Uri)

        final http.Response response = await http.get(url);

        // ...
    ```

    :::note
    For simplicity in this "getting started" guide, we're using the top-level `http.get()` function. For applications making multiple HTTP requests or needing advanced features like persistent connections, it's generally more efficient and recommended to use an `http.Client()` instance and close it when no longer needed.
    :::

4.  **Handle the Response:**
    After the request completes, check the `response.statusCode` to ensure the request was successful (a status code of `200` means OK). If successful, return the `response.body`, which contains the fetched data (in this case, raw JSON). If the request failed, return an informative error message.

    ```dart
        // ... (inside getArticleSummary function, after http.get)

        if (response.statusCode == 200) {
          return response.body;
        }

        return 'Error: failed to fetch article "$articleTitle" (Status: ${response.statusCode})';
    ```

    Your complete `getArticleSummary` function should now look like this:

    ```dart
    Future<String> getArticleSummary(String articleTitle) async {
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      }

      return 'Error: failed to fetch article "$articleTitle" (Status: ${response.statusCode})';
    }
    ```

There's nothing to test at this point. In the next task, you'll call this function and hook it into your app's flow.

### Task 4: Call the `getArticleSummary` Function

Now you will modify the `runApp` function to call your new `getArticleSummary` function and print the result.

1.  First, ensure the `runApp` function itself is declared `async`. This is necessary because it will now contain an `await` call to `getArticleSummary`. When a function is marked `async`, it implicitly returns a `Future`, allowing other `async` functions to `await` its completion.

    ```dart
    Future<void> runApp(List<String>? arguments) async { // Added 'async' here, and changed return type to Future<void>
    ```

2.  Next, modify the `main` function in `cli/bin/cli.dart` to `await` the call to `runApp`. This is necessary because `runApp` is now an `async` function. Locate the `else if` block that handles the `search` command and its corresponding `else` block, and replace it with the following:

    ```dart
    // ... (existing code in main function)

    else if (arguments.isNotEmpty && arguments.first == 'search') { // This is your new command name
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : <String>[]; // Fix for List<String>[]
      await runApp(inputArgs); // Add 'await' here
    } else { // This is the final 'else' block for main
      printUsage();
    }
    // ...
    ```

3.  Finally, modify the `runApp` function to include this line, replacing the previous `for-in` loop placeholder (or any placeholder for fetching data):

    ```dart
    // ... (beginning of runApp function, after determining lookupArgs)

    print('Looking up articles about $articleTitle. Please wait.');

    // Replace previous data fetching logic with this:
    final article = await getArticleSummary(lookupArgs.first); // For simplicity, we'll fetch only the first requested article for now.
    print(article);

    // ... (rest of runApp function)
    ```

    * This line calls the `getArticleSummary` function with the first user-provided `articleTitle` from `lookupArgs`.
    * `await`: Because `getArticleSummary` is an `async` function, we need to `await` its result. This pauses the `runApp` function until the `Future<String>` returned by `getArticleSummary` resolves into a `String` containing the article's contents.
    * `print(article)`: Prints the fetched article summary (as a raw JSON string) to the console.

### Task 5: Running the Application

1.  Open your terminal and navigate to the `cli` directory.
2.  Run the command `dart run bin/cli.dart search Dart`.
3.  The application should now fetch the summary of the "Dart" article from the Wikipedia API and print the raw JSON response to the console. You might see something like:

    ```json
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
      // ... (rest of the JSON output will be present but truncated here for brevity)
    }
    ```

    :::note
    The JSON output can be quite long and appear as a single line in your terminal. You can use online JSON formatters or tools like `jq` to make it more readable if needed.
    :::

    :::important
    **Important Note on Naming:** In this guide, we are temporarily using the Wikipedia API and `search` as the command name for demonstration purposes. In a real-world project, or as this guide progresses to more advanced topics, these names and the specific API endpoint will be updated to a project-specific, legally-safe alternative. We will finalize these names in a later chapter based on team decisions.
    :::

[Pop out: **Important Note:** When making HTTP requests, it's crucial to handle potential errors, such as network connectivity issues or invalid API responses. In a real-world application, you should add more robust error handling using `try...catch` blocks to gracefully manage these situations. We will cover this in a later chapter!]

## Review

In this chapter, you learned about:

* Asynchronous programming using `async` and `await`.
* Working with `Future` objects to handle asynchronous operations.
* Importing and using external packages like `package:http`.
* Making HTTP requests to fetch data from an API.
* Basic error handling for API requests (checking status code).

## Quiz

**Question 1:** What keyword is used to mark a function as asynchronous in Dart?
* A) `sync`
* B) `async`
* C) `future`
* D) `thread`

**Question 2:** What does the `await` keyword do?
* A) Cancels the execution of an asynchronous function.
* B) Declares a new `Future` object.
* C) Pauses the execution of the current `async` function until a `Future` completes.
* D) Creates a new thread.

**Question 3:** Which package did we use to make HTTP requests?
* A) `dart:io`
* B) `dart:html`
* C) `package:http`
* D) `package:async`

## Next lesson

In the next chapter, we'll focus on organizing our code into reusable libraries and packages. We'll refactor our application to improve its structure and maintainability by creating a separate package for handling command-line arguments.