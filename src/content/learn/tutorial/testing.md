---
title: Test your app & code
shortTitle: Testing
description: >-
  Learn how to write tests for your Dart code
  using the `package:test` library.
layout: learn
---

In this chapter, you'll learn how to write tests for your Dart code.
Testing is crucial for ensuring that your application behaves
as expected and remains stable as you make changes.
You'll use the `package:test` library, a popular testing framework for Dart,
to write unit tests for the data models you created in the previous chapter.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Add the test package as a dev dependency
    icon: experiment
  - title: Write structured tests with the test package and matchers
    icon: lab_panel
  - title: Test JSON deserialization logic
    icon: fact_check
</SummaryCard>

## Prerequisites

Before you begin this chapter, ensure you:

-   Have completed Chapter 9 and have a
    working Dart development environment with the `dartpedia` project.
-   Are familiar with basic programming concepts like
    variables, functions, and control flow.
-   Understand the purpose of testing in software development.

## Tasks

In this chapter, you will add tests to the `wikipedia` package,
ensuring that the JSON deserialization logic for
your data models is working correctly.

### Task 1: Add the test dependency

First, you need to confirm that the `test` package is
already a development dependency in your project.

1.  Open the `wikipedia/pubspec.yaml` file within your project.
1.  Locate the `dev_dependencies` section.
1.  Verify that `test: ^1.24.0` (or the latest stable version) is
    present under `dev_dependencies`.

    ```yaml highlightLines=3
    dev_dependencies:
      lints: ^5.0.0
      test: ^1.24.0
    ```

    If the `test` dependency is missing, add it to your `pubspec.yaml` file.
    The `^` symbol allows compatible versions to be used.

1.  If you made any changes to the file, save `pubspec.yaml` and
    run `dart pub get` in your terminal from the `wikipedia` directory.
    This command fetches any newly added dependencies and
    makes them available for use in your project.

    You should see output similar to this:

    ```bash
    Resolving dependencies...
    Downloading packages...
    + test 1.25.1
    Changed 2 dependencies!
    ```

### Task 2: Create a test file and add imports

Next, create a test file for your data models and
add the necessary imports to it.

