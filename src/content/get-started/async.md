---
title: Intro to async and HTTP
shortTitle: Async and HTTP
description: >-
  Learn about asynchronous programming in Dart and how to make HTTP requests.
sitemap: false
noindex: true
showToc: false
prevpage:
  url: /get-started/add-commands
  title: Make your program interactive
nextpage:
  url: /get-started/packages-libs
  title: Packages and libraries
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll explore asynchronous programming in Dart, allowing your
applications to perform multiple tasks concurrently. You'll learn how to fetch
data from the internet using the `http` package, to retrieve an article summary
from Wikipedia.

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
* Familiarity with the concept of APIs ([Application Programming Interfaces][]) as a
  way to retrieve data.

## Tasks

In this chapter, you will modify the existing `dartpedia` CLI application to
fetch and display an **[article summary][]** using the `http` package and
asynchronous programming techniques.

### Task 1: Add the http dependency

Before you can make HTTP requests, you need to add the `http` package as a
dependency to your project.

1.  Open the `dartpedia/pubspec.yaml` file within your project. This file is
    called the **pubspec**, and it manages your Dart project's metadata,
    dependencies (like the `http` package), and assets.
1.  Locate the `dependencies` section.
1.  Add `http: ^1.3.0` (or the latest stable version) under `dependencies`. The
    `^` symbol allows compatible versions to be used.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

1.  Save the `pubspec.yaml` file.
1.  Run `dart pub get` in your terminal from the `dartpedia/cli` directory. This
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

### Task 2: Import the http package

Now that you've added the `http` package, you need to import it into
your Dart file to use its functionalities.

1.  Open the `dartpedia/bin/cli.dart` file.
1.  Add the following `import` statement at the top of the file, along with the
    existing `dart:io` import:

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http; // Add this line
    ```

    This line imports the `http` package and gives it the alias `http`. After
    you do this, you can refer to classes and functions within the `http`
    package using `http.` (for example, `http.Client`, `http.get`). The `as
    http` part is a standard convention to avoid naming conflicts if another
    imported library also has a similarly named class or function.

### Task 3: Implement the `getWikipediaArticle` function

Now create a new function called `getWikipediaArticle` that handles
fetching data from an external API. This function will be `async` because
network requests are asynchronous operations.

1.  **Define the function signature:**
    Below your `main` function (and `printUsage` function), add the following
    function signature.

    ```dart
    // ... (your existing printUsage() function)

    Future<String> getWikipediaArticle(String articleTitle) async {
      //You'll add more code here soon
    }
    ```

    Highlights from the preceding code:

    * The `Future<String>` return type indicates that this function will
    eventually produce a `String` result, but not immediately, because it's an asynchronous operation.
    * The `async` keyword marks the function as asynchronous, allowing you to
    use `await` inside it.

1.  **Construct the API URL and `http.Client`:**
    Inside your new `getWikipediaArticle` function, create an `http.Client()`
    instance and a `Uri` object. The `Uri` represents the endpoint of the
    Wikipedia API you'll be calling to get an article summary.

    Add these lines inside the `getWikipediaArticle` function:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final client = http.Client(); // Create an HTTP client
      final url = Uri.https(
        'en.wikipedia.org', // Wikipedia API domain
        '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
      );
      // ...
    }
    ```

