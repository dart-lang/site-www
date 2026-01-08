---
title: Work with JSON data
shortTitle: Data and JSON
description: >-
  Learn about JSON deserialization in Dart, including how to
  use `dart:convert`, `jsonDecode`, and pattern matching to
  work with JSON data from the Wikipedia API.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /learn/tutorial/cli-polish
  title: Polish your CLI app
nextpage:
  url: /learn/tutorial/testing
  title: Test your app & code
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll learn how to work with
[JSON (JavaScript Object Notation)][] data in Dart.
JSON is a common format for data exchange on the web, and
you'll often encounter it when working with APIs.
You'll learn how to convert JSON data into Dart objects,
making it easier to work with in your application.
You'll use the [`dart:convert` library][],
the `jsonDecode` function, and pattern matching.

:::secondary What you'll learn

*  Deserialize JSON data into Dart objects.
*  Use the `dart:convert` library to work with JSON.
*  Use the `jsonDecode` function to parse JSON strings.
*  Use pattern matching to extract data from JSON objects.
*  Create Dart classes to represent JSON data structures.

:::

[JSON (JavaScript Object Notation)]:  https://en.wikipedia.org/wiki/JSON
[`dart:convert` library]: {{site.dart-api}}/dart-convert

## Prerequisites

Before you begin this chapter, ensure you:

* Have completed Chapter 8 and have a
  working Dart development environment with the `dartpedia` project.
* Understand basic Dart syntax, including [classes][] and data types.

[classes]: /language/classes

## Tasks

In this chapter, you'll create Dart classes to
represent the JSON data returned by the Wikipedia API.
This will allow you to easily access and use the data in your application.

### Task 1: Create the Wikipedia package

First, create a new Dart package to house the data models.

1.  Navigate to the root directory of your project (`/dartpedia`).
1.  Run the following command in your terminal:

    ```bash
    dart create wikipedia
    ```

    This command creates a new directory named `wikipedia` with the basic
    structure of a Dart package. You should now see a new folder
    `wikipedia` in your project root, alongside `cli` and `command_runner`.

### Task 2: Configure a Dart workspace

Dart workspaces allow you to
manage multiple related packages within a single project,
simplifying dependency management and local development.
Now that you're adding your third package,
it's a good time to configure your project to use a Dart workspace.

1.  **Create the root `pubspec.yaml` file.**

    Navigate to the root directory of your project (`/dartpedia`) and create a
    new file named `pubspec.yaml` with the following content:

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

    *   For `cli/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: cli
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    *   For `command_runner/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: command_runner
        description: A starting point for Dart libraries or applications.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    *   For `wikipedia/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: wikipedia
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

### Task 3: Create the Summary class

The Wikipedia API returns a JSON object containing a summary of an article.
Let's create a Dart class to represent this summary.

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

    This code defines a `Summary` class with properties that correspond to the
    fields in the JSON response from the Wikipedia API.
    The `fromJson` method uses [pattern matching][] to
    extract the data from the JSON object and create a new `Summary` instance.
    The `toString` method provides a convenient way to
    print the contents of the `Summary` object.
    Note that the `TitlesSet` class is used in the `Summary` class,
    so you'll need to create that next.

[pattern matching]: /language/patterns

### Task 4: Create the TitleSet class

The `Summary` class uses a `TitlesSet` class to represent the title information.
Let's create that class now.

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

    This code defines a `TitlesSet` class with properties that correspond to
    the title information in the JSON response from the Wikipedia API.
    The `fromJson` method uses pattern matching to
    extract the data from the JSON object and create a new `TitlesSet` instance.
    The `toString` method provides a convenient way to
    print the contents of the `TitlesSet` object.

### Task 5: Create the Article class

The Wikipedia API also returns a list of articles in a search result.
Let's create a Dart class to represent an article.

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

    This code defines an `Article` class with properties for
    the title and extract of an article.
    The `listFromJson` method uses pattern matching to
    extract the data from the JSON object and
    create a list of `Article` instances.
    The `toJson` method converts the `Article` object back into a JSON object.
    The `toString` method provides a convenient way to
    print the contents of the `Article` object.

### Task 6: Create the SearchResults class

Finally, let's create a class to represent the
search results from the Wikipedia API.

1.  Create the file `wikipedia/lib/src/model/search_results.dart`.
2.  Add the following code to `wikipedia/lib/src/model/search_results.dart`:

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

    This code defines a `SearchResults` class with a
    list of `SearchResult` objects and a search term.
    The `fromJson` method uses pattern matching to extract the data from
    the JSON object and create a new `SearchResults` instance.
    The `toString` method provides a convenient way to
    print the contents of the `SearchResults` object.

At this point, you've created data models to represent JSON structures.
There's nothing to test at this point.
You'll add that application logic in the upcoming sections,
which will enable you to test how data is deserialized from the Wikipedia API.

## Review

In this lesson, you learned about:

*   Deserializing JSON data into Dart objects.
*   Using the `dart:convert` library to work with JSON.
*   Using the `jsonDecode` function to parse JSON strings.
*   Using pattern matching to extract data from JSON objects.
*   Creating Dart classes to represent JSON data structures.

## Quiz

<Quiz title="Check your understanding" id="data-and-json" />

## Next lesson

In the next lesson, you'll learn how to
test your Dart code using the `package:test` library.
You'll write tests to ensure that your
JSON deserialization logic is working correctly.