1.  Navigate to the `wikipedia/test` directory.
1.  Create a new file named `model_test.dart` in this directory.
1.  Open the `wikipedia/test/model_test.dart` file and
    add the following `import` statements at the top of the file:

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
    ```

    These lines import the `test` package, which provides
    the testing framework and the data model files you want to test.
    The constant strings declare the location of your sample data.

### Task 3: Create the test data files

The tests you need to write rely on local JSON files that
mimic the responses from the Wikipedia API.
You need to create a `test_data` directory and
populate it with three files.

1.  Navigate to the `wikipedia/test` directory.

1.  Create a new directory named `test_data`.

1.  Inside the `test_data` directory,
    create a new file named `dart_lang_summary.json` and
    paste the following content into it:

    ```json
    {
      "type": "standard",
      "title": "Dart (programming language)",
      "displaytitle": "<span class=\"mw-page-title-main\">Dart (programming language)</span>",
      "namespace": {
          "id": 0,
          "text": ""
      },
      "wikibase_item": "Q406009",
      "titles": {
        "canonical": "Dart_(programming_language)",
        "normalized": "Dart (programming language)",
        "display": "<span class=\"mw-page-title-main\">Dart (programming language)</span>"
      },
      "pageid": 33033735,
      "lang": "en",
      "dir": "ltr",
      "revision": "1259309990",
      "tid": "671bc7c6-aa67-11ef-aa2a-7c1da4fbe8fb",
      "timestamp": "2024-11-24T13:24:16Z",
      "description": "Programming language",
      "description_source": "local",
      "content_urls": {
        "desktop": {
          "page": "https://en.wikipedia.org/wiki/Dart_(programming_language)",
          "revisions": "https://en.wikipedia.org/wiki/Dart_(programming_language)?action=history",
          "edit": "https://en.wikipedia.org/wiki/Dart_(programming_language)?action=edit",
          "talk": "https://en.wikipedia.org/wiki/Talk:Dart_(programming_language)"
        },
        "mobile": {
          "page": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)",
          "revisions": "https://en.m.wikipedia.org/wiki/Special:History/Dart_(programming_language)",
          "edit": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)?action=edit",
          "talk": "https://en.m.wikipedia.org/wiki/Talk:Dart_(programming_language)"
        }
      },
      "extract": "Dart is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.",
      "extract_html": "<p><b>Dart</b> is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.</p>"
    }
    ```

1.  Next, create a file named `cat_extract.json`.
    This file is very long, so copy the contents from this link:
    https://github.com/ericwindmill/dash_getting_started/blob/main/dart_step_by_step/step_10/wikipedia/test/test_data/cat_extract.json

1.  Next, create a file named `open_search_response.json` and
    paste this content into it:

    ```json
    [
        "dart",
        [
            "Dart",
            "Darth Vader",
            "Dartmouth College",
            "Darts",
            "Darth Maul",
            "Dartford Crossing",
            "Dart (programming language)",
            "Dartmouth College fraternities and sororities",
            "Dartmoor",
            "Dartmouth, Massachusetts"
        ],
        [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        ],
        [
            "https://en.wikipedia.org/wiki/Dart",
            "https://en.wikipedia.org/wiki/Darth_Vader",
            "https://en.wikipedia.org/wiki/Dartmouth_College",
            "https://en.wikipedia.org/wiki/Darts",
            "https://en.wikipedia.org/wiki/Darth_Maul",
            "https://en.wikipedia.org/wiki/Dartford_Crossing",
            "https://en.wikipedia.org/wiki/Dart_(programming_language)",
            "https://en.wikipedia.org/wiki/Dartmouth_College_fraternities_and_sororities",
            "https://en.wikipedia.org/wiki/Dartmoor",
            "https://en.wikipedia.org/wiki/Dartmouth,_Massachusetts"
        ]
    ]
    ```

With these files in place, you're ready to write the tests that
will verify your data models.

### Task 4: Write tests for JSON deserialization

Now, you'll write tests for the JSON deserialization logic in your data models.
You'll use the `group`, `test`, and `expect` functions from the `test` package.

1.  Use the `group` function to group related tests together.
    Add the following to your `wikipedia/test/model_test.dart` file:

    ```dart
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        // Tests will go here
      });
    }
    ```

    The `group` function takes a description of the group and a
    callback function that contains the tests.

1.  Create a test for the `Summary` model.
    Add the following `test` function inside the `group` function:

    ```dart
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
      });
    }
    ```

    This `test` function does the following:

    -   Reads the contents of the `dart_lang_summary.json` file.
    -   Decodes the JSON string into a `Map<String, Object?>`.
    -   Creates a `Summary` object from the map using
        the `Summary.fromJson` constructor.
    -   Uses the `expect` function to assert that the
        `canonical` property of the `titles` object is
        equal to `'Dart_(programming_language)'`.

    The `expect` function takes a value and a matcher.
    The matcher is used to assert that the value meets certain criteria.
    In this case, the `equals` matcher is used to
    assert that the value is equal to a specific string.

1.  Create a test for the `Article` model.
    Add the following `test` function inside
    the `group` function, after the previous test:

    ```dart
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
          final Map<String, Object?> articleMap =
              jsonDecode(articleJson) as Map<String, Object?>;
          final List<Article> articles = Article.listFromJson(articleMap);
          expect(articles.first.title.toLowerCase(), 'cat');
        });
      });
    }
    ```

    This `test` function does the following:

    -   Reads the contents of the `cat_extract.json` file.
    -   Decodes the JSON string into a `Map<String, Object?>`.
    -   Creates the `List<Article>` object from the map using
        the `Article.listFromJson` static method.
    -   Uses the `expect` function to assert that
        the `title` property of the first article is equal to `'cat'`.

1.  Create a test for the `SearchResults` model.
    Add the following `test` function inside the `group` function,
    after the previous test:

    ```dart
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
          final Map<String, Object?> articleMap =
              jsonDecode(articleJson) as Map<String, Object?>;
          final List<Article> articles = Article.listFromJson(articleMap);
          expect(articles.first.title.toLowerCase(), 'cat');
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

    This `test` function does the following:

    -   Reads the contents of the `open_search_response.json` file.
    -   Decodes the JSON string into a `List<Object?>`.
    -   Creates a `SearchResults` object from the list using
        the `SearchResults.fromJson` constructor.
    -   Uses the `expect` function to assert that
        the `results` list has a length greater than `1`.

### Task 5: Run the tests

Now that you've written the tests, you can run them to verify that they pass.

1.  Open your terminal and navigate to the `wikipedia` directory.
1.  Run the command `dart test`.

    You should see output similar to this:

    ```bash
    00:02 +4: All tests passed!
    ```

    This confirms that all three tests are passing.

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Added the test package as a dev dependency
    icon: experiment
    details: >-
      You added `test` as a dev dependency in `pubspec.yaml` and
      created test files in the `test/` directory.
      Pub dev dependencies are intended for use during
      development and testing, not during production.
      As a result, they can't be used in the `lib` directory.
  - title: Wrote structured tests with the test package and matchers
    icon: lab_panel
    details: >-
      You used `group()` to organize related tests,
      `test()` to define individual test cases, and `expect()` with
      matchers like `equals` and `greaterThan` to assert expected behavior.
      Running `dart test` executes all tests declared by your package.
  - title: Tested JSON deserialization logic
    icon: fact_check
    details: >-
      You created test data files with sample JSON and wrote tests to verify
      that your `fromJson` methods correctly parse the data into Dart objects.
      This ensures your models handle real API responses properly.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="testing" />

## Next lesson

In the next lesson, you'll implement
the Wikipedia API calls in your `dartpedia` application.
You'll use the `http` package to
fetch data from the Wikipedia API and display it to the user.
