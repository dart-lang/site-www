---
title: Add logging for debugging and monitoring
short-title: Logging
description: >-
  Learn how to add logging to your Dart application to
  help with debugging and monitoring.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /learn/tutorial/http
  title: Fetch data from the internet
nextpage:
  # TODO: Create a conclusion page or section with next steps.
  url: /learn
  title: Keep learning!
---

{% render 'fwe-wip-warning.md', site: site %}

In this chapter, you'll learn how to add logging to your Dart application.
Logging is a critical tool for debugging, monitoring, and understanding the
behavior of your application in different environments.

:::secondary What you'll learn

*  Add the `logging` package to your project.
*  Understand different log levels and how to use them.
*  Create a `Logger` instance and configure it to write to a file.
*  Log errors and warnings to a file for later inspection.

:::

## Prerequisites

Before you begin this chapter, ensure you:

*  Have completed Chapter 11 and have a working Dart development environment
   with the `dartpedia` project.
*  Understand the basics of debugging and why it's important to track errors and
   events in your application.

## Tasks

In this chapter, you'll add logging to the `dartpedia` CLI application to help
track errors and monitor its behavior. This will involve adding the `logging`
package, creating a `Logger` instance, and writing log messages to a file.

### Task 1: Add the `logging` package

First, add the `logging` package to your project's dependencies.

1.  Open the `cli/pubspec.yaml` file.

2.  Locate the `dependencies` section.

3.  Add the `logging` package to your dependencies:

    ```yaml
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
      wikipedia:
        path: ../wikipedia
      # Add the following line
      logging: ^1.2.0
    ```

4.  Run `dart pub get` in the `cli` directory to fetch the new dependency.

### Task 2: Create a logger

Next, create a `Logger` instance and configure it to write log messages
to a file. This involves creating a new file for the logger and setting up
the necessary imports.

1.  Create a new file called `cli/lib/src/logger.dart`.

1.  Add the necessary imports and define the `initFileLogger` function.

    ```dart title="cli/lib/src/logger.dart"
    import 'dart:io';
    import 'package:logging/logging.dart';
  
    Logger initFileLogger(String name) {
      // Enables logging from child loggers.
      hierarchicalLoggingEnabled = true;
  
      // Create a logger instance with the provided name.
      final logger = Logger(name);
      final now = DateTime.now();
  
      // The rest of the function will be added below.
      // ...
  
      return logger;
    }
    ```

1.  Add the code to find the project's root directory, create a `logs`
    directory if one doesn't exist, and create a unique log file.
   
    ```dart
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();
  
      // Get the path to the project directory from the current script.
      final segments = Platform.script.path.split('/');
      final projectDir = segments.sublist(0, segments.length - 2).join('/');
  
      // Create a 'logs' directory if it doesn't exist.
      final dir = Directory('$projectDir/logs');
      if (!dir.existsSync()) dir.createSync();
  
      // Create a log file with a unique name based on the current date and logger name.
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );
  
      // The rest of the function will be added below.
      // ...
  
      return logger;
    }
    ```

1.  Configure the logger's level and set up a listener to write log messages
    to the file.

    ```dart
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();
    
      final segments = Platform.script.path.split('/');
      final projectDir = segments.sublist(0, segments.length - 2).join('/');
      final dir = Directory('$projectDir/logs');
      if (!dir.existsSync()) dir.createSync();
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );
    
      // Set the logger level to ALL, so it logs all messages regardless of severity.
      // Level.ALL is useful for development and debugging, but you'll likely want to
      // use a more restrictive level like Level.INFO or Level.WARNING in production.
      logger.level = Level.ALL;
    
      // Listen for log records and write each one to the log file.
      logger.onRecord.listen((record) {
        final msg =
            '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
        logFile.writeAsStringSync('$msg \n', mode: FileMode.append);
      });
    
      return logger;
    }
    ```

    This code does the following:

    *  It enables hierarchical logging using `hierarchicalLoggingEnabled = true`.
    *  It creates a `Logger` instance with the given name.
    *  It gets the project directory from the `Platform.script.path`.
    *  It creates a `logs` directory if it doesn't exist.
    *  It creates a log file with the current date and the logger name.
    *  It sets the logger level to `Level.ALL`, meaning it will log all messages.
       This is useful for development and debugging, but you'll likely want to use
       a more restrictive level like `Level.INFO` or `Level.WARNING` in
       production.
    *  It listens for log records and writes them to the log file.

