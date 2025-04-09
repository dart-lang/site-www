---
title: "Chapter 11: HTTP"
description: "Learn about Wikipedia API calls."
---

# Chapter 11: HTTP
Learn about Wikipedia API calls.

[Video Placeholder]

In this lesson, we'll implement the core functionality of our Wikipedia CLI application: making calls to the Wikipedia API. We'll leverage the `http` package to fetch data from the API endpoints and integrate these calls into our existing command structure. By the end of this lesson, you'll be able to search for articles, retrieve article summaries, and fetch full article content directly from the command line. This lesson will complete the core functionality of the Wikipedia CLI.

## Background / Key Concepts
*   **Wikipedia API:** A set of web services that allow developers to access and retrieve data from Wikipedia. We'll be using several API endpoints to search for articles, retrieve summaries, and fetch full article content.
*   **`package:http`:** A Dart package that provides a simple and powerful way to make HTTP requests. We've already introduced this, but now we'll use it more extensively.
*   **API Endpoints:** Specific URLs that expose different functionalities of the Wikipedia API. Each endpoint accepts certain parameters and returns data in a specific format (usually JSON).
*   **HTTP Methods:** Standard methods for interacting with web servers. We'll primarily use the `GET` method to retrieve data from the Wikipedia API.
*   **Asynchronous Operations:** Making network requests is an asynchronous operation. We'll use `async/await` to handle these operations and prevent our application from blocking.

## Set up
Make sure you have completed Chapter 10 and have a working Dart project set up with the `cli`, `command_runner`, and `wikipedia` packages.

## Tasks
In this lesson, we'll implement the Wikipedia API calls in the `wikipedia` package and integrate them into the `cli` package. This will involve modifying the `wikipedia` package to include API calling functions, and updating the command runner files.

### Implement Wikipedia API Calls in `wikipedia`
1.  Open `wikipedia/lib/src/api/summary.dart` in your code editor.

2.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/summary.dart';

    // [Step 11 update]
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

    // The title must match exactly
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

    *   This code defines two functions for retrieving article summaries from the Wikipedia API:
        *   `getRandomArticleSummary()`: Retrieves a summary of a random article.
        *   `getArticleSummaryByTitle(String articleTitle)`: Retrieves a summary of an article with the specified title.
    *   Both functions use the `http` package to make `GET` requests to the Wikipedia API endpoints.
    *   The `jsonDecode` function is used to parse the JSON response into a `Map<String, Object?>`.
    *   The `Summary.fromJson` method is used to deserialize the JSON data into a `Summary` object.
    *   Error handling is included to check for HTTP status codes other than 200 (OK) and to rethrow any `FormatException` that might occur during JSON parsing.
    *   `client.close()` is included in the `finally{}` block, which ensures that the client is closed after the operation is complete.
    *   `rethrow` allows the errors to bubble up to the call stack, allowing the `CommandRunner` to use the error handler if it exists.

3.  Open `wikipedia/lib/src/api/search.dart` in your code editor.

4.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/search_results.dart';

    // [Step 11 update]
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

    *   This code defines the `search` function for searching Wikipedia articles.
    *   This function uses the `http` package to make `GET` requests to the Wikipedia API endpoints.
    *   The `jsonDecode` function is used to parse the JSON response into a `List<Object?>`.
    *   The `SearchResults.fromJson` method is used to deserialize the JSON data into a `SearchResults` object.
    *   Error handling is included to check for HTTP status codes other than 200 (OK) and to rethrow any `FormatException` that might occur during JSON parsing.
    *   `client.close()` is included in the `finally{}` block, which ensures that the client is closed after the operation is complete.

5.  Open `wikipedia/lib/src/api/get_article.dart` in your code editor.

6.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/article.dart';

    // [Step 11 update]
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

    *   This code defines the `getArticleByTitle` function for getting a full wikipedia article.
    *   This function uses the `http` package to make `GET` requests to the Wikipedia API endpoints.
    *   The `jsonDecode` function is used to parse the JSON response into a `Map<String, Object?>`.
    *   The `Article.listFromJson` method is used to deserialize the JSON data into a `List<Article>`.
    *   Error handling is included to check for HTTP status codes other than 200 (OK) and to rethrow any `FormatException` that might occur during JSON parsing.
    *   `client.close()` is included in the `finally{}` block, which ensures that the client is closed after the operation is complete.

