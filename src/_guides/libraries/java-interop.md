---
title: "Java interop using package:jnigen"
description: "To use Java in your Dart program, use package:jnigen."
jnigen: "https://pub.dev/packages/jnigen"
jni: "https://pub.dev/packages/jni"
example: "https://github.com/HosseinYousefi/jnigen_example/tree/main"
jnidoc: "https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/jniTOC.html"
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on Android, Windows
and Linux can use [`package:jni`]({{page.jni}})
and [`package:jnigen`]({{page.jnigen}})
to call Java and Kotlin APIs.

{{site.alert.note}}
  This interop feature is **experimental**,
  and [in active development](https://github.com/dart-lang/jnigen/issues).
{{site.alert.end}}

`package:jni` allows Dart code to interact
with Java through [JNI]({{page.jnidoc}}). 
However, doing so involves a lot of boilerplate code,
so you can use `package:jnigen` to automatically generate
the Dart bindings for a given Java API.

You can decompile Kotlin to Java, allowing `package:jnigen`
to generate bindings for Kotlin as well.

## Simple Java Example

This guide walks you through [an example]({{page.example}})
that uses `package:jnigen` to generate bindings for a simple class
that can show a toast.

Along with JDK, maven is required. 

It's recommended to have `clang-format` installed to format the generated
C bindings.

### Configuring jnigen

First, add `package:jni` as a dependency and `package:jnigen`
as a dev dependency.

```terminal
$ dart pub add jni
$ dart pub add --dev jnigen
```

Next, create a top-level file called `jnigen.yaml`. This will contain
the configuration for generating the bindings.

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

`source_path` specifies the path of the java source file that we want to
generate bindings for, and `classes` specifies the Java class.

`java/dev/dart/Example.java` contains a very simple class, which has a public
static method called `sum`:

```java
package dev.dart;

public class Example {
  public static int sum(int a, int b) {
    return a + b;
  }
}
```

### Generating the Dart bindings

To generate the Dart (and C) bindings, run jnigen and specify the config file
using the `--config` option.

```terminal
$ dart run jnigen --config jnigen.yaml
```

For this example, this will generate
[lib/example.dart]({{page.example}}/lib/example.dart), just as we specified in
`jnigen.yaml`.

This file contains a class called `Example`, which has a static method called
`sum`, just like the Java file.

### Using the bindings

Now you're ready to load and interact with the generated library.
The example app, [bin/sum.dart]({{page.example}}/bin/sum.dart), gets two numbers
as arguments and prints their sum. Using the `Example.sum` method is identical
to Java.

```dart
// a and b are integer arguments passed.
print(Example.sum(a, b));
```

### Running the example

Before running the example, you must build the dynamic libraries for jni and the
generated C files. The Java sources also must be compiled. To do so, run:

```terminal
$ dart run jni:setup -p jni -s src/example
$ javac java/dev/dart/Example.java
```

Now you're ready to run the example:

```terminal
$ dart run jnigen_example:sum 17 25
```

Which outputs `42`!
