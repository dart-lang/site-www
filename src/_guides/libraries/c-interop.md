---
title: "C interop using dart:ffi"
description: "To use C code in your Dart program, use the dart:ffi library."
hw: "https://github.com/dart-lang/samples/tree/master/ffi/hello_world"
samples: "https://github.com/dart-lang/samples/tree/master/ffi"
sqlite: "https://github.com/dart-lang/sdk/tree/master/samples/ffi/sqlite"
---

Dart mobile, command-line, and server apps running on the [Dart Native
platform](/overview#platform/) can use the dart:ffi library to call native C APIs.
_FFI_ stands for [_foreign function interface._][FFI]
Other terms for similar functionality include _native interface_
and _language bindings._

API documentation is available in the
[dart:ffi API reference.]({{site.dart_api}}/dart-ffi/dart-ffi-library.html)

## Examples

The following examples show how to use the dart:ffi library:

| **Example** | **Description** |
| [hello_world][] | How to call a C function with no arguments and no return value. |
| [primitives][] | How to call C functions that have arguments and return values that are **ints or pointers**. Also demonstrates **varargs**.
| [structs][] | How to use structs to pass **strings** to and from C and to handle **simple and complex C structures**. |
| [sqlite][] | An example in the Dart SDK repo that comes with a [mini tutorial.][] |


## Walkthrough of hello_world

The [hello_world example][hello_world] has the minimum necessary code for
calling a C library.

### Files

The hello_world example has the following files:

| **Source file** | **Description** |
| [hello.dart]({{page.hw}}/hello.dart) | A Dart file that uses the `hello_world()` function from a C library. |
| [pubspec.yaml]({{page.hw}}/pubspec.yaml) | The usual Dart [pubspec](/tools/pub/pubspec), with a lower bounds on the SDK that's at least 2.6. |
| [hello_library/hello.h]({{page.hw}}/hello_library/hello.h) | Declares the `hello_world()` function. |
| [hello_library/hello.c]({{page.hw}}/hello_library/hello.c) | A C file that imports `hello.h` and defines the `hello_world()` function. |
| [hello_library/CMakeLists.txt]({{page.hw}}/hello_library/CMakeLists.txt) | A CMake build file for compiling the C code into a dynamic library. |
{:.table .table-striped }

{% comment %}
[PENDING: say something about other files, like setup.sh?]
[PENDING: clarify that the build instructions reflect Mac.]
[TODO (https://github.com/dart-lang/site-www/issues/2219): Fix build instructions.]
{% endcomment %}

Building the C library creates several files,
including a dynamic library file named
`libhello.dylib` (macOS), `libhello.dll` (Windows), or
`libhello.so` (Linux).


### Building and running

Here's an example of building the dynamic library and executing the Dart app:

```terminal
$ cd hello_library
$ cmake .
...
$ make
...
$ cd ..
$ dart pub get
$ dart run hello.dart
Hello World
```

{{site.alert.info}}
  **On macOS,** the Dart VM (`dart`) can load only **signed libraries.**
  For details and workarounds,
  see [SDK issue #38314.][38314]
{{site.alert.end}}

[38314]: https://github.com/dart-lang/sdk/issues/38314
  

### Using dart:ffi

The [`hello.dart` file]({{page.hw}}/hello.dart)
illustrates the steps for using dart:ffi to call a C function:

1. Import dart:ffi.
2. Import the path library that you'll use to store the path of dynamic library.
3. Create a typedef with the FFI type signature of the C function.
4. Create a typedef for the variable that you'll use when calling the C function.
5. Create a variable to store the path of the dynamic library.
6. Open the dynamic library that contains the C function.
7. Get a reference to the C function, and put it into a variable.
8. Call the C function.

Here's the code for each step.

1. Import dart:ffi.
```dart
import 'dart:ffi' as ffi;
```

2. Import the path library that you'll use to store the path of dynamic library.
```dart
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;
```

3. Create a typedef with the FFI type signature of the C function. <br>
   Commonly used types defined by dart:ffi library include
   `Double`, `Int32`, `NativeFunction`, `Pointer`, `Struct`, `Uint8`, and `Void`.
```dart
typedef hello_world_func = ffi.Void Function();
```

4. Create a typedef for the variable that you'll use when calling
   the C function.
```dart
typedef HelloWorld = void Function();
```

5. Create a variable to store the path of the dynamic library.
```dart
var libraryPath = path.join(Directory.current.path, 'hello_library',
    'libhello.so');
if (Platform.isMacOS) { 
  libraryPath = path.join(Directory.current.path, 'hello_library', 
      'libhello.dylib');
} else if (Platform.isWindows) { 
  libraryPath = path.join(Directory.current.path, 'hello_library', 
      'Debug', 'hello.dll');
} 
```

6. Open the dynamic library that contains the C function.
```dart
  final dylib = ffi.DynamicLibrary.open(libraryPath);
```

7. Get a reference to the C function, and put it into a variable.
   This code uses the typedefs defined in steps 2 and 3, along with
   the dynamic library variable from step 4.
```dart
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
      .asFunction();
```

8. Call the C function.
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
* [dart:ffi examples]({{page.samples}})

## Generating FFI bindings with `package:ffigen`

For large API surfaces it can be time consuming to write the Dart bindings
that integrate with the C code. To reduce this burden, you can use the
[`package:ffigen`][ffigen]
binding generator to automatically create FFI wrappers from C header files.


[binding]: https://flutter.dev/docs/development/platform-integration/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[ffi issue]: https://github.com/dart-lang/sdk/issues/34452
[hello_world]: {{page.hw}}
[primitives]: {{page.samples}}/primitives
[structs]: {{page.samples}}/structs
[sqlite]: {{page.sqlite}}
[mini tutorial.]: {{page.sqlite}}/docs/sqlite-tutorial.md
[ffigen]: {{site.pub-pkg}}/ffigen
