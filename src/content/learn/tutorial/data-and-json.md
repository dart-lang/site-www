---
title: Work with JSON data
shortTitle: Data and JSON
description: >-
  Learn about JSON deserialization in Dart, including how to
  use `dart:convert`, `jsonDecode`, and pattern matching to
  work with JSON data from the Wikipedia API.
layout: learn
---

In this chapter, you learn how to work with
[JSON (JavaScript Object Notation)][] data in Dart.
You create data models to represent Wikipedia API responses,
use `dart:convert` to decode JSON text into Dart collections, and
use pattern matching to extract and validate data.

<SummaryCard>
title: What you'll accomplish
items:
  - title: Understand JSON handling in Dart
    icon: convert_to_text
  - title: Set up a multi-package workspace
    icon: workspaces
  - title: Create data model classes for JSON data
    icon: data_object
  - title: Use pattern matching in fromJson constructors
    icon: bento
</SummaryCard>

[JSON (JavaScript Object Notation)]:  https://en.wikipedia.org/wiki/JSON
[`dart:convert` library]: {{site.dart-api}}/dart-convert

## Prerequisites

Before you begin this chapter, ensure you:

- Have completed Chapter 8 and have a
  working Dart development environment with the `dartpedia` project.
- Understand basic Dart syntax, including [classes][] and data types.

[classes]: /language/classes

## How Dart handles JSON

JSON is a text-based format for
representing structured data such as objects, arrays, numbers, and strings.
When you interact with web APIs, responses arrive as JSON strings.

In Dart, converting a JSON string into a strongly-typed data model
involves two steps:

1.  **Decode the JSON string into Dart collections.**
    The [`dart:convert` library][] provides the `jsonDecode()` function,
    which parses a raw JSON string into a standard Dart collection:
    - A JSON object (`{...}`) becomes a `Map<String, dynamic>`.
    - A JSON array (`[...]`) becomes a `List<dynamic>`.

    ```dart
    import 'dart:convert';

    const String jsonString = '{"title": "Dart", "pageid": 12345}';

    // jsonDecode parses the string into a Map<String, dynamic>
    final Map<String, Object?> jsonMap =
        jsonDecode(jsonString) as Map<String, Object?>;
    ```

1.  **Convert the decoded collections into custom model objects.**
    While you can read values directly from a `Map` (like `jsonMap['title']`),
    using raw maps throughout your application lacks type safety,
    invites typos, and provides no IDE autocompletion.

    To solve this, Dart applications define data model classes with
    `factory` constructors, conventionally named `fromJson`, that
    instantiate typed objects from decoded maps:

    ```dart
    class ArticleSummary {
      final String title;
      final int pageid;

      ArticleSummary({required this.title, required this.pageid});

      factory ArticleSummary.fromJson(Map<String, Object?> json) {
        return ArticleSummary(
          title: json['title'] as String,
          pageid: json['pageid'] as int,
        );
      }
    }
    ```

Dart also supports [pattern matching][] in `fromJson` constructors,
allowing you to validate the shape of the JSON map and
extract values in a single, concise step.

## Tasks

The following tasks set up a multi-package workspace and
create the data model classes for Wikipedia API responses.

### Task 1: Create the Wikipedia package

First, create a new Dart package to house the data models.

1.  Navigate to the root directory of your project (`/dartpedia`).
1.  Run the following command in your terminal:

    ```bash
    dart create wikipedia
    ```

    This command creates a new directory named `wikipedia` with
    the basic structure of a Dart package.
    You should now see a new folder `wikipedia` in your project root,
    alongside `cli` and `command_runner`.

### Task 2: Configure a Dart workspace

Dart workspaces allow you to
manage multiple related packages within a single project,
simplifying dependency management and local development.
Now that you're adding your third package,
it's a good time to configure your project to use a Dart workspace.

1.  **Create the root `pubspec.yaml` file.**

    Navigate to the root directory of your project (`/dartpedia`) and
    create a new file named `pubspec.yaml` with the following content:

    ```yaml
    name: _
    publish_to: none

    environment:
      sdk: ^3.8.1 # IMPORTANT: Adjust this to match your Dart SDK version or a compatible range
    workspace:
      - cli
      - command_runner
      - wikipedia
    ```

