---
title: dart format
description: Command-line tool for formatting Dart source code.
---

To update your code to follow the
[Dart formatting guidelines][dart-guidelines],
use the `dart format` command.
This formatting follows what you get
when using an IDE or editor with Dart support.

{% render 'tools/dart-tool-note.md' %}

## Specify files to format

To reformat one or more Dart files,
provide a list of paths to the desired files or directories.

### Specify one path

Provide the path to one file or directory.
If you pass a directory path,
`dart format` recurses into its subdirectories as well.

**Example:** To format all the Dart files in or under the current directory:

```console
$ dart format .
```

### Specify multiple paths

To specify multiple files or directories, use a space-delimited list.

**Example:** To format all Dart files under the `lib` directory,
plus one Dart file under the `bin` directory:

```console
$ dart format lib bin/updater.dart 
```

### Prevent overwriting Dart files

By default, `dart format` **overwrites** the Dart files.

* To not overwrite the files, add the `--output` or `-o` flag.
* To get the contents of the formatted files, add `-o show` or `-o json`.
* To see only which files _would_ change, add `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Notify when changes occur

To make `dart format` return an exit code when formatting changes occur,
add the `--set-exit-if-changed` flag.

* If changes occur, the `dart format` command returns an exit code of `1`.
* If changes don't occur, the `dart format` command returns an exit code of `0`.

Use exit codes with continuous integration (CI) systems
so they can trigger another action in response to the exit code.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## Format on save

Most editors with Dart support can automatically format your code when you save a file.

### VS Code

To enable format on save in [VS Code](/tools/vs-code),
add the following to your `settings.json` file:

```json
{
  "[dart]": {
    "editor.formatOnSave": true
  }
}
```

### IntelliJ and Android Studio

To enable format on save in [IntelliJ or Android Studio](/tools/jetbrains-plugin):

1. Open the [IDE settings](/tools/jetbrains-plugin#settings).
2. Go to **Languages & Frameworks > Dart**.
3. Check the **Format code on save** checkbox.

## What changes?

`dart format` makes the following formatting changes:

* Removes whitespace.
* Wraps every line to 80 characters long or shorter.
* Adds trailing commas to any argument or parameter list
that splits across multiple lines, and removes them from ones that don't.
* Might move comments before or after a comma.

To learn more about best practices for writing and styling Dart code,
check out the [Dart style guide][].

### Configuring formatter page width

When you run `dart format`, the formatter defaults to
80 character line length or shorter. 
If you'd like to configure the line length for your project,
you can add a top-level `formatter` section to the
[`analysis_options.yaml`][] file, like so:

```yaml title="analysis_options.yaml"
formatter:
  page_width: 123
```

With the analysis options file typically at the root,
the configured line length will apply to everything in the package.

You can also configure individual files' line length,
overriding the analysis options file,
with a marker comment at the top of the file before any other code:

```dart
// dart format width=123
```

:::version-note
Configurable page width requires
a [language version][] of at least 3.7.
:::

## Learn more

To learn about additional command-line options,
use the `dart help` command or see the documentation for the
[dart_style package][dart_style]

```console
$ dart help format
```

Check out the [formatter FAQ][] for more context behind formatting decisions.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[`analysis_options.yaml`]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