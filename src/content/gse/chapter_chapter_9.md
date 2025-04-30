---
title: "Chapter 9: Data and JSON"
description: "Learn about JSON deserialization, `dart:convert`, `jsonDecode`, and pattern matching."
---

# Chapter 9: Data and JSON
Learn about JSON deserialization, `dart:convert`, `jsonDecode`, and pattern matching.

[Video Placeholder]

In this lesson, you'll learn how to handle JSON data in Dart, which is essential for working with web APIs like the Wikipedia API. We'll cover how to deserialize JSON strings into Dart objects using `dart:convert` and `jsonDecode`, and how to use pattern matching to safely extract data from JSON structures. We'll be adding `Summary`, `TitleSet`, `Article`, `SearchResults` classes in `wikipedia/lib/src/model/`. By the end of this lesson, you'll be able to parse JSON responses from the Wikipedia API and represent the data in Dart objects.

## Background / Key Concepts
*   **JSON (JavaScript Object Notation):** A lightweight data-interchange format that is easy for humans to read and write and easy for machines to parse and generate. It is commonly used for transmitting data in web APIs.
*   **`dart:convert`:** A built-in Dart library that provides converters for working with various data formats, including JSON.
*   **`jsonDecode()`:** A function from `dart:convert` that parses a JSON string and returns a corresponding Dart object (typically a `Map` or a `List`).
*   **Pattern Matching:** A powerful feature in Dart that allows you to destructure data and extract values based on specific patterns. It's particularly useful for working with JSON data, as it provides a concise and type-safe way to access nested values.

## Set up
Make sure you have completed Chapter 8.1 and have a working Dart project set up with the `cli`, `command_runner`, and `wikipedia` packages.

## Tasks
In this lesson, we'll define data models for representing Wikipedia API responses in the `wikipedia` package. We'll create classes for `Summary`, `TitleSet`, `Article`, and `SearchResults`, and implement methods for deserializing JSON data into these objects.

### Create `TitleSet` Class
1.  Create a new file named `title_set.dart` inside `wikipedia/lib/src/model/` directory.

2.  Add the following code to the file:

    ```dart
    class TitlesSet {
      /// Returns a new [TitlesSet] instance.
      TitlesSet({
        required this.canonical,
        required this.normalized,
        required this.display,
      });

      /// the DB key (non-prefixed), e.g. may have _ instead of spaces,
      /// best for making request URIs, still requires Percent-encoding
      String canonical;

      /// the normalized title (https://www.mediawiki.org/wiki/API:Query#Example_2:_Title_normalization),
      /// e.g. may have spaces instead of _
      String normalized;

      /// the title as it should be displayed to the user
      String display;

      /// Returns a new [TitlesSet] instance and imports its values from a JSON map
      static TitlesSet fromJson(Map<String, Object?> json) {
        if (json case {
          'canonical': final String canonical,
          'normalized': final String normalized,
          'display': final String display,
        }) {
          return TitlesSet(
            canonical: canonical,
            normalized: normalized,
            display: display,
          );
        }
        throw FormatException('Could not deserialize TitleSet, json=$json');
      }

      @override
      String toString() =>
          'TitlesSet['
          'canonical=$canonical, '
          'normalized=$normalized, '
          'display=$display'
          ']';
    }
    ```

3.  **Explanation:**
    *   This code defines a `TitlesSet` class with three `String` properties: `canonical`, `normalized`, and `display`.
    *   The `fromJson` method takes a `Map<String, Object?>` (representing a JSON object) as input and uses pattern matching to extract the values for the `canonical`, `normalized`, and `display` properties.
    *   If the JSON object matches the expected pattern, a new `TitlesSet` instance is created and returned.
    *   If the JSON object does not match the expected pattern, a `FormatException` is thrown, indicating that the JSON data could not be deserialized.
    *   The `toString` method provides a human-readable string representation of the `TitlesSet` object.

### Create `Summary` Class
1.  Create a new file named `summary.dart` inside `wikipedia/lib/src/model/` directory.

