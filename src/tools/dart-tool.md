---
title: "dart: The Dart command-line tool"
description: "The reference page for using 'dart'."
toc: false
---

Introduced in Dart 2.10, the `dart` tool (`bin/dart`)
is a technical preview of the new command-line interface to the Dart SDK.
The `dart` tool is available no matter how you get the Dart SDK —
whether you explicitly download the Dart SDK or only download
the [Flutter SDK.](https://flutter.dev)
{% comment %}
  Is there a flutter command page? If so, point to it.
  If not... should we add one?
{% endcomment %}

Here are a few examples of using the `dart` tool:

```terminal
$ dart analyze bin/
$ dart compile exe bin/main.dart
$ dart create my_app
$ dart pub outdated
$ dart pub upgrade
```

{{ site.alert.version-note }}
  Before Dart 2.10, the `dart` command was used only to run the Dart VM.
  You can still use it that way, but
  now the command has more functionality.
  Over time, we expect the `dart` command to replace
  all other commands in the Dart SDK.
  **[QUESTION: is that really true?]**
{{ site.alert.end }}

The following table shows which commands you can use with the `dart` tool.
For additional help on any of the commands, enter `dart help <command>`
or follow the links in the **More information** column.


|---------+--------------------------------+-----------------------------------|
| Command | Example of use                 | More information                  |
|---------|--------------------------------|-----------------------------------|
| analyze | `dart analyze <DIRECTORY>`     | Analyzes the project's Dart code.<br>Use instead of [`dartanalyzer`][]. |
| compile | `dart compile exe <DART_FILE>` | Compiles Dart to various formats.<br>Use instead of [`dart2js`][] and [`dart2native`][]. | 
| create  | `dart create <DIRECTORY>`      | Creates a new project in the specified drectory.<br>Use instead of [`stagehand`.][] | 
| format  | `dart format <DIRECTORY|DART_FILE>` | Formats Dart source code.<br>Use instead of [`dartfmt`][]. | 
| migrate | `dart migrate`                 | Supports migration to [null safety][].<br>**[PENDING: where are details on using this command?]** | 
| pub     | `dart pub <PUB_COMMAND>`       | Supports packages.<br>Use instead of [`pub`][]. | 
| run     | `dart run <DART_FILE>`         | Runs a Dart file. <br>Use instead of the pre-existing [Dart VM command][dart-vm]. | 
| test    | `dart test [<DIRECTORY|DART_FILE>]` | Runs tests.<br>Use instead of [`pub run test`][`pub`]. |
| _(none)_| `dart <DART_FILE>`             | Runs a Dart file, just like `dart run`. <br>Identical to the pre-existing [Dart VM command][dart-vm]. | 
{:.table .table-striped .nowrap}

[`dart2js`]: /tools/dart2js
[`dart2native`]: /tools/dart2native
[`dartanalyzer`]: /tools/dartanalyzer
[`dartaotruntime`]: /tools/dartaotruntime
[`dartdevc`]: /tools/dartdevc
[`dartdoc`]: https://github.com/dart-lang/dartdoc#dartdoc
[`dartfmt`]: /tools/dartfmt
[dart-vm]: /tools/dart-vm
[null safety]: /null-safety
[`pub`]: /tools/pub/cmd
[`stagehand`.]: {{site.pub-pkg}}/stagehand

**[PENDING: Here are some things that surprised me:**
* `dart analyze` didn't work on a lone file; it appears to only take a directory name.
* `dart create --help` says to use `dart create [args] <dir>`, but the dir name must be first.
  Should the help change or the command?
]

**[QUESTION: Is it true that the following commands are not (yet) included?
[`dartdoc`][], [`dartdevc`][], [`dartaotruntime`][]
]**
