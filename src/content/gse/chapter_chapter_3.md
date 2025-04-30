---
title: "Chapter 3: Intro to Async and HTTP"
description: "Learn about `async/await`, `Future`, `package:http`, `import` statements."
---

# Chapter 3: Intro to Async and HTTP
Learn about `async/await`, `Future`, `package:http`, `import` statements.

[Video Placeholder]

In this lesson, we'll dive into the world of asynchronous programming in Dart and learn how to interact with web APIs. We'll cover the concepts of `async/await` and `Future`, which are essential for handling operations that take time to complete, such as fetching data from a server. We'll also introduce the `package:http`, which allows us to make HTTP requests. By the end of this lesson, you'll be able to fetch a summary of a Wikipedia article from the Wikipedia API and print the raw JSON response to the console.

## Background / Key Concepts
*   **Asynchronous Programming:** Asynchronous programming allows your program to continue executing other tasks while waiting for a long-running operation to complete. This prevents your program from freezing or becoming unresponsive.
*   **`Future`:** A `Future` represents a value that will be available at some point in the future. It's like a promise that a result will be delivered later.
*   **`async/await`:** These keywords provide a way to write asynchronous code in a more synchronous style. The `async` keyword marks a function as asynchronous, and the `await` keyword pauses the execution of the function until a `Future` completes.
*   **`package:http`:** A popular Dart package that provides a simple and powerful way to make HTTP requests.
*   **`import` statements:**  Used to include code from other libraries or packages into your current file. This allows you to reuse existing code and avoid writing everything from scratch.

## Set up
Make sure you have completed Chapter 2 and have a working Dart project set up. We will be modifying the `cli/bin/cli.dart` file in this chapter. We will also be adding the `http` package as a dependency.

## Tasks
In this lesson, we'll add the `http` package to our project, modify our Dart program to fetch data from the Wikipedia API, and print the raw JSON response to the console.

### Add the `http` package as a dependency

1.  Open your `cli/pubspec.yaml` file.

2.  Add `http: ^1.3.0` to the `dependencies` section:

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

    The `^1.3.0` syntax means that you're compatible with any version starting with 1.3.0 and up to (but not including) 2.0.0.

3.  Run `dart pub get` in your terminal from the `cli` directory to download the new dependency. This command fetches all the packages listed in your `pubspec.yaml` file.

### Modify `cli/bin/cli.dart`

1.  Open `cli/bin/cli.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:io';

    import 'package:http/http.dart' as http;

    const version = '0.0.1';

    void main(List<String> arguments) {
      if (arguments.isNotEmpty && arguments.first == 'version') {
        print('Dart Wikipedia version $version');
      } else if (arguments.isNotEmpty && arguments.first == 'help') {
        printUsage();
      } else if (arguments.isNotEmpty && arguments.first == 'wikipedia') {
        // contrived
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        runApp(inputArgs);
      } else {
        printUsage();
      }
    }

    void printUsage() {
      print(
        "The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>'",
      );
    }

    void runApp(List<String>? arguments) async {
      late String? articleTitle;
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync();
        return;
      } else {
        articleTitle = arguments.join(', ');
      }

      print('Looking up articles about $articleTitle. Please wait.');

      // Code from here to end of file is different
      var article = await getWikipediaArticle(articleTitle);
      print(article);
    }

    Future<String> getWikipediaArticle(String articleTitle) async {
      final http.Client client = http.Client();
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final http.Response response = await client.get(url);
      if (response.statusCode == 200) {
        return response.body;
      }

      return 'Error: failed to fetch article $articleTitle';
    }
    ```

3.  **Explanation:**
    *   **`import 'package:http/http.dart' as http;`:** This line imports the `http` package, which we added as a dependency in the previous step. The `as http` part gives the imported package a namespace, so you can refer to it as `http`. This avoids potential naming conflicts with other libraries.
    *   **`void runApp(List<String>? arguments) async { ... }`:** The `runApp` function is now marked as `async`. This allows us to use the `await` keyword inside the function.
    *   **`var article = await getWikipediaArticle(articleTitle);`:** This line calls the `getWikipediaArticle` function, which fetches the article summary from the Wikipedia API. The `await` keyword pauses the execution of the `runApp` function until the `Future` returned by `getWikipediaArticle` completes.  The result of the `Future` (the article summary) is then stored in the `article` variable.
    *   **`Future<String> getWikipediaArticle(String articleTitle) async { ... }`:** This function is also marked as `async` and returns a `Future<String>`, indicating that it will eventually return a string.
    *   **`final http.Client client = http.Client();`:** Creates a new `http.Client` object. This client is used to make HTTP requests.
    *   **`final Uri url = Uri.https( ... );`:**  Constructs a `Uri` object representing the URL of the Wikipedia API endpoint.
        *   `'en.wikipedia.org'`: The host (domain) of the API.
        *   `'/api/rest_v1/page/summary/$articleTitle'`: The path to the specific resource (article summary). The `$articleTitle` part is string interpolation, which inserts the article title into the URL.
    *   **`final http.Response response = await client.get(url);`:** This line makes an HTTP GET request to the Wikipedia API using the `client.get()` method. The `await` keyword pauses the execution of the `getWikipediaArticle` function until the `Future` returned by `client.get()` completes. The result of the `Future` (the HTTP response) is then stored in the `response` variable.
    *   **`if (response.statusCode == 200) { ... }`:** This `if` statement checks if the HTTP status code of the response is 200 (OK). If it is, the function returns the body of the response (which is the JSON data).
    *   **`return response.body;`:** Returns the body of the HTTP response, which contains the JSON data representing the article summary.
    *   **`return 'Error: failed to fetch article $articleTitle';`:** If the HTTP status code is not 200, the function returns an error message.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following command and observe the output:

    ```bash
    dart run bin/cli.dart wikipedia Dart
    ```

    Output (will vary depending on the article):

    ```bash
    Looking up articles about Dart. Please wait.
    {"type":"standard","title":"Dart","displaytitle":"Dart","namespace":{"id":0,"key":""},"wikibase_item":"Q186097","titles":{"canonical":"Dart","normalized":"Dart","display":"Dart"},"pageid":16784,"thumbnail":{"height":200,"width":320,"url":"https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Dart-logo.png/320px-Dart-logo.png","source":"https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Dart-logo.png/320px-Dart-logo.png"},"originalimage":{"height":600,"width":960,"url":"https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png","source":"https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png"},"lang":"en","dir":"ltr","revision":"1211298259","content_urls":{"desktop":{"page":"https://en.wikipedia.org/wiki/Dart","revisions":"https://en.wikipedia.org/wiki/Special:History/Dart","edit":"https://en.wikipedia.org/w/index.php?action=edit&title=Dart"},"mobile":{"page":"https://en.m.wikipedia.org/wiki/Dart","revisions":"https://en.m.wikipedia.org/wiki/Special:History/Dart","edit":"https://en.m.wikipedia.org/w/index.php?action=edit&title=Dart"}},"extract":"Dart is a structured web programming language developed by Google. It is used to build web, server, desktop, and mobile applications. Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. It supports interfaces, mixins, abstract classes, refined generics, and type inference.","extract_html":"<p><b>Dart</b> is a structured web programming language developed by Google. It is used to build web, server, desktop, and mobile applications. Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. It supports interfaces, mixins, abstract classes, refined generics, and type inference.</p>"}
    ```

[Pop out placeholder: Experiment with different article titles. Try entering titles that don't exist to see the error message.]

## Review
In this lesson, you learned how to:

*   Use `async/await` to write asynchronous code in a more synchronous style.
*   Work with `Future` objects to represent values that will be available in the future.
*   Add external packages to your project using `pubspec.yaml` and `dart pub get`.
*   Import packages using `import` statements.
*   Make HTTP requests using the `package:http`.
*   Fetch data from a web API.
*   Handle HTTP responses and check for errors.

**Quiz Question:**

What is the purpose of the `await` keyword in Dart?

*   [Option A] To define a constant variable.
*   [Option B] To pause the execution of a function until a `Future` completes.
*   [Option C] To create a new object.
*   [Option D] To import a package.

## Next lesson
In the next lesson, we'll learn how to organize our code into libraries and packages, making our project more modular and maintainable. We'll create a separate package for our command-line logic and import it into our main application.