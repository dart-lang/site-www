---
title: Fetch data from the internet
shortTitle: HTTP requests
description: >-
  Refactor your application to use a robust, production-ready
  API client for the Wikipedia CLI.
layout: learn
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

-   Have completed Chapter 11 and have a
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

    ```yaml title="wikipedia/pubspec.yaml"
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

    ```dart title="wikipedia/lib/src/api/summary.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/summary.dart';

    Future<Summary> getRandomArticleSummary() async {
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/random/summary',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData =
            jsonDecode(response.body) as Map<String, Object?>;
        return Summary.fromJson(jsonData);
      } else {
        throw HttpException(
          '[WikipediaApiClient.getRandomArticleSummary] '
          'statusCode=${response.statusCode}, body=${response.body}',
        );
      }
    }

    Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData =
            jsonDecode(response.body) as Map<String, Object?>;
        return Summary.fromJson(jsonData);
      } else {
        throw HttpException(
          '[WikipediaApiClient.getArticleSummaryByTitle] '
          'statusCode=${response.statusCode}, body=${response.body}',
        );
      }
    }
    ```

    This code defines two functions,
    `getRandomArticleSummary` and `getArticleSummaryByTitle`,
    that build on the basic HTTP request you wrote in Chapter 3:

    - **`getRandomArticleSummary` and `getArticleSummaryByTitle`:**
      Fetch a random article summary or a specific summary by interpolating
      `articleTitle` into the endpoint path.
    - **Typed JSON parsing:**
      Instead of returning a raw JSON string, both functions decode
      `response.body` with `jsonDecode` and pass the map to
      `Summary.fromJson` to return a strongly typed `Summary` object.
    - **Explicit failure handling:**
      When `response.statusCode` isn't `200`, the functions throw an
      `HttpException` (from `dart:io`) rather than returning an error string,
      so callers can catch and handle failed requests with `try`/`catch`.

1.  Next create the file `wikipedia/lib/src/api/search.dart`.

1.  Add the following code to `wikipedia/lib/src/api/search.dart`:

    ```dart title="wikipedia/lib/src/api/search.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/search_results.dart';

    Future<SearchResults> search(String searchTerm) async {
      final Uri url = Uri.https(
        'en.wikipedia.org',
        '/w/api.php',
        <String, Object?>{
          'action': 'opensearch',
          'format': 'json',
          'search': searchTerm,
        },
      );
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Object?> jsonData =
            jsonDecode(response.body) as List<Object?>;
        return SearchResults.fromJson(jsonData);
      } else {
        throw HttpException(
          '[WikipediaApiClient.search] '
          'statusCode=${response.statusCode}, '
          'body=${response.body}',
        );
      }
    }
    ```

    This code defines the `search` function, which queries Wikipedia's
    `opensearch` endpoint and returns a `SearchResults` object:

    - **Query parameters:**
      `Uri.https` accepts an optional third argument—a `Map` of query
      parameters (`action`, `format`, and `search`).
      Dart automatically formats these key-value pairs onto the URL and
      URL-encodes special characters like spaces in `searchTerm`.
    - **List decoding:**
      Because the `opensearch` endpoint returns a top-level JSON array,
      `jsonDecode(response.body)` is cast to `List<Object?>` before passing
      it to `SearchResults.fromJson`.

1.  Create the file `wikipedia/lib/src/api/get_article.dart`.

1.  Add the following code to `wikipedia/lib/src/api/get_article.dart`:

    ```dart title="wikipedia/lib/src/api/get_article.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/article.dart';

    Future<List<Article>> getArticleByTitle(String title) async {
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
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData =
            jsonDecode(response.body) as Map<String, Object?>;
        return Article.listFromJson(jsonData);
      } else {
        throw HttpException(
          '[WikipediaApiClient.getArticleByTitle] '
          'statusCode=${response.statusCode}, '
          'body=${response.body}',
        );
      }
    }
    ```

    This code defines `getArticleByTitle`, which passes query parameters to
    `/w/api.php` (using `title.trim()` to strip accidental leading or trailing
    whitespace) and parses the response into a `List<Article>` using
    `Article.listFromJson`.

### Task 3: Export the API functions

Now that you've created the API functions,
export them and your existing models from the `wikipedia` library
so that the `cli` package can import and use them.

1.  Open the `wikipedia/lib/wikipedia.dart` file.

1.  Replace the generated placeholder code in the file with the following
    `export` statements:

    ```dart title="wikipedia/lib/wikipedia.dart"
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

### Task 4: Verify with tests

Now that you've implemented the API functions and
updated the package dependencies,
run the tests you created in the previous chapter to confirm that
your changes haven't broken existing functionality in `wikipedia`.

1.  Open your terminal and navigate to the `wikipedia/test` directory.

1.  Remove the default test file by running `rm wikipedia_test.dart`
    (on macOS or Linux) or `del wikipedia_test.dart` (on Windows).
    `dart create` generated this file automatically to test the placeholder
    code you just replaced, so your project no longer needs it.

1.  Navigate back to the `wikipedia` directory.

1.  Run `dart test`.

    You'll see output similar to the following,
    confirming that all your model tests pass:

    ```bash
    00:02 +3: All tests passed!
    ```

    This confirms that the `wikipedia` package is working as expected.

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
      You implemented API functions that check HTTP status codes,
      throw an `HttpException` on failed requests, and
      map raw JSON responses to typed Dart objects.
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

In the next lesson, you'll complete your CLI application by
integrating the `wikipedia` package commands with the `cli` package
and adding logging for debugging and error monitoring.