1.  **Add workspace resolution to sub-packages.**

    For each of your sub-packages (`cli`, `command_runner`, and `wikipedia`),
    open their respective `pubspec.yaml` files and
    add `resolution: workspace` to `pubspec.yaml`.
    This tells Dart to resolve dependencies within the workspace.

    -   For `cli/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: cli
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    -   For `command_runner/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: command_runner
        description: A starting point for Dart libraries or applications.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    -   For `wikipedia/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: wikipedia
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

1.  **Resolve workspace dependencies.**

    Run `dart pub get` in your project root to
    resolve dependencies across all packages in the workspace:

    ```bash
    dart pub get
    ```

### Task 3: Create the Summary class

The Wikipedia API returns a JSON object containing a summary of an article.
A typical response from the page summary endpoint looks like this:

```json
{
  "titles": {
    "canonical": "Dart_(programming_language)",
    "normalized": "Dart (programming language)",
    "display": "Dart (programming language)"
  },
  "pageid": 37194605,
  "extract": "Dart is a client-optimized language for fast apps...",
  "extract_html": "<p><b>Dart</b> is a client-optimized language...</p>",
  "lang": "en",
  "dir": "ltr",
  "content_urls": {
    "desktop": {
      "page": "https://en.wikipedia.org/wiki/Dart_(programming_language)"
    },
    "mobile": {
      "page": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)"
    }
  },
  "description": "Programming language"
}
```

Create a Dart class to represent this summary.

1.  Create the directory `wikipedia/lib/src/model`.

    ```bash
    mkdir -p wikipedia/lib/src/model
    ```

1.  Create the file `wikipedia/lib/src/model/summary.dart`.

1.  Add the following code to `wikipedia/lib/src/model/summary.dart`:

    ```dart title="wikipedia/lib/src/model/summary.dart"
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

      /// Creates a [Summary] instance from a JSON map.
      factory Summary.fromJson(Map<String, Object?> json) {
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

    This code defines a `Summary` class to represent the fields returned
    by the Wikipedia summary endpoint:

    * **`fromJson` pattern matching:** While you can access map keys
      individually with manual casting (such as `json['pageid'] as int`),
      the `fromJson` factory constructor uses [pattern matching][] to
      validate the structure, confirm types, and extract values in a single
      declarative expression.
    * **`switch` expression:** Provides two cases to handle Wikipedia's
      optional `description` field: one that extracts it when present,
      and a fallback case that matches when it is omitted.
    * **`toString`:** Provides a readable string representation of
      the `Summary` object for debugging.

    :::note
    Your editor might flag `import 'title_set.dart'` and `TitlesSet`
    as unresolved references until you create `TitlesSet` in Task 4.
    :::

[pattern matching]: /language/patterns

### Task 4: Create the TitleSet class

The `Summary` class uses a `TitlesSet` class to represent the title information.
Create that class next.

1.  Create the file `wikipedia/lib/src/model/title_set.dart`.

1.  Add the following code to `wikipedia/lib/src/model/title_set.dart`:

    ```dart title="wikipedia/lib/src/model/title_set.dart"
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

      /// Creates a [TitlesSet] instance from a JSON map.
      factory TitlesSet.fromJson(Map<String, Object?> json) {
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

    This code defines a `TitlesSet` class to hold the title variants
    returned by the Wikipedia API.
    Unlike `Summary`, which uses a `switch` expression for optional fields,
    `TitlesSet` has a fixed structure and validates all three fields at once
    using an `if case` statement.
    If the JSON map does not match the pattern, it throws a
    `FormatException`.

### Task 5: Create the Article class

The Wikipedia API also returns a list of articles in a search result.
Create a Dart class to represent an article.

1.  Create the file `wikipedia/lib/src/model/article.dart`.

1.  Add the following code to `wikipedia/lib/src/model/article.dart`:

    ```dart title="wikipedia/lib/src/model/article.dart"
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

    This code defines an `Article` class to represent an article's
    title and extract:

    * **`listFromJson`:** Unlike previous models that create a single instance,
      the Wikipedia search endpoint returns multiple articles in a map.
      Dart constructors only return a single instance, so `Article` uses
      a `static` method named `listFromJson` to return a `List<Article>`.
    * **Object pattern destructuring:** The `for` loop uses
      `final MapEntry(:value)` to extract each entry's value directly
      without manual property access.
    * **`toJson`:** Converts an `Article` instance back into a JSON map.
      In Dart convention, `toJson()` returns a `Map<String, Object?>`
      that you can pass to `jsonEncode()` from `dart:convert`
      when serializing an object to a JSON string.

### Task 6: Create the SearchResults class

Finally, create a class to represent search results from the Wikipedia API.
The Wikipedia search endpoint returns an array containing the search term,
article titles, descriptions (which are ignored), and URLs:

```json
[
  "dart",
  ["Dart (programming language)", "Dart"],
  ["", ""],
  [
    "https://en.wikipedia.org/wiki/Dart_(programming_language)",
    "https://en.wikipedia.org/wiki/Dart"
  ]
]
```

1.  Create the file `wikipedia/lib/src/model/search_results.dart`.
1.  Add the following code to `wikipedia/lib/src/model/search_results.dart`:

    ```dart title="wikipedia/lib/src/model/search_results.dart"
    class SearchResult {
      SearchResult({required this.title, required this.url});
      final String title;
      final String url;
    }

    class SearchResults {
      SearchResults(this.results, {this.searchTerm});
      final List<SearchResult> results;
      final String? searchTerm;

      /// Creates a [SearchResults] instance from a JSON list.
      factory SearchResults.fromJson(List<Object?> json) {
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

    This code defines two classes: `SearchResult` to hold an individual
    article's title and URL, and `SearchResults` to hold the list of
    results along with the search query:

    * **`fromJson` with `List<Object?>`:** The constructor accepts
      a `List<Object?>` rather than a `Map<String, Object?>` to match
      the top-level JSON array returned by Wikipedia's search API.
    * **List pattern matching:** The `if case` statement uses a list pattern
      `[...]` to match the array positionally and extract each section.
    * **Wildcard pattern (`_`):** The `Iterable _` pattern matches and
      discards the descriptions array, which your application does not need.

You now have typed data models to represent Wikipedia API responses.
In upcoming chapters, you use `package:test` to test
how data is deserialized and use `package:http` to fetch
live JSON data from the API.

## Review

<SummaryCard>
title: What you accomplished
subtitle: Here's a summary of what you built and learned in this lesson.
completed: true
items:
  - title: Understood JSON handling in Dart
    icon: convert_to_text
    details: >-
      You explored how `dart:convert` and `jsonDecode()`
      parse JSON strings into Dart collections (`Map` and `List`), and
      why typed models with `fromJson` factory constructors are preferred
      over raw maps.
  - title: Set up a pub workspace
    icon: workspaces
    details: >-
      To simplify dependency management for your multi-package project,
      you created a new pub workspace.
      To do so, you created a root `pubspec.yaml` file with
      a `workspace:` section listing your packages, then
      added `resolution: workspace` to each sub-package.
  - title: Created data model classes for JSON
    icon: data_object
    details: >-
      You built `Summary`, `TitlesSet`, `Article`, and `SearchResults` classes
      to represent Wikipedia API responses.
      These typed models provide compile-time safety and
      IDE support when working with API data.
  - title: Used pattern matching in fromJson factory constructors
    icon: bento
    details: >-
      You implemented `fromJson` factory constructors using Dart's pattern
      matching with `switch` expressions and `if case` statements.
      This structure validates the JSON shape and
      extracts values in concise, readable expressions.
</SummaryCard>

## Quiz

<Quiz title="Check your understanding" id="data-and-json" />

## Next lesson

In the next lesson, learn how to
test your Dart code using the `package:test` library.
Write tests to verify that your
JSON deserialization logic works correctly.