2.  **Make the HTTP Request and handle the response:**
    Now, use the `http` client to make an HTTP `GET` request to the URL you just constructed. The `await` keyword pauses the execution of
    `getWikipediaArticle` until the `client.get(url)` call completes and returns
    an `http.Response` object.

    After the request completes, check the `response.statusCode` to ensure the
    request was successful (a status code of `200` means OK). If successful,
    return the `response.body`, which contains the fetched data (in this case,
    raw JSON). If the request fails, return an informative error message.

    Add these lines after the `Uri` construction within `getWikipediaArticle`:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final client = http.Client();
      final url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final response = await client.get(url); // Make the HTTP request

      if (response.statusCode == 200) {
        return response.body; // Return the response body if successful
      }

      // Return an error message if the request failed
      return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
    }
    ```

### Task 4: Integrate the API call into searchWikipedia

You'll integrate the API call into `searchWikipedia`. This function will house
the core logic for handling the `wikipedia` command.

1.  **Update `searchWikipedia` to use `async`:**
    Locate your `searchWikipedia` function and update its signature to be
    `async` as it will now perform asynchronous operations.

    Your `searchWikipedia` function should now look like this (initial part):

    ```dart
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) async { // Added 'async'
      late String? articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Await input from the user
        // You'll add error handling for null input here in a moment
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }

    // ... (your existing printUsage() function)
    ```
    
    Highlights from the preceding code:
    
    * `void searchWikipedia(List<String>? arguments) async`: The function is now
    `async`. This is essential because it will call `getWikipediaArticle`,
    which is an `async` function itself and will need to `await` its result.

1.  **Add `null` and empty string checks for user input:**
    Inside `searchWikipedia`, refine the `if` block that handles the case where
    no arguments are provided. If `stdin.readLineSync()` returns `null` (for
    example, if the user presses Ctrl+D/Ctrl+Z) or an empty string, print a
    message and exit the function.

    ```dart
    void searchWikipedia(List<String>? arguments) async {
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

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }
    ```

1.  **Call `getWikipediaArticle` and print the result:**
    Now, modify the `searchWikipedia` function to call your new
    `getWikipediaArticle` function and print the result. Replace the previous
    placeholder `print` statements with the actual API call.

    ```dart
    // ... (beginning of searchWikipedia function, after determining articleTitle)

    void searchWikipedia(List<String>? arguments) async {
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

    Highlights from the preceding code:

    * `await getWikipediaArticle(articleTitle)`: Because `getWikipediaArticle`
    is an `async` function, you need to `await` its result. This pauses the
    `searchWikipedia` function until the `Future<String>` returned by
    `getWikipediaArticle` resolves into a `String` containing the article's
    contents.
    * `print(articleContent)`: Prints the fetched article summary as a raw JSON
    string to the console.

### Task 5: Update main to call searchWikipedia

Finally, update your `main` function to call the new `searchWikipedia` function
when the `wikipedia` command is used.

1.  Locate the `else if` block in your `main` function that currently handles
    the `search` command. Change the command name from `search` to `wikipedia`
    and update the function call.
    
    In the sample code, `main` does *not* `await` the call to `searchWikipedia`,
    meaning `main` itself does not need to be marked `async`.
    
    Your `main` function should now look like this:

    ```dart
    // ... (existing const version declaration and printUsage function)

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'wikipedia') { // Changed to 'wikipedia'
        // Pass all arguments *after* 'wikipedia' to searchWikipedia
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs); // Call searchWikipedia (no 'await' needed here for main)
      } else {
        printUsage(); // Catch all for any unrecognized command.
      }
    }
    ```

    * `arguments.sublist(1)`: This extracts all elements from the `arguments`
    list starting from the second element (index 1). This effectively removes
    the `wikipedia` command itself, so `searchWikipedia` only receives the
    actual article title arguments.
    * `searchWikipedia(inputArgs)`: This calls `searchWikipedia` directly. Since
    `main` doesn't need to do anything after `searchWikipedia` completes, you
    don't need to `await` it from `main` (and therefore `main` doesn't need to
    be `async`).

### Task 6: Run the application

Now that you've implemented the `http` request and integrated it into your
application, test it out.

1.  Open your terminal run the following command:
    
    ```dart
    dart run bin/cli.dart wikipedia "Dart_(programming_language)"
    ```
    
1.  Check to make sure that the application fetched the summary of the "Dart"
    article from the Wikipedia API and print the raw JSON response to the
    console. You might see something like:

    ```bash
    Looking up articles about "Dart_(programming_language)". Please wait.
    {
      "type": "standard",
      "title": "Dart (programming language)",
      "displaytitle": "<span class=\"mw-page-title-main\">Dart (programming language)</span>",
      "namespace": {
          "id": 0,
          "text": ""
        }

      // ... (rest of the JSON output will be present but truncated here)

    }
    ```
1.  Next, try running without arguments (type or paste in "Flutter_(software)"
    when prompted):

    ```bash
    dart run bin/cli.dart wikipedia
    ```

    ```bash
    Please provide an article title.
    Flutter_(software)
    Looking up articles about "Flutter_(software)". Please wait.
    {
      "type": "standard",
      "title": "Flutter (software)",
      "displaytitle": "<span class=\"mw-page-title-main\">Flutter (software)</span>",
      "namespace": {
          "id": 0,
          "text": ""
      }

    // ... (rest of the JSON output will be present but truncated here)

    }
    ```
    You have now successfully implemented the basic `wikipedia` command that
    fetches real data from an external API!

## Review

In this chapter, you learned about:

* **Asynchronous programming:** Understanding `Future`s, `async`, and `await`
for operations that take time, like network requests.
* **External packages:** How to add dependencies using `pubspec.yaml` and import
them into your Dart files.
* **HTTP requests:** Making network calls using the `package:http` library.
* **API interaction:** Fetching data from a public API (Wikipedia) and handling
its response.
* **Code organization:** Refactoring logic into a dedicated `searchWikipedia`
function for better structure.

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

**Question 3:** Which package is used in this guide to make HTTP requests?
* A) `dart:io`
* B) `dart:html`
* C) `package:http`
* D) `package:async`

## Next lesson

In the next chapter, You'll focus on organizing our code into reusable
libraries and packages. You'll refactor our application to improve its
structure and maintainability by creating a separate package for
handling command-line arguments.

[Application Programming Interfaces]: https://www.postman.com/what-is-an-api/
[article summary]: http://en.wikipedia.org/api/rest_v1/#/Page%20content/get_page_summary__title_