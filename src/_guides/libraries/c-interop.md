---
title: "C interop using dart:ffi"
description: "To use C code in your Dart program, use the dart:ffi library (currently in preview)."
hw: "https://github.com/dart-lang/samples/tree/master/ffi/hello_world"
samples: "https://github.com/dart-lang/samples/tree/master/ffi"
sqllite: "https://github.com/dart-lang/sdk/tree/master/samples/ffi/sqlite"
---

Dart mobile, command-line, and server apps running on the [Dart Native
platform](/platforms/) can use the dart:ffi library to call native C APIs.
_FFI_ stands for [_foreign function interface._][FFI]
Other terms for similar functionality include _native interface_
and _language bindings._

{{site.alert.info}}
  As of Dart 2.6, [dart:ffi is in beta,][ffi issue]
  and breaking API changes might still happen.
  If you're developing a Flutter app,
  you can get access to dart:ffi by using the Flutter dev channel,
  as described in the [Flutter dart:ffi page.][binding]
{{site.alert.end}}

API documentation is available from the dev channel:
[dart:ffi API reference.]({{site.dart_api}}/dev/dart-ffi/dart-ffi-library.html)

## Examples

The following examples show how to use the dart:ffi library:

| **Example** | **Description** |
| [hello_world][] | How to call a C function with no arguments and no return value. |
| [primitives][] | How to call C functions that have arguments and return values that are **ints or pointers**. Also demonstrates **varargs**.
| [structs][] | How to use structs to pass **strings** to and from C and to handle **simple and complex C structures**. |
| [sqllite][] | An example in the Dart SDK repo that comes with a [mini tutorial.][] |


## Walkthrough of hello_world

The [hello_world example][hello_world] has the minimum necessary code for
calling a C library.

### Files

The hello_world example has the following files:

| **Source file** | **Description** |
| [hello.dart]({{ page.hw}}/hello.dart) | A Dart file that uses the `hello_world()` function from a C library. |
| [pubspec.yaml]({{ page.hw}}/pubspec.yaml) | The usual Dart [pubspec](/tools/pub/pubspec), with a lower bounds on the SDK that's at least 2.5. |
| [c/hello.h]({{ page.hw}}/c/hello.h) | Declares the `hello_world()` function. |
| [c/hello.c]({{ page.hw}}/c/hello.c) | A C file that imports `hello.h` and defines the `hello_world()` function. |
| [c/Makefile]({{ page.hw}}/c/Makefile) | A macOS-specific build file that compiles the C code into a dynamic library. |
{:.table .table-striped }

{% comment %}
[PENDING: say something about setup.sh? It doesn't seem necessary for this example, but maybe it's needed by other examples?]

<!--
  | [setup.sh]({{ page.hw}}/setup.sh) | A macOS-specific script that sets an environment variable. [PENDING: Omit from this list? Why is it necessary? I didn't seem to need it.] |
-->
{% endcomment %}

Building the C library creates two additional files:

| **Generated file** | **Description** |
| hello_world.dylib | The dynamic library loaded by the Dart app. |
| c/hello.o | An intermediate object file. |
{:.table .table-striped }

### Building and running

Here's an example of building the dynamic library and executing the Dart app:

```terminal
$ cd c
$ make dylib
gcc -dynamiclib -undefined suppress -flat_namespace hello.o -o ../hello_world.dylib
$ cd ..
$ dart hello.dart
Hello World
$
```

### Using dart:ffi

The [`hello.dart` file]({{ page.hw}}/hello.dart)
illustrates the steps for using dart:ffi to call a C function:

1. Import dart:ffi.
2. Create a typedef with the FFI type signature of the C function.
3. Create a typedef for the variable that you'll use when calling the C function.
4. Open the dynamic library that contains the C function.
5. Get a reference to the C function, and put it into a variable.
6. Call the C function.

Here's the code for each step.

1. Import dart:ffi.
```dart
import 'dart:ffi' as ffi;
```

2. Create a typedef with the FFI type signature of the C function. <br>
   Commonly used types defined by dart:ffi library include
   `Double`, `Int32`, `NativeFunction`, `Pointer`, `Struct`, `Uint8`, and `Void`.
```dart
typedef hello_world_func = ffi.Void Function();
```

3. Create a typedef for the variable that you'll use when calling the C function.
```dart
typedef HelloWorld = void Function();
```

4. Open the dynamic library that contains the C function.
```dart
  final dylib = ffi.DynamicLibrary.open('hello_world.dylib');
```

5. Get a reference to the C function, and put it into a variable.
   This code uses the typedefs defined in steps 2 and 3, along with
   the dynamic library variable from step 4.
```dart
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
      .asFunction();
```

6. Call the C function.
```dart
  hello();
```

Once you understand the hello_world example, you should be ready to look at the
[other dart:ffi examples](#examples).


## Bundling and loading C libraries

How you bundle (or _package_ or _distribute_)
a C library with your package or app and then load that library
depends on your platform and the type of library.
For details, see the following:

* [Flutter dart:ffi page][binding]
* [dart:ffi examples]({{ page.samples }})

[binding]: https://flutter.dev/docs/development/platform-integration/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[ffi issue]: https://github.com/dart-lang/sdk/issues/34452
[hello_world]: {{ page.hw }}
[primitives]: {{ page.samples }}/primitives
[structs]: {{ page.samples }}/structs
[sqllite]: {{ page.sqllite }}
[mini tutorial.]: {{ page.sqllite }}/docs/sqlite-tutorial.md