7. Add the following exports to `wikipedia/lib/wikipedia.dart`:

    ```dart
    export 'src/api/get_article.dart';
    export 'src/api/search.dart';
    export 'src/api/summary.dart';
    export 'src/model/article.dart';
    export 'src/model/search_results.dart';
    export 'src/model/summary.dart';
    export 'src/model/title_set.dart';
    ```

### Update CLI to Implement Wikipedia API Calls

1.  Open `cli/lib/cli.dart` and replace it with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    // [Step 12 update] Export these files, plus the files are all brand new
    export 'src/commands/get_article.dart';
    export 'src/commands/search.dart';
    export 'src/logger.dart';
    ```
2.  Create `cli/lib/src/commands/get_article.dart` in your code editor.

3.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

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
          final buffer = StringBuffer('\n=== ${article.title} ===\n\n');
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

    *   This code defines a `GetArticleCommand` class that implements the `Command` abstract class from the `command_runner` package.
    *   The `run` method retrieves the article title from the command-line arguments and calls the `getArticleByTitle` function from the `wikipedia` package.
    *   The `run` method prints the title and first 500 words to the CLI output.

4.  Create `cli/lib/src/commands/search.dart` in your code editor.

5.  Replace the existing code with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

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

    *   This code defines a `SearchCommand` class that implements the `Command` abstract class from the `command_runner` package.
    *   The `run` method retrieves the search term from the command-line arguments and calls the `search` function from the `wikipedia` package.
    *   The `run` method iterates through the search results and prints each result in the buffer, so that it can be returned to the CLI output.

6.  Open `cli/bin/cli.dart` and replace it with the following:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';

    // [Step 12 update] Adds errorLogger, updates the `onError` callback,
    // adds two ..addCommand calls
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
7.  Create `cli/lib/src/logger.dart` in your code editor.

8.  Add the following code to the file:

    ```dart
    /*
     * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
     * // Use of this source code is governed by a BSD-style license that can be
     * // found in the LICENSE file.
     */

    import 'dart:io';

    import 'package:logging/logging.dart';

    /// Creates a logger that logs to a txt file
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

      logger.level = Level.ALL;
      logger.onRecord.listen((record) {
        final msg =
            '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
        logFile.writeAsStringSync('$msg \n', mode: FileMode.append);
      });

      return logger;
    }
    ```

    *   Because this logger writes to a file, it would be bad to include this logic directly in the `run` method.

### Run the Updated Application

1.  Open your terminal or command prompt.

2.  Navigate to the root directory of your project (`cli`).

3.  Run the following commands and observe the output:

    ```bash
    dart run bin/cli.dart search dart
    ```

    Output:

    ```text
    Search results:Dart - https://en.wikipedia.org/wiki/Dart
    Darth Vader - https://en.wikipedia.org/wiki/Darth_Vader
    Dartmouth College - https://en.wikipedia.org/wiki/Dartmouth_College
    Darts - https://en.wikipedia.org/wiki/Darts
    Darth Maul - https://en.wikipedia.org/wiki/Darth_Maul
    Dartford Crossing - https://en.wikipedia.org/wiki/Dartford_Crossing
    Dart (programming language) - https://en.wikipedia.org/wiki/Dart_(programming_language)
    Dartmouth College fraternities and sororities - https://en.wikipedia.org/wiki/Dartmouth_College_fraternities_and_sororities
    Dartmoor - https://en.wikipedia.org/wiki/Dartmoor
    Dartmouth, Massachusetts - https://en.wikipedia.org/wiki/Dartmouth,_Massachusetts
    ```

    ```bash
    dart run bin/cli.dart article cat
    ```

    Output:

    ```text

    === Cat ===

    The cat (Felis catus), also referred to as the domestic cat, is a small domesticated carnivorous mammal. It is the only domesticated species of the family Felidae. Advances in archaeology and genetics have shown that the domestication of the cat occurred in the Near East around 7500 BC. It is commonly kept as a pet and farm cat, but also ranges freely as a feral cat avoiding human contact. It is valued by humans for companionship and its ability to kill vermin. Its retractable claws are adapted to killing small prey species such as mice and rats. It has a strong, flexible body, quick reflexes, and sharp teeth, and its night vision and sense of smell are well developed. It is a social species, but a solitary hunter and a crepuscular predator. Cat communication includes vocalizations—including meowing, purring, trilling, hissing, growling, and grunting—as well as body language. It can hear sounds too faint or too high in frequency for human ears, such as those made by small mammals. It secretes and perceives pheromones.
    Female domestic cats can have kittens from spring to late autumn in temperate zones and throughout the year in equatorial regions, with litter sizes often ranging from two to five kittens. Domestic cats are bred and shown at events as registered pedigreed cats, a hobby known as cat fancy. Animal population control of cats may be achieved by spaying and neutering, but their proliferation and the abandonment of pets has resulted in large numbers of feral cats worldwide, contributing to the extinction of bird, mammal, and reptile species.
    As of 2017, the domestic cat was the second most popular pet in the United States, with 95.6 million cats owned and around 42 million households owning at least one cat. In the United Kingdom, 26% of adults have a cat, with an estimated population of 10.9 million pet cats as of 2020. As of 2021, there were an estimated 220 million owned and 480 million stray cats in the world.

    == Etymology and naming ==
    The origin of the English word cat, Old English catt, is thought to be the Late Latin word cattus, which was first used at the beginning of the 6th century. The Late Latin word may be derived from an unidentified African language. The Nubian word kaddîska 'wildcat' and Nobiin kadís are possible sources or cognates.
    The forms might also have derived from an ancient Germanic word that was absorbed into Latin and then into Greek, Syriac, and Arabic. The word may be derived from Germanic and Northern European languages, and ultimately be borrowed from Uralic, cf. Northern Sámi gáđfi, 'female stoat', and Hungarian hölgy, 'lady, female stoat'; from Proto-Uralic *käčwä, 'female (of a furred animal)'.
    The English puss, extended as pussy and pussycat, is attested from the 16th century and may have been introduced from Dutch poes or from Low German puuskatte, related to Swedish kattepus, or Norwegian pus, pusekatt. Similar forms exist in Lithuanian puižė and Irish puisín or puiscín. The etymology of this word is unknown, but it may have arisen from a sound used to attract a cat.
    A male cat is called a tom or tomcat (or a gib, if neutered). A female is called a queen (or sometimes a molly, if spayed). A juvenile cat is referred to as a kitten. In Early Modern English, the word kitten was interchangeable with the now-obsolete word catling. A group of cats can be referred to as a clowder, a glaring, or a colony.

    == Taxonomy ==
    The scientific name Felis catus was proposed by Carl Linnaeus in 1758 for a domestic cat. Felis catus domesticus was proposed by Johann Christian Polycarp Erxleben in 1777. Felis daemon proposed by Konstantin Satunin in 1904 was a black cat from the Transcaucasus, later identified as a domestic cat.
    In 2003, the International Commission on Zoological Nomenclature ruled that the domestic cat is a distinct species, namely Felis catus. In 2007, the modern domesticated subspecies F. silvestris catus sampled worldwide was considered to have probably descended from the African wildcat (F. lybica), following results of phylogenetic research. In 2017, the IUCN Cat Classification Taskforce followed the recommendation of the ICZN in regarding the domestic cat as a distinct species, Felis catus.

    == Evolution ==

    The domestic cat is a member of the Felidae, a family that had a common ancestor about 10 to 15 million years ago. The evolutionary radiation of the Felidae began in Asia during the Miocene around 8.38 to 14.45 million years ago. Analysis of mitochondrial DNA of all Felidae species indicates a radiation at 6.46 to 16.76 million years ago. The genus Felis genetically diverged from other Felidae around 6 to 7 million years ago. Results of phylogenetic research shows that the wild members of this genus evolved through sympatric or parapatric speciation, whereas the domestic cat evolved through artificial selection. The domestic cat and its closest wild ancestor are diploid and both possess 38 chromosomes and roughly 20,000 genes.

    === Domestication ===

    It was long thought that the domestication of the cat began in ancient Egypt, where cats were venerated from around 3100 BC. However, the earliest known indication for the taming of an African wildcat was excavated close by a human Neolithic grave in Shillourokambos, southern Cyprus, dating to about 7500–7200 BC. Since there is no evidence of native mammalian fauna on Cyprus, the inhabitants of this Neolithic village most likely brought the cat and other wild mammals to the island from the Middle Eastern mainland. Scientists therefore assume that African wildcats were attracted to early human settlements in the Fertile Crescent by rodents, in particular, the house mouse (Mus musculus), and were tamed by Neolithic farmers. This mutual relationship between early farmers and tamed cats lasted thousands of years. As agricultural practices spread, so did tame and domesticated cats. Wildcats of Egypt contributed to the maternal gene pool of the domestic cat at a later time.
    The earliest known evidence for the occurrence of the domestic cat in Greece dates to around 1200 BC. Greek, Phoenician, Carthaginian and Etruscan traders introduced domestic cats to southern Europe. By the 5th century BC, they were familiar animals around settlements in Magna Graecia and Etruria. During the Roman Empire, they were introduced to Corsica and Sardinia before the beginning of the 1st century AD. By the end of the Western Roman Empire in the 5th century, the Egyptian domestic cat lineage had arrived in a Baltic Sea port in northern Germany.
    The leopard cat (Prionailurus bengalensis) was tamed independently in China around 5500 BC. This line of partially domesticated cats leaves no trace in the domestic cat populations of today.
    During domestication, cats have undergone only minor changes in anatomy and behavior, and they are still capable of surviving in the wild. Several natural behaviors and characteristics of wildcats may have pre-adapted them for domestication as pets. These traits include their small size, social nature, obvious body language, love of play, and high intelligence. Since they practice rigorous grooming habits and have an instinctual drive to bury and hide their urine and feces, they are generally much less messy than other domesticated animals. Captive Leopardus cats may also display affectionate behavior toward humans but were not domesticated. House cats often mate with feral cats. Hybridization between domestic and other Felinae species is also possible, producing hybrids such as the Kellas cat in Scotland.
    Development of cat breeds started in the mid 19th century. An analysis of the domestic cat genome revealed that the ancestral wildcat genome was significantly altered in the process of domestication, as specific mutations were selected to develop cat breeds. Most breeds are founded on random-bred domestic cats. Genetic diversity of these breeds varies between regions, and is lowest in purebred populations, which show more than 20 deleterious genetic disorders.

    == Characteristics ==

    === Size ===
    The domestic cat has a smaller skull and shorter bones than the European wildcat. It averages about 46 cm (18 in) in head-to-body length and 23–25 cm (9.1–9.8 in) in height, with about 30 cm (12 in) long tails. Males are larger than females. Adult domestic cats typically weigh 4–5 kg (8.8–11.0 lb).

    === Skeleton ===
    Cats have seven cervical vertebrae (as do most mammals); 13 thoracic vertebrae (humans have 12); seven lumbar vertebrae (humans have five); three sacral vertebrae (as do most mammals, but humans have five); and a variable number of caudal vertebrae in the tail (humans have only three to five vestigial caudal vertebrae, fused into an internal coccyx).: 11  The extra lumbar and thoracic vertebrae account for the cat's spinal mobility and flexibility. Attached to the spine are 13 ribs, the shoulder, and the pelvis.: 16  Unlike human arms, cat forelimbs are attached to the shoulder by free-floating clavicle bones which allow them to pass their body through any space into which they can fit their head.

    === Skull ===

    The cat skull is unusual among mammals in having very large eye sockets and a powerful specialized jaw.: 35  Within the jaw, cats have teeth adapted for killing prey and tearing meat. When it overpowers its prey, a cat delivers a lethal neck bite with its two long canine teeth, inserting them between two of the prey's vertebrae and severing its spinal cord, causing irreversible paralysis and death. Compared to other felines, domestic cats have narrowly spaced canine teeth relative to the size of their jaw, which is an adaptation to their preferred prey of small rodents, which have small vertebrae.
    The premolar and first molar together compose the carnassial pair on each side of the mouth, which efficiently shears meat into small pieces, like a pair of scissors. These are vital in feeding, since cats' small molars cannot chew food effectively, and cats are largely incapable of mastication.: 37  Cats tend to have better teeth than most humans, with decay generally less likely because of a thicker protective layer of enamel, a less damaging saliva, less retention of food particles between teeth, and a diet mostly devoid of sugar. Nonetheless, they are subject to occasional tooth loss and infection.

    === Claws ===

    Cats have protractible and retractable claws. In their normal, relaxed position, the claws are sheathed with the skin and fur around the paw's toe pads. This keeps the claws sharp by preventing wear from contact with the ground and allows for the silent stalking of prey. The claws on the forefeet are typically sharper than those on the hindfeet. Cats can voluntarily extend their claws on one or more paws. They may extend their claws in hunting or self-defense, climbing, kneading, or for extra traction on soft surfaces. Cats shed the outside layer of their claw sheaths when scratching rough surfaces.
    Most cats have five claws on their front paws and four on their rear paws. The dewclaw is proximal to the other claws. More proximally is a protrusion which appears to be a sixth "finger". This special feature of the front paws on the inside of the wrists has no function in normal walking but is thought to be an antiskidding device used while jumping. Some cat breeds are prone to having extra digits ("polydactyly"). Polydactylous cats occur along North America's northeast coast and in Great Britain.

    === Ambulation ===
    The cat is digitigrade. It walks on the toes, with the bones of the feet making up the lower part of the visible leg. Unlike most mammals, it uses a "pacing" gait and moves both legs on one side of the body before the legs on the other side. It registers directly by placing each hind paw close to the track of the corresponding fore paw, minimizing noise and visible tracks. This also provides sure footing for hind paws when navigating rough terrain. As it speeds up from walking to trotting, its gait changes to a "diagonal" gait: The diagonally opposite hind and fore legs move simultaneously.

    === Balance ===

    Cats are generally fond of sitting in high places or perching. A higher place may serve as a concealed site from which to hunt; domestic cats strike prey by pouncing from a perch such as a tree branch. Another possible explanation is that height gives the cat a better observation point, allowing it to survey its territory. A cat falling from heights of up to 3 m (9.8 ft) can right itself and land on its paws.
    During a fall from a high place, a cat reflexively twists its body and rights itself to land on its feet using its acute sense of balance and flexibility. This reflex is known as the cat righting reflex. A cat always rights itself in the same way during a fall, if it has enough time to do so, which is the case in falls of 90 cm (3.0 ft) or more. How cats are able to right themselves when falling has been investigated as the "falling cat problem".

    === Coats ===

    The cat family (Felidae) can pass down many colors and patterns to their offspring. The domestic cat genes MC1R and ASIP allow color variety in their coats. The feline ASIP gene consists of three coding exons. Three novel microsatellite markers linked to ASIP were isolated from a domestic cat BAC clone containing this gene to perform linkage analysis on 89 domestic cats segregated for melanism. The domestic cat family demonstrated a cosegregation between the ASIP allele and coat black coloration.

    == Senses ==

    === Vision ===

    Cats have excellent night vision and can see at one sixth the light level required for human vision.: 43  This is partly the result of cat eyes having a tapetum lucidum, which reflects any light that passes through the retina back into the eye, thereby increasing the eye's sensitivity to dim light. Large pupils are an adaptation to dim light. The domestic cat has slit pupils, which allow it to focus bright light without chromatic aberration. At low light, a cat's pupils expand to cover most of the exposed surface of its eyes. The domestic cat has rather poor color vision and only two types of cone cells, optimized for sensitivity to blue and yellowish green; its ability to distinguish between red and green is limited. A response to middle wavelengths from a system other