1. Create a new file called `cli/lib/cli.dart` and export `logger.dart`.
   This makes the `initFileLogger` available to other parts of your app.

   ```dart title="cli/lib/cli.dart"
    export 'src/commands/get_article.dart';
    export 'src/commands/search.dart';
    export 'src/logger.dart';
   ```

### Task 3: Use the logger in `cli.dart`

Now, use the `initFileLogger` function in `cli/bin/cli.dart` to create a
logger instance and log messages to a file.

1.  Open the `cli/bin/cli.dart` file.

2.  Add the import for the logger:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';
    ```

3.  Modify the `main` function to initialize the logger and pass it to the
    commands:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';
    
    void main(List<String> arguments) async {
      final errorLogger = initFileLogger('errors');
      final app =
          CommandRunner<String>(
              onOutput: (String output) async {
                await write(output);
              },
              onError: (Object error) {
                if (error is Error) {
                  errorLogger.severe(
                    '[Error] ${error.toString()}\n${error.stackTrace}',
                  );
                  throw error;
                }
                if (error is Exception) {
                  errorLogger.warning(error);
                }
              },
            )
            ..addCommand(HelpCommand())
            ..addCommand(SearchCommand(logger: errorLogger))
            ..addCommand(GetArticleCommand(logger: errorLogger));
    
      app.run(arguments);
    }
    ```

    This code does the following:

    *  It initializes a `Logger` instance using `initFileLogger('errors')`.
    *  It passes the `logger` instance to `CommandRunner` and
       individual commands.

### Task 4: Create the SearchCommand command

The core functionality of the CLI lives in its commands. Create the
`SearchCommand` and `GetArticleCommand` files and add the necessary code,
including the logging and error handling.

1.  Create a new file named `/cli/lib/src/commands/search.dart`.

1.  Add the imports and a basic class structure. This `SearchCommand`
    class extends `Command<String>`, and its constructor accepts a `Logger`
    instance. Accepting the logger in the constructor is a common pattern called
    dependency injection, which allows the command to log events without needing
    to create its own logger.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        // The rest of the function will be added below.
        // ...
      }
    }
    ```
  
1.  Now, add the core logic to the `run` method. This code checks for a
    valid argument, calls the `search()` function from the `wikipedia` package,
    formats the results, and returns the results as a string.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        if (requiresArgument &&
            (args.commandArg == null || args.commandArg!.isEmpty)) {
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
        final SearchResults results = await search(args.commandArg!);

        for (var result in results.results) {
          buffer.writeln('${result.title} - ${result.url}');
        }
        return buffer.toString();
      }
    }
    ```

1.  Next, add the "I'm feeling lucky" feature by adding a flag to the
    constructor. Then, in the `run` method, add the logic to check if the flag
    is set and, if so, get the summary of the top search result.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger}) {
        addFlag(
          'im-feeling-lucky',
          help:
              'If true, prints the summary of the top article that the search returns.',
        );
      }

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        if (requiresArgument &&
            (args.commandArg == null || args.commandArg!.isEmpty)) {
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
        final SearchResults results = await search(args.commandArg!);

        if (args.flag('im-feeling-lucky')) {
          final title = results.results.first.title;
          final Summary article = await getArticleSummaryByTitle(title);
          buffer.writeln('Lucky you!');
          buffer.writeln(article.titles.normalized.titleText);
          if (article.description != null) {
            buffer.writeln(article.description);
          }
          buffer.writeln(article.extract);
          buffer.writeln();
          buffer.writeln('All results:');
        }

        for (var result in results.results) {
          buffer.writeln('${result.title} - ${result.url}');
        }
        return buffer.toString();
      }
    }
    ```

1.  Finally, wrap the main logic in a `try/catch` block. This allows you to
    handle potential exceptions that could arise from network issues or data
    formatting problems. You'll use the injected `logger` to record these errors
    to the log file.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger}) {
        addFlag(
          'im-feeling-lucky',
          help:
              'If true, prints the summary of the top article that the search returns.',
        );
      }

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        if (requiresArgument &&
            (args.commandArg == null || args.commandArg!.isEmpty)) {
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
        try {
          final SearchResults results = await search(args.commandArg!);

          if (args.flag('im-feeling-lucky')) {
            final title = results.results.first.title;
            final Summary article = await getArticleSummaryByTitle(title);
            buffer.writeln('Lucky you!');
            buffer.writeln(article.titles.normalized.titleText);
            if (article.description != null) {
              buffer.writeln(article.description);
            }
            buffer.writeln(article.extract);
            buffer.writeln();
            buffer.writeln('All results:');
          }

          for (var result in results.results) {
            buffer.writeln('${result.title} - ${result.url}');
          }
          return buffer.toString();
        } on HttpException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.uri)
            ..info(usage);
          return e.message;
        } on FormatException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.source)
            ..info(usage);
          return e.message;
        }
      }
    }
    ```

