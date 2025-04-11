---
title: "Chapter 10: Testing"
description: "Learn about `package:test`, `group`, `test`, `expect`, and matchers."
---

# Chapter 10: Testing

Learn about `package:test`, `group`, `test`, `expect`, and matchers.

[Video Placeholder]

In this lesson, we'll introduce you to the world of testing in Dart. Testing is a crucial part of software development, ensuring that your code behaves as expected and remains reliable over time. We'll be using the `package:test`, a powerful and flexible testing framework for Dart. You'll learn how to write unit tests, group related tests, use `expect` to assert that values match your expectations, and leverage matchers for more complex assertions. By the end of this lesson, you'll be able to write effective tests for your Dart code and ensure its robustness.

## Background / Key Concepts
*   **`package:test`:** A Dart package that provides a framework for writing and running tests. It includes features for organizing tests, making assertions, and reporting results.
*   **Unit Tests:** Tests that focus on verifying the behavior of individual units of code, such as functions, methods, or classes.
*   **`group()`:** A function from `package:test` that allows you to group related tests together, providing a clear structure for your test suite.
*   **`test()`:** A function from `package:test` that defines an individual test case. Each test case should focus on verifying a specific aspect of your code's behavior.
*   **`expect()`:** A function from `package:test` that asserts that a value matches your expectations. It takes two arguments: the actual value and the expected value (or a matcher).
*   **Matchers:** Objects that define a set of criteria for matching values. `package:test` provides a variety of built-in matchers for common assertions, such as equality, inequality, string matching, and collection matching.

## Set up
Make sure you have completed Chapter 9 and have a working Dart project set up with the `cli`, `command_runner`, and `wikipedia` packages.

## Tasks
In this lesson, we'll add tests for the `Summary`, `TitleSet`, `Article`, and `SearchResults` classes in the `wikipedia` package. We'll use `group`, `test`, `expect`, and various matchers from the `package:test` to verify that the JSON deserialization methods in these classes are working correctly.

### Update `wikipedia/pubspec.yaml`

1.  Ensure that the `test` dependancy is present in the `dev_dependencies` section of the `wikipedia/pubspec.yaml` file.
```yaml
dev_dependencies:
  lints: ^5.0.0
  test: ^1.24.0
```
If you had to update this file, run `dart pub get` from the `wikipedia` directory.

### Add Tests to `model_test.dart`
1.  Open `wikipedia/test/model_test.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    import 'dart:convert';
    import 'dart:io';

    import 'package:test/test.dart';
    import 'package:wikipedia/src/model/article.dart';
    import 'package:wikipedia/src/model/search_results.dart';
    import 'package:wikipedia/src/model/summary.dart';

    const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
    const String catExtractJson = './test/test_data/cat_extract.json';
    const String openSearchResponse = './test/test_data/open_search_response.json';

    // [Step 10 update] adds all tests
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        test('deserialize Dart Programming Language page summary example data from '
            'json file into a Summary object', () async {
          final String pageSummaryInput =
              await File(dartLangSummaryJson).readAsString();
          final Map<String, Object?> pageSummaryMap =
              jsonDecode(pageSummaryInput) as Map<String, Object?>;
          final Summary summary = Summary.fromJson(pageSummaryMap);
          expect(summary.titles.canonical, 'Dart_(programming_language)');
        });

        test('deserialize Cat article example data from json file into '
            'an Article object', () async {
          final String articleJson = await File(catExtractJson).readAsString();
          final List<Object?> articleAsMap = jsonDecode(articleJson);
          final List<Article> article = Article.listFromJson(
            articleAsMap as Map<String, Object?>,
          );
          expect(article.first.title.toLowerCase(), 'cat');
        });

        test('deserialize Open Search results example data from json file '
            'into an SearchResults object', () async {
          final String resultsString =
              await File(openSearchResponse).readAsString();
          final List<Object?> resultsAsList =
              jsonDecode(resultsString) as List<Object?>;
          final SearchResults results = SearchResults.fromJson(resultsAsList);
          expect(results.results.length, greaterThan(1));
        });
      });
    }
    ```

3.  **Explanation:**

    *   **`import 'package:test/test.dart';`:** Imports the `package:test` library, providing access to the testing framework.
    *   **`group('deserialize example JSON responses from wikipedia API', () { ... });`:** Defines a group of tests related to deserializing JSON responses from the Wikipedia API. This helps organize the tests and provides a clear description of their purpose.
    *   **`test('deserialize Dart Programming Language page summary example data from ...', () async { ... });`:** Defines a test case for deserializing the Dart Programming Language page summary data. Each test case contains the following steps:
        *   **`final String pageSummaryInput = await File(dartLangSummaryJson).readAsString();`:** Reads the contents of the JSON file into a string.
        *   **`final Map<String, Object?> pageSummaryMap = jsonDecode(pageSummaryInput) as Map<String, Object?>;`:** Decodes the JSON string into a `Map<String, Object?>`.
        *   **`final Summary summary = Summary.fromJson(pageSummaryMap);`:** Deserializes the JSON data into a `Summary` object using the `Summary.fromJson` method.
        *   **`expect(summary.titles.canonical, 'Dart_(programming_language)');`:** Asserts that the `canonical` property of the `titles` object in the `Summary` object is equal to `'Dart_(programming_language)'`. This verifies that the JSON data was correctly deserialized.
    *   **`expect(article.first.title.toLowerCase(), 'cat');`:**  Asserts that the article title is "cat" (case-insensitive)
    *   **`expect(results.results.length, greaterThan(1));`:** Asserts that the search results contains more than one result

### Run the Tests
1.  Open your terminal or command prompt.

2.  Navigate to the root directory of the `wikipedia` package.

3.  Run the following command:

    ```bash
    dart test test/model_test.dart
    ```

    This command tells Dart to execute the tests defined in the `wikipedia/test/model_test.dart` file.

    You should see output similar to this:

    ```bash
    00:02 +3: All tests passed!
    ```

    This indicates that all three tests passed successfully.

[Pop out placeholder: Experiment with different matchers. For example, try using `expect(summary.pageid, isA<int>())` to assert that the `pageid` property is an integer.]

## Review

In this lesson, you learned how to:

*   Use the `package:test` to write unit tests in Dart.
*   Use the `group` function to organize related tests into logical groups.
*   Use the `test` function to define individual test cases.
*   Use the `expect` function to assert that values match your expectations.
*   Use various matchers from `package:test` to perform more complex assertions.

**Quiz Question:**

What is the purpose of the `expect` function in `package:test`?
*   [Option A] To define a group of related tests.
*   [Option B] To define an individual test case.
*   [Option C] To assert that a value matches your expectations.
*   [Option D] To import a package.

## Next lesson

In the next lesson, we'll implement the Wikipedia API calls and integrate them into our command-line application. We'll learn how to make HTTP requests, handle responses, and parse the data into our data model classes.