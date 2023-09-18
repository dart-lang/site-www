---
title: Write command-line apps
description: Basics for command-line apps.
nextpage:
  url: /tutorials/server/fetch-data
  title: Fetch data from the internet
prevpage:
  url: /tutorials/server/get-started
  title: "Get started: Command-line and server apps"
---

{% assign _api = site.dart-api | append: '/' | append: site.data.pkg-vers.SDK.channel -%}
{% assign argsAPI = site.pub-api | append: '/args/latest/args' -%}
{% assign ioAPI = _api | append: '/dart-io' -%}

<?code-excerpt replace="/ ?\/\/!tip.*//g"?>
<style>
[data-toggle="popover"] { background: #fffde7; }
</style>

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * Command-line applications need to do input and output.
  * The dart:io library provides I/O functionality.
  * The args package helps define and parse command-line arguments.
  * A `Future` object represents a value that will be available at some time in the future.
  * Streams provide a series of asynchronous data events.
  * Most input and output requires the use of streams.
</div>

{{site.alert.note}}
  This tutorial uses the `async` and `await` language features, which rely on
  the [Future]({{_api}}/dart-async/Future-class.html) and
  [Stream]({{_api}}/dart-async/Stream-class.html)
  classes for asynchronous support.
  To learn more about these features, see the
  [asynchronous programming codelab](/codelabs/async-await) and the
  [streams tutorial](/tutorials/language/streams).
{{site.alert.end}}

This tutorial teaches you how to build command-line apps
and shows you a few small command-line applications.
These programs use resources that most command-line applications need,
including the standard output, error, and input streams,
command-line arguments, files and directories, and more.

## Running an app with the standalone Dart VM

To run a command-line app in the Dart VM, use `dart run`.
The `dart` commands are included with the [Dart SDK](/tools/sdk).

{{site.alert.important}}
  The location of the SDK installation directory
  (we'll call it _&lt;sdk-install-dir&gt;_) depends on your platform
  and how you installed the SDK.
  You can find `dart` in _&lt;sdk-install-dir&gt;_/bin.
  By putting this directory in your PATH
  you can refer to the `dart` command by name.
{{site.alert.end}}

Let's run a small program.

 1. Create a file called `hello_world.dart` that contains this code:

    <?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
    ```dart
    void main() {
      print('Hello, World!');
    }
    ```

 2. In the directory that contains the file you just created, run the program:

    ```terminal
    $ dart run hello_world.dart
    Hello, World!
    ```

The Dart tool supports many commands and options.
Use `dart --help` to see commonly used commands and options.
Use `dart --verbose` to see all options.

## Overview of the dcat app code

This tutorial covers the details of a small sample app called `dcat`, which
displays the contents of any files listed on the command line. This app uses
various classes, functions, and properties available to command-line apps. For a
brief description of key app features, click the highlighted code below.

{% include_relative _dcat-example.html %}


### Getting dependencies

You might notice that dcat depends on a package named **args**.
To get the args package, use the
[pub package manager](/guides/packages).

A real app has tests, license files, dependency files, examples, and so on.
For the first app though, we can easily create only what is necessary
with the [`dart create`](/tools/dart-create) command.

1. Inside a directory, create the dcat app with the dart tool.
   
   ```terminal
   $ dart create dcat
   ```
   
2. Change to the created directory.

   ```terminal
   $ cd dcat
   ```
   
3. Inside the `dcat` directory, use [dart pub add](/tools/pub/cmd/pub-add) 
   to add the `args` package as a dependency. This adds `args` to 
   the list of your dependencies found in the `pubspec.yaml` file.

   ```terminal
   $ dart pub add args
   ```

4. Open the `bin/dcat.dart` file and copy the preceding code into it.

{{site.alert.note}}
  To learn more about using packages and organizing your code, see the
  [package documentation](/guides/packages) and
  [layout conventions](/tools/pub/package-layout).
{{site.alert.end}}

### Running dcat

Once you have your app's dependencies,
you can run the app from the command line over any text file,
like `pubspec.yaml`:

```terminal
$ dart run bin/dcat.dart -n pubspec.yaml
1 name: dcat
2 description: A sample command-line application.
3 version: 1.0.0
4 # repository: https://github.com/my_org/my_repo
5 
6 environment:
7   sdk: '>=2.19.0 <3.0.0'
8 
9 # dependencies:
10 #   path: ^1.8.0
11 
12 dev_dependencies:
13   lints: ^2.0.0
14   test: ^1.21.0
15 dependencies:
16   args: ^2.3.2
```

This command displays each line of the specified file. Because the `-n` argument
is present, a line number is displayed before each line.

## Parsing command-line arguments

The [args package]({{site.pub-pkg}}/args) provides
parser support for transforming command-line arguments
into a set of options, flags, and additional values.
Import the package's
[args library]({{argsAPI}}/args-library.html)
as follows:

<?code-excerpt "misc/bin/dcat/dcat.dart" retain="package:args"?>
```dart
import 'package:args/args.dart';
```

The `args` library contains these classes, among others:

| Class | Description |
|---|---|
| [ArgParser]({{argsAPI}}/ArgParser-class.html) | A command-line argument parser. |
| [ArgResults]({{argsAPI}}/ArgResults-class.html) | The result of parsing command-line arguments using `ArgParser`. |
{: .table }

Here is the `dcat` code that uses these classes to parse and store command-line
arguments:

<?code-excerpt "misc/bin/dcat/dcat.dart (arg processing)" plaster="none" replace="/(ArgR.*|List[^\)]*|\..*|parser.*|argResults\S[^);]+)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void main([!List<String> arguments!]) {
  exitCode = 0; // presume success
  final [!parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');!]


  [!ArgResults argResults = parser.parse(arguments);!]
  final paths = [!argResults.rest!];

  dcat(paths, showLineNumbers: [!argResults[lineNumber] as bool!]);
}
{% endprettify %}

The runtime passes command-line arguments to the app's `main()` function as a
list of strings. The `ArgParser` is configured to parse the `-n` flag. The
result of parsing command-line arguments is stored in `argResults`.

The following diagram shows how the `dcat` command line used above
is parsed into an `ArgResults` object.

![Run dcat from the command-line](/assets/img/tutorials/server/dcat-dart-run.svg){:width="350"}

You can access flags and options by name,
treating an `ArgResults` like a `Map`.
You can access other values using the `rest` property.

The [API reference]({{argsAPI}}/args-library.html)
for the `args` library provides detailed information to help you use
the `ArgParser` and `ArgResults` classes.

## Reading and writing with stdin, stdout, and stderr

Like other languages,
Dart has standard output, standard error, and standard input streams.
The standard I/O streams are defined at the top level of the dart:io library:

| Stream | Description |
|---|---|
| [stdout]({{ioAPI}}/stdout.html) | The standard output |
| [stderr]({{ioAPI}}/stderr.html) | The standard error |
| [stdin]({{ioAPI}}/stdin.html) | The standard input |
{: .table }

Import the dart:io library as follows:

<?code-excerpt "misc/bin/dcat/dcat.dart" retain="dart:io"?>
```dart
import 'dart:io';
```

{{site.alert.note}}
  Web apps (apps that depend on dart:html) can't use the dart:io library.
{{site.alert.end}}

### stdout

Here's the code from the `dcat` program that writes the line number to
the `stdout` (if the `-n` flag is set) followed by the line from the file.

<?code-excerpt "misc/bin/dcat/dcat.dart (showLineNumbers)" replace="/stdout\..*/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
if (showLineNumbers) {
  [!stdout.write('${lineNumber++} ');!]
}
[!stdout.writeln(line);!]
{% endprettify %}

The `write()` and `writeln()` methods take an object of any type,
convert it to a string, and print it. The `writeln()` method
also prints a newline character.
`dcat` uses the `write()` method to print the line number so the
line number and text appear on the same line.

You can also use the `writeAll()` method to print a list of objects,
or use `addStream()` to asynchronously print all the elements from a stream.

`stdout` provides more functionality than the `print()` function.
For example, you can display the contents of a stream with `stdout`.
However, you must use `print()` instead of `stdout`
for programs that run on the web.

### stderr

Use `stderr` to write error messages to the console.
The standard error stream has the same methods as `stdout`,
and you use it in the same way.
Although both `stdout` and `stderr` print to the console,
their output is separate
and can be redirected or piped at the command line
or programmatically to different destinations.

This code from `dcat` prints an error message if the user
tries to list a directory.

<?code-excerpt "misc/bin/dcat/dcat.dart (await FileSystemEntity)" replace="/stderr\..*/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
if (await FileSystemEntity.isDirectory(path)) {
  [!stderr.writeln('error: $path is a directory');!]
} else {
  exitCode = 2;
}
{% endprettify %}

### stdin

The standard input stream typically
reads data synchronously from the keyboard,
although it can read asynchronously
and get input piped in from the standard output of another program.

Here's a small program that reads a single line from `stdin`:

<?code-excerpt "misc/bin/dcat/dcat1.dart"?>
```dart
import 'dart:io';

void main() {
  stdout.writeln('Type something');
  final input = stdin.readLineSync();
  stdout.writeln('You typed: $input');
}
```

The `readLineSync()` method reads text from the standard input stream,
blocking until the user types in text and presses return.
This little program prints out the typed text.

In the `dcat` program,
if the user does not provide a filename on the command line,
the program instead reads from stdin
using the `pipe()` method.
Because `pipe()` is asynchronous
(returning a future, even though this code doesn't use that return value),
the code that calls it uses `await`.

<?code-excerpt "misc/bin/dcat/dcat.dart (pipe)" replace="/pipe/[!$&!]/g"?>
{% prettify dart tag=pre+code %}

await stdin.[!pipe!](stdout);
{% endprettify %}

In this case, the user types in lines of text,
and the program copies them to stdout.
The user signals the end of input by pressing <kbd>Control</kbd>+<kbd>D</kbd>
(or <kbd>Control</kbd>+<kbd>Z</kbd> on Windows).

```terminal
$ dart run bin/dcat.dart
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
```

## Getting info about a file

The [FileSystemEntity]({{ioAPI}}/FileSystemEntity-class.html)
class in the dart:io library provides properties and static methods
that help you inspect and manipulate the file system.

For example, if you have a path,
you can determine whether the path is a file, a directory, a link, or not found
by using the `type()` method from the `FileSystemEntity` class.
Because the `type()` method accesses the file system,
it performs the check asynchronously.

The following code from the `dcat` example uses `FileSystemEntity`
to determine if the path provided on the command line is a directory.
The future returns a boolean that indicates if the path is a directory or not.
Because the check is asynchronous, the code calls `isDirectory()`
using `await`.

<?code-excerpt "misc/bin/dcat/dcat.dart (await FileSystemEntity)" replace="/await.*path\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
if ([!await FileSystemEntity.isDirectory(path)!]) {
  stderr.writeln('error: $path is a directory');
} else {
  exitCode = 2;
}
{% endprettify %}

Other interesting methods in the `FileSystemEntity` class
include `isFile()`, `exists()`, `stat()`, `delete()`,
and `rename()`, all of which also use a future to return a value.

`FileSystemEntity` is the superclass for the `File`, `Directory`, and `Link` classes.

## Reading a file

`dcat` opens each file listed on the command line
with the `openRead()` method, which returns a stream.
The `await for` block waits for the file to be read
asynchronously. The data prints to stdout when it
becomes available on the stream.

<?code-excerpt "misc/bin/dcat/dcat.dart (for path)" remove="/^\s*\/\/!tip.*/" replace="/(    )((await for| *stdout| *if| *}).*)/$1[!$2!]/g"?>
{% prettify dart tag=pre+code %}
for (final path in paths) {
  var lineNumber = 1;
  final lines = utf8.decoder
      .bind(File(path).openRead())
      .transform(const LineSplitter());
  try {
    [!await for (final line in lines) {!]
    [!  if (showLineNumbers) {!]
    [!    stdout.write('${lineNumber++} ');!]
    [!  }!]
    [!  stdout.writeln(line);!]
    [!}!]
  } catch (_) {
    await _handleError(path);
  }
}
{% endprettify %}

The following shows the rest of the code, which uses two decoders that
transform the data before making it available in the `await for` block.
The UTF8 decoder converts the data into Dart strings.
`LineSplitter` splits the data at newlines.

<?code-excerpt "misc/bin/dcat/dcat.dart (for path)" remove="/^\s*\/\/!tip.*/" replace="/utf8.decoder|LineSplitter()/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
for (final path in paths) {
  var lineNumber = 1;
  final lines = [!utf8.decoder!]
      .bind(File(path).openRead())
      .transform(const [!LineSplitter!]());
  try {
    await for (final line in lines) {
      if (showLineNumbers) {
        stdout.write('${lineNumber++} ');
      }
      stdout.writeln(line);
    }
  } catch (_) {
    await _handleError(path);
  }
}
{% endprettify %}

The dart:convert library contains these and other data converters,
including one for JSON.
To use these converters you need to import the dart:convert library:

<?code-excerpt "misc/bin/dcat/dcat.dart" retain="dart:convert"?>
```dart
import 'dart:convert';
```

## Writing a file

The easiest way to write text to a file is to create a
[File]({{ioAPI}}/File-class.html)
object and use the `writeAsString()` method:

<?code-excerpt "misc/lib/tutorial/cmdline.dart (write quote)"?>
```dart
final quotes = File('quotes.txt');
const stronger = 'That which does not kill us makes us stronger. -Nietzsche';

await quotes.writeAsString(stronger, mode: FileMode.append);
```

The `writeAsString()` method writes the data asynchronously.
It opens the file before writing and closes the file when done.
To append data to an existing file, you can use the optional
parameter `mode` and set its value to `FileMode.append`.
Otherwise, the mode is `FileMode.write` and the previous contents of the file,
if any, are overwritten.

If you want to write more data, you can open the file for writing.
The `openWrite()` method returns an IOSink (the same type as stdin and stderr).
You can continue to write to the file until done,
at which time, you must close the file.
The `close()` method is asynchronous and returns a future.

<?code-excerpt "misc/lib/tutorial/cmdline.dart (write quotes)"?>
```dart
final quotes = File('quotes.txt').openWrite(mode: FileMode.append);

quotes.write("Don't cry because it's over, ");
quotes.writeln('smile because it happened. -Dr. Seuss');
await quotes.close();
```

## Getting environment information

{% assign PlatformAPI = ioAPI | append: '/Platform' -%}

Use the [Platform]({{PlatformAPI}}-class.html) class
to get information about the machine and OS that the program is running on.

[Platform.environment]({{PlatformAPI}}/environment.html)
provides a copy of the environment
variables in an immutable map. If you need a mutable map (modifiable copy) you
can use `Map.of(Platform.environment)`.

<?code-excerpt "misc/lib/tutorial/cmdline.dart (env)"?>
```dart
final envVarMap = Platform.environment;

print('PWD = ${envVarMap['PWD']}');
print('LOGNAME = ${envVarMap['LOGNAME']}');
print('PATH = ${envVarMap['PATH']}');
```

`Platform` provides other useful properties that give
information about the machine, OS, and currently
running program. For example:

- [Platform.isMacOS()]({{PlatformAPI}}/isMacOS.html)
- [Platform.numberOfProcessors]({{PlatformAPI}}/numberOfProcessors.html)
- [Platform.script]({{PlatformAPI}}/script.html)

## Setting exit codes

The dart:io library defines a top-level property,
`exitCode`, that you can change to set the exit code for
the current invocation of the Dart VM.
An exit code is a number passed from
the Dart program to the parent process
to indicate the success, failure, or other state of the
execution of the program.

The `dcat` program sets the exit code
in the `_handleError()` function to indicate that an error
occurred during execution.

<?code-excerpt "misc/bin/dcat/dcat.dart (_handleError)" remove="/^\s*\/\/!tip.*/" replace="/exit.*;/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    [!exitCode = 2;!]
  }
}
{% endprettify %}

An exit code of 2 indicates that the program encountered an error.

An alternative to using `exitCode` is to use the top-level `exit()` function,
which sets the exit code and quits the program immediately.
For example, the `_handleError()` function could call `exit(2)`
instead of setting `exitCode` to 2,
but `exit()` would quit the program
and it might not process all of the files on the command line.

{{site.alert.info}}
  Generally speaking, you're better off using the `exitCode` property,
  which sets the exit code but allows the program to continue through to its
  natural completion.
{{site.alert.end}}

Although you can use any number for an exit code,
by convention, the codes in the table below have the following meanings:

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Warnings |
| 2 | Errors |
{: .table }

## Summary

This tutorial described some basic API found in these classes from the dart:io library:

| API | Description |
|---|---|
| [IOSink]({{ioAPI}}/IOSink-class.html) | Helper class for objects that consume data from streams |
| [File]({{ioAPI}}/File-class.html) | Represents a file on the native file system |
| [Directory]({{ioAPI}}/Directory-class.html) | Represents a directory on the native file system |
| [FileSystemEntity]({{ioAPI}}/FileSystemEntity-class.html) | Superclass for File and Directory |
| [Platform]({{ioAPI}}/Platform-class.html) | Provides information about the machine and operating system |
| [stdout]({{ioAPI}}/stdout.html) | The standard output stream |
| [stderr]({{ioAPI}}/stderr.html) | The standard error stream |
| [stdin]({{ioAPI}}/stdin.html) | The standard input stream |
| [exitCode]({{ioAPI}}/exitCode.html) | Access and set the exit code |
| [exit()]({{ioAPI}}/exit.html) | Sets the exit code and quits |
{: .table }

In addition, this tutorial covers two classes that help with command-line arguments:
[ArgParser]({{argsAPI}}/ArgParser-class.html) and
[ArgResults.]({{argsAPI}}/ArgResults-class.html)

For more classes, functions, and properties,
consult to the API reference for
[dart:io,]({{ioAPI}}/dart-io-library.html)
[dart:convert,]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html)
and the [args]({{argsAPI}}/args-library.html) package.  

For another example of a command line app, 
see the [command_line][] sample.

[command_line]: https://github.com/dart-lang/samples/tree/main/command_line

## What next?

If you're interested in server-side programming,
check out the [next tutorial](/tutorials/server/httpserver).