2.  Add the following code to the file:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */
    import 'title_set.dart';

    class Summary {
      /// Returns a new [Summary] instance.
      Summary({
        required this.titles,
        required this.pageid,
        required this.extract,
        required this.extractHtml,
        required this.lang,
        required this.dir,
        this.url,
        this.description,
      });

      ///
      TitlesSet titles;

      /// The page ID
      int pageid;

      /// First several sentences of an article in plain text
      String extract;

      /// First several sentences of an article in simple HTML format
      String extractHtml;

      /// Url to the article on Wikipedia
      String? url;

      /// The page language code
      String lang;

      /// The page language direction code
      String dir;

      /// Wikidata description for the page
      String? description;

      /// Returns a new [Summary] instance
      static Summary fromJson(Map<String, Object?> json) {
        return switch (json) {
          {
            'titles': final Map<String, Object?> titles,
            'pageid': final int pageid,
            'extract': final String extract,
            'extract_html': final String extractHtml,
            'lang': final String lang,
            'dir': final String dir,
            'content_urls': {
              'desktop': {'page': final String url},
              'mobile': {'page': String _},
            },
            'description': final String description,
          } =>
            Summary(
              titles: TitlesSet.fromJson(titles),
              pageid: pageid,
              extract: extract,
              extractHtml: extractHtml,
              lang: lang,
              dir: dir,
              url: url,
              description: description,
            ),
          {
            'titles': final Map<String, Object?> titles,
            'pageid': final int pageid,
            'extract': final String extract,
            'extract_html': final String extractHtml,
            'lang': final String lang,
            'dir': final String dir,
            'content_urls': {
              'desktop': {'page': final String url},
              'mobile': {'page': String _},
            },
          } =>
            Summary(
              titles: TitlesSet.fromJson(titles),
              pageid: pageid,
              extract: extract,
              extractHtml: extractHtml,
              lang: lang,
              dir: dir,
              url: url,
            ),
          _ => throw FormatException('Could not deserialize Summary, json=$json'),
        };
      }

      @override
      String toString() =>
          'Summary['
          'titles=$titles, '
          'pageid=$pageid, '
          'extract=$extract, '
          'extractHtml=$extractHtml, '
          'lang=$lang, '
          'dir=$dir, '
          'description=$description'
          ']';
    }
    ```

3.  **Explanation:**
    *   This code defines a `Summary` class with properties for representing a Wikipedia article summary.
    *   The `fromJson` method takes a `Map<String, Object?>` (representing a JSON object) as input and uses pattern matching with a switch statement to extract the values for the `titles`, `pageid`, `extract`, `extractHtml`, `lang`, `dir`, `url`, and `description` properties.
    *   Note the use of nested pattern matching to access values within the `content_urls` map.  Because the description wasn't always present, it required a second case in the switch statement.
    *   If the JSON object matches the expected pattern, a new `Summary` instance is created and returned.
    *   If the JSON object does not match the expected pattern, a `FormatException` is thrown, indicating that the JSON data could not be deserialized.
    *   The `toString` method provides a human-readable string representation of the `Summary` object.

### Create `Article` Class

1.  Create a new file named `article.dart` inside `wikipedia/lib/src/model/` directory.

2.  Add the following code to the file:

    ```dart
    class Article {
      Article({required this.title, required this.extract});

      final String title;
      final String extract;

      static List<Article> listFromJson(Map<String, Object?> json) {
        final List<Article> articles = <Article>[];
        if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
          for (final MapEntry<String, Object?>(:Object? value) in pages.entries) {
            if (value case {
              'title': final String title,
              'extract': final String extract,
            }) {
              articles.add(Article(title: title, extract: extract));
            }
          }
          return articles;
        }
        throw FormatException('Could not deserialize Article, json=$json');
      }

      Map<String, Object?> toJson() => <String, Object?>{
        'title': title,
        'extract': extract,
      };

      @override
      String toString() {
        return 'Article{title: $title, extract: $extract}';
      }
    }
    ```

3.  **Explanation:**
    *   This code defines an `Article` class with `title` and `extract` properties.
    *   The `listFromJson` method takes a `Map<String, Object?>` as input and uses pattern matching to extract a list of articles from the JSON data.
    *    For loops are used to iterate over the maps.\
    *   If the JSON data does not match the expected pattern, a `FormatException` is thrown.

### Create `SearchResults` Class
1.  Create a new file named `search_results.dart` inside `wikipedia/lib/src/model/` directory.

2.  Add the following code to the file:

    ```dart
    class SearchResult {
      SearchResult({required this.title, required this.url});
      final String title;
      final String url;
    }

    class SearchResults {
      SearchResults(this.results, {this.searchTerm});
      final List<SearchResult> results;
      final String? searchTerm;

      static SearchResults fromJson(List<Object?> json) {
        final List<SearchResult> results = <SearchResult>[];
        if (json case [
          String searchTerm,
          Iterable articleTitles,
          Iterable _,
          Iterable urls,
        ]) {
          final List titlesList = articleTitles.toList();
          final List urlList = urls.toList();
          for (int i = 0; i < articleTitles.length; i++) {
            results.add(SearchResult(title: titlesList[i], url: urlList[i]));
          }
          return SearchResults(results, searchTerm: searchTerm);
        }
        throw FormatException('Could not deserialize SearchResults, json=$json');
      }

      @override
      String toString() {
        final StringBuffer pretty = StringBuffer();
        for (final SearchResult result in results) {
          pretty.write('${result.url} \n');
        }
        return '\nSearchResults for $searchTerm: \n$pretty';
      }
    }
    ```

3.  **Explanation:**
    *   This code defines a `SearchResult` class with `title` and `url` properties.
    *   It also defines a `SearchResults` class, with a List of `SearchResult` and a `searchTerm` to display in the CLI
    *   The `fromJson` method takes a `List<Object?>` as input and uses pattern matching to extract a list of articles from the JSON data.
    *   For loops are used to iterate over the lists.
    *   If the JSON data does not match the expected pattern, a `FormatException` is thrown.

### Update `wikipedia/lib/wikipedia.dart`
1.  Open `wikipedia/lib/wikipedia.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    int calculate() {
      return 6 * 7;
    }
    ```

    Because we won't be using it, feel free to remove this file and the `calculate` method from the project.

### Update `wikipedia/pubspec.yaml`
1.  Open `wikipedia/pubspec.yaml` in your code editor.

2.  Add the following dependancy to the file:

    ```yaml
    dependencies:
      # path: ^1.8.0
    ```
    To:
    ```yaml
    dependencies:
      # path: ^1.8.0
      http: ^1.3.0
    ```

### Update `wikipedia/lib/src/wikipedia.dart`

1.  Create `wikipedia/lib/src/wikipedia.dart` in your code editor.

2.  Leave the file blank, but create it anyway, so that the dependancy in `cli` resolves.

### Test your Data Models
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

3.  Create test data in `wikipedia/test/test_data/`

    * `cat_extract.json`
        ```json
        {
          "batchcomplete": "",
          "query": {
            "normalized": [
              {
                "from": "cat",
                "to": "Cat"
              }
            ],
            "pages": {
              "6678": {
                "pageid": 6678,
                "ns": 0,
                "title": "Cat",
                "extract": "The cat (Felis catus), also referred to as the domestic cat, is a small domesticated carnivorous mammal."
              }
            }
          }
        }
        ```
    * `dart_lang_summary.json`
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
    * `open_search_response.json`
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

4.  **Explanation:**
    *   This code imports the `test` package and defines a group of tests for deserializing JSON responses from the Wikipedia API.
    *   Each test reads the contents of a JSON file, decodes it using `jsonDecode`, and then calls the corresponding `fromJson` or `listFromJson` method to deserialize the data into a Dart object.
    *   The `expect` function is used to assert that the deserialized object has the expected properties.
5. Run `dart test wikipedia/test/model_test.dart`

### Add Exports
1.  Add the following `export` to `wikipedia/lib/wikipedia.dart`
    ```dart
    export 'src/model/summary.dart';
    export 'src/model/title_set.dart';
    export 'src/model/search_results.dart';
    export 'src/model/article.dart';
    ```

### Update `cli/pubspec.yaml` to depend on `wikipedia`
1.  Open `cli/pubspec.yaml` in your code editor.

2.  Add a dependency on the `wikipedia` package in the `dependencies` section. Since `wikipedia` is part of the same workspace, we can use a `path` dependency.

    ```yaml
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
    ```
    To:
    ```yaml
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
      wikipedia:
        path: ../wikipedia
    ```

    This tells Dart that the `cli` package depends on the `wikipedia` package, and that the `wikipedia` package can be found in the `../wikipedia` directory (relative to the `cli/pubspec.yaml` file).

3.  Run `dart pub get` in your terminal from the `cli` directory to update the dependencies.

## Review
In this lesson, you learned how to:
*   Create Dart classes to represent data from a JSON API.
*   Use the `dart:convert` library to decode JSON strings into Dart objects.
*   Use pattern matching to safely extract values from JSON data.

**Quiz Question:**
What function is used to parse a JSON string in Dart?
*   [Option A] `jsonEncode()`
*   [Option B] `jsonStringify()`
*   [Option C] `jsonDecode()`
*   [Option D] `jsonParse()`

## Next lesson
In the next lesson, we'll write unit tests for these data model classes and the utility functions to ensure the proper functionality of the program.