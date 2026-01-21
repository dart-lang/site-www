---
title: Fetch data from the internet
shortTitle: HTTP requests
description: >-
  Refactor your application to use a robust, production-ready
  API client for the Wikipedia CLI.
layout: learn
prevpage:
  url: /learn/tutorial/testing
  title: Test your app & code
nextpage:
  url: /learn/tutorial/logging
  title: Add logging for debugging and monitoring
---

In Chapter 3, you used the `http` package to make a simple request.
Now, you'll revisit HTTP to
build a robust, production-ready API client within the `wikipedia` package.
You'll learn how to handle query parameters,
map JSON responses to your data models, and
export these functions for use in your CLI.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Construct complex URIs with query parameters
    icon: link
  - title: Create a production-ready HTTP API client
    icon: cloud_download
  - title: Export functions and types for reuse
    icon: export_notes
</SummaryCard>

## Prerequisites

Before you begin this chapter, ensure you:

-   Have completed Chapter 10 and have a
    working Dart development environment with the `dartpedia` project.
-   Understand basic networking concepts (like APIs and HTTP requests).
-   Understand basic data serialization formats such as JSON.

## Tasks

In this chapter, you'll move beyond simple scripts and
implement a proper API layer.
You'll work within the `wikipedia` package to
implement the API client logic, which
improves your application's scalability and maintainability.

### Task 1: Add the http dependency to the wikipedia package

To make HTTP requests, you need to
add the `http` package as a dependency to the `wikipedia` package.

1.  Open the `wikipedia/pubspec.yaml` file within your project.

1.  Locate the `dependencies` section.

1.  Add `http: ^1.3.0` (or the latest stable version) under `dependencies`.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

1.  Save the `pubspec.yaml` file.

1.  Run `dart pub get` in your terminal from the `wikipedia` directory.

### Task 2: Implement Wikipedia API calls

Next, you'll create the API functions to fetch data from Wikipedia.
You'll create three files:

- `summary.dart`:
  This file will contain functions for retrieving article summaries.
- `search.dart`:
  This file will handle search queries to find articles.
- `get_article.dart`:
  This file will contain functions for fetching the full content of an article.

1.  Create the directory `wikipedia/lib/src/api`.

1.  Create the file `wikipedia/lib/src/api/summary.dart`.

1.  Add the following code to `wikipedia/lib/src/api/summary.dart`:

    ```dart
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/summary.dart';

    Future<Summary> getRandomArticleSummary() async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/page/random/summary',
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Summary.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaDart.getRandomArticle] '
            'statusCode=${response.statusCode}, body=${response.body}',
          );
        }
      } on FormatException {
        // todo: log exceptions
        rethrow;
      } finally {
        client.close();
      }
    }

    Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/page/summary/$articleTitle',
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Summary.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaDart.getArticleSummary] '
            'statusCode=${response.statusCode}, body=${response.body}',
          );
        }
      } on FormatException {
        // todo: log exceptions
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    This code defines two functions:
    `getRandomArticleSummary` and `getArticleSummaryByTitle`.
    Both functions use the `http` package to
    make GET requests to the Wikipedia API and return a `Summary` object.
    `getRandomArticleSummary` fetches a summary for a random article, while
    `getArticleSummaryByTitle` fetches a summary for a specific article title.

1.  Next create the file `wikipedia/lib/src/api/search.dart`.

1.  Add the following code to `wikipedia/lib/src/api/search.dart`:

    ```dart

    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/search_results.dart';

    Future<SearchResults> search(String searchTerm) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/w/api.php',
          <String, Object?>{
            'action': 'opensearch',
            'format': 'json',
            'search': searchTerm,
          },
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final List<Object?> jsonData = jsonDecode(response.body) as List<Object?>;
          return SearchResults.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikimediaApiClient.getArticleByTitle] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
          );
        }
      } on FormatException {
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    This code defines the `search` function, which
    uses the `http` package to make a GET request to the Wikipedia API's
    `opensearch` endpoint and returns a `SearchResults` object.
    The `opensearch` endpoint is used to search for
    Wikipedia articles based on a search term.

1.  Create the file `wikipedia/lib/src/api/get_article.dart`.

1.  Add the following code to `wikipedia/lib/src/api/get_article.dart`:

    ```dart
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/article.dart';

    Future<List<Article>> getArticleByTitle(String title) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/w/api.php',
          <String, Object?>{
            // order matters - explaintext must come after prop
            'action': 'query',
            'format': 'json',
            'titles': title.trim(),
            'prop': 'extracts',
            'explaintext': '',
          },
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Article.listFromJson(jsonData);
        } else {
          throw HttpException(
            '[ApiClient.getArticleByTitle] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
          );
        }
      } on FormatException {
        // TODO: log
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    This code defines the `getArticleByTitle` function, which
    uses the `http` package to make a GET request to the Wikipedia API and
    returns a `List<Article>` object.
    This function retrieves the content of a
    Wikipedia article based on its title.

### Task 3: Export the API functions

Now that you've created the API functions,
you need to export them from the `wikipedia` library so that
they can be used by the `cli` package.
You'll also export the existing models.

1.  Open the `wikipedia/lib/wikipedia.dart` file.

1.  Add the following `export` statements to the file:

    ```dart
    export 'src/api/get_article.dart';
    export 'src/api/search.dart';
    export 'src/api/summary.dart';
    export 'src/model/article.dart';
    export 'src/model/search_results.dart';
    export 'src/model/summary.dart';
    export 'src/model/title_set.dart';
    ```

    These `export` statements make the API functions and models available to
    other packages that depend on the `wikipedia` package.


## Task 4: Verify with tests

Now that you have implemented the API functions and
updated the package dependencies, it's good practice to
run the tests you created in the previous chapter.
This will confirm that your changes have not
broken the existing functionality of the `wikipedia` package.

1.  Open your terminal and navigate to the `wikipedia/test` directory.

1.  Remove the default test file by running the command `rm wikipedia_test.dart`
    (on macOS or Linux) or `del wikipedia_test.dart` (on Windows).
    This file was generated automatically but is not used in our project.

1.  Open your terminal and navigate to the `wikipedia` directory.

1.  Run the command `dart test`.

    You should see output similar to this,
    confirming all your existing tests still pass:

    ```bash
    00:02 +3: All tests passed!
    This confirms that the wikipedia package is still working as expected.
    ```

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Constructed complex URIs with query parameters
    icon: link
    details: >-
      You used `Uri.https()` with a query parameter map to construct API URLs.
      This approach properly encodes special characters and
      handles complex query parameter combinations.
  - title: Created a production-ready API client
    icon: cloud_download
    details: >-
      You implemented a variety of functions that properly manage
      the HTTP client lifecycle with `try` and `finally`,
      and maps the raw JSON responses to typed Dart objects.
  - title: Exported functions and types for reuse
    icon: export_notes
    details: >-
      You added export statements in `wikipedia.dart` to
      expose both the API functions and data model types.
      This creates a public library that your
      `cli` package can import and use directly.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="fetch-data" />

## Next lesson

In the next lesson, you'll complete the CLI by
integrating the `wikipedia` package with the `cli` package.
You'll implement the command logic and display the results to the user.
