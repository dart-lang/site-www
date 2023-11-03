---
title: 'Java interop using package:jnigen'
description: 'To use Java in your Dart program, use package:jnigen.'
example: 'https://github.com/HosseinYousefi/jnigen_example/tree/main'
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on
Android, Windows, macOS, and Linux can use [`package:jni`][jni-pkg]
and [`package:jnigen`][jnigen-pkg]
to call Java and Kotlin APIs.

{{site.alert.note}}
  This interop feature is **experimental**,
  and [in active development](https://github.com/dart-lang/sdk/issues/49674).
{{site.alert.end}}

`package:jni` allows Dart code to interact
with Java through [JNI][jnidoc].
However, doing so involves a lot of boilerplate code,
so you can use `package:jnigen` to automatically generate
the Dart bindings for a given Java API.

You can compile Kotlin to Java bytecode, allowing `package:jnigen`
to generate bindings for Kotlin as well.

[jni-pkg]: {{site.pub-pkg}}/jni
[jnigen-pkg]: {{site.pub-pkg}}/jnigen
[jnidoc]: https://docs.oracle.com/en/java/javase/17/docs/specs/jni/index.html

## Simple Java example

This guide walks you through [an example]({{page.example}})
that uses `package:jnigen` to generate bindings for a simple class.

### Prerequisites

- JDK
- [Maven][]
- (Optional) [`clang-format`][] to format the generated C bindings

[Maven]: https://maven.apache.org/
[`clang-format`]: https://clang.llvm.org/docs/ClangFormat.html

### Configure `jnigen`

First, add `package:jni` as a dependency and
`package:jnigen` as a [dev dependency][].

```terminal
$ dart pub add jni dev:jnigen
```

Next, create a top-level file called `jnigen.yaml`. 
This file contains the configuration for generating the bindings.

```yaml
output:
  c:
    library_name: example
    path: src/example/
  dart:
    path: lib/example.dart
    structure: single_file

source_path:
  - 'java/'
classes:
  - 'dev.dart.Example'
```

`path` specifies the path for the generated `c` and `dart` bindings.

`source_path` specifies the path of the Java source file that
you want to generate bindings for, 
and `classes` specifies the Java class.

`java/dev/dart/Example.java` contains a very simple class, which
has a public static method called `sum`:

```java
package dev.dart;

public class Example {
  public static int sum(int a, int b) {
    return a + b;
  }
}
```

### Generate the Dart bindings

To generate the Dart (and C) bindings, run `jnigen` and
specify the config file using the `--config` option:

```terminal
$ dart run jnigen --config jnigen.yaml
```

In this example, this generates
[lib/example.dart]({{page.example}}/lib/example.dart), just
as you specified in `jnigen.yaml`.

This file contains a class called `Example`, 
which has a static method called `sum`, 
just like the Java file.

### Use the bindings

Now you're ready to load and interact with the generated library.
The example app, [bin/sum.dart]({{page.example}}/bin/sum.dart), gets 
two numbers as arguments and prints their sum. 
Using the `Example.sum` method is identical to Java.

```dart
// a and b are integer arguments
print(Example.sum(a, b));
```

### Run the example

Before running the example, 
you must build the dynamic libraries for `jni` and the generated C files. 
The Java sources also must be compiled. To do so, run:

```terminal
$ dart run jni:setup -p jni -s src/example
$ javac java/dev/dart/Example.java
```

Now you can run the example:

```terminal
$ dart run jnigen_example:sum 17 25
```

Which outputs `42`!

## More examples

The following are some more comprehensive examples of using `package:jnigen`:

| **Example**             | **Description**                                                                                 |
|-------------------------|-------------------------------------------------------------------------------------------------|
| [in_app_java][]         | Demonstrates how to include custom Java code in a Flutter application and call it use `jnigen`. |
| [pdfbox_plugin][]       | Example of a Flutter plugin that provides bindings to the [Apache PDFBox][] library.            |
| [notification_plugin][] | Example of a reusable Flutter plugin with custom Java code that uses Android libraries.         |
{:.table}

[dev dependency]: /tools/pub/dependencies#dev-dependencies
[in_app_java]: https://github.com/dart-lang/jnigen/tree/main/jnigen/example/in_app_java
[notification_plugin]: https://github.com/dart-lang/jnigen/tree/main/jnigen/example/notification_plugin
[pdfbox_plugin]: https://github.com/dart-lang/jnigen/tree/main/jnigen/example/pdfbox_plugin
[Apache PDFBox]: https://pdfbox.apache.org/