### Task 5: Create the GetArticleCommand command

Now, create the `GetArticleCommand` file and add the necessary code. The code is
similar to the previous `SearchCommand`, as it also uses a `try/catch` block to handle
potential network or data errors.

1.  Create a new file named cli/lib/src/commands/get_article.dart.

2.  Add the following code to `get_article.dart`.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class GetArticleCommand extends Command<String> {
      GetArticleCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Read an article from Wikipedia';

      @override
      String get name => 'article';

      @override
      String get help => 'Gets an article by exact canonical wikipedia title.';

      @override
      String get defaultValue => 'cat';

      @override
      String get valueHelp => 'STRING';

      @override
      FutureOr<String> run(ArgResults args) async {
        try {
          var title = args.commandArg ?? defaultValue;
          final List<Article> articles = await getArticleByTitle(title);
          // API returns a list of articles, but we only care about the closest hit.
          final article = articles.first;
          final buffer = StringBuffer('\n=== ${article.title.titleText} ===\n\n');
          buffer.write(article.extract.split(' ').take(500).join(' '));
          return buffer.toString();
        } on HttpException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.uri)
            ..info(usage);
          return e.message;
        } on FormatException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.source)
            ..info(usage);
          return e.message;
        }
      }
    }
    ```

    Review the code you've just added. The `SearchCommand` and
    `GetArticleCommand` now:

    * Import the necessary packages like `command_runner`, `logging`, and
      `wikipedia` to use their classes and functions.
    * Accept a `Logger` instance through their constructor. This is a common
      pattern called dependency injection, which allows the command to log
      events without needing to create its own logger.
    * Implement a `run` method that defines the command's logic. This method
      calls the appropriate wikipedia API and formats the output.
    * Include `try/catch` blocks to gracefully handle network errors
      (`HttpException`) and data parsing errors (`FormatException`), logging
      them for debugging.


### Task 6: Run the application and check the logs

Now that you've added logging to your application, run it and check the log
file to see the results.

1.  Run the application with a command that might produce an error. For example,
    try searching for an article that doesn't exist or that causes a
    `FormatException`.

    ```bash
    dart run bin/cli.dart search blahblahblahblah
    ```

2.  Check the `logs` directory in your project. You should see a file with the
    current date and the name `errors.txt`.

3.  Open the log file and verify that the error message is logged.

    ```text
    [2025-02-20 16:23:45.678 - errors] WARNING: HttpException: HttpException: , uri = https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=blahblahblahblah
    [2025-02-20 16:23:45.678 - errors] INFO: Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
    ```

## Review

In this lesson, you learned:

*  How to add the `logging` package to your project.
*  How to create a `Logger` instance and configure it to write to a file.
*  How to log errors and warnings to a file for later inspection.
*  The importance of logging for debugging and monitoring your application.

## Quiz

<Quiz title="Check your understanding" id="logging" />

## Next lesson

Congratulations! You've now completed all the core chapters of the Dart Getting
Started tutorial. As a bonus, you can learn how to make your application into a
server using `package:shelf` in the next chapter.
