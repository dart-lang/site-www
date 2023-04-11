---
title: "C interop using dart:ffi"
description: "To use C code in your Dart program, use the dart:ffi library."
hw: "https://github.com/dart-lang/samples/tree/main/ffi/hello_world"
samples: "https://github.com/dart-lang/samples/tree/main/ffi"
---

Dart mobile, command-line, and server apps 
running on the [Dart Native platform](/overview#platform) 
can use the `dart:ffi` library to call native C APIs,
and to read, write, allocate, and deallocate native memory.
_FFI_ stands for [_foreign function interface._][FFI]
Other terms for similar functionality include
_native interface_ and _language bindings._

API documentation is available in the
[`dart:ffi` API reference.]({{site.dart-api}}/dart-ffi/dart-ffi-library.html)

## Examples

The following examples show how to use the `dart:ffi` library:

| **Example**     | **Description**                                                                                         |
|-----------------|---------------------------------------------------------------------------------------------------------|
| [hello_world][] | How to call a C function with no arguments and no return value.                                         |
| [primitives][]  | How to call C functions that have arguments and return values that are **ints or pointers**.            |
| [structs][]     | How to use structs to pass **strings** to and from C and to handle **simple and complex C structures**. |
| [sqlite][]      | An example in the Dart SDK repo that comes with a [mini tutorial.][]                                    |


## Walkthrough of hello_world

The [hello_world example][hello_world] has the minimum necessary code
for calling a C library.

### Files

The hello_world example has the following files:

| **Source file**                                                          | **Description**                                                                                  |
|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| [hello.dart]({{page.hw}}/hello.dart)                                     | A Dart file that uses the `hello_world()` function from a C library.                             |
| [pubspec.yaml]({{page.hw}}/pubspec.yaml)                                 | The Dart [pubspec](/tools/pub/pubspec) file, with a lower bounds on the SDK that's at least 2.6. |
| [hello_library/hello.h]({{page.hw}}/hello_library/hello.h)               | Declares the `hello_world()` function.                                                           |
| [hello_library/hello.c]({{page.hw}}/hello_library/hello.c)               | A C file that imports `hello.h` and defines the `hello_world()` function.                        |
| [hello_library/hello.def]({{page.hw}}/hello_library/hello.def)           | A module-definition file which specifies information used when building a DLL.                   |
| [hello_library/CMakeLists.txt]({{page.hw}}/hello_library/CMakeLists.txt) | A CMake build file for compiling the C code into a dynamic library.                              |
{:.table .table-striped }

{% comment %}
[PENDING: say something about other files, like setup.sh?]
[TODO (https://github.com/dart-lang/site-www/issues/2219): Fix build instructions.]
{% endcomment %}

Building the C library creates several files,
including a dynamic library file named
`libhello.dylib` (macOS), 
`libhello.dll` (Windows), or
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
  **On macOS,** executables, including the Dart VM (`dart`),
  can load only **signed libraries.**
  For more information on signing libraries, 
  see Apple's [Code Signing Guide.][codesign]
{{site.alert.end}}

[codesign]: https://developer.apple.com/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html
  

### Using dart:ffi

The [`hello.dart` file]({{page.hw}}/hello.dart)
illustrates the steps for using `dart:ffi` to call a C function:

1. Import `dart:ffi`.
2. Import the path library that you'll use to store the path of dynamic library.
3. Create a typedef with the FFI type signature of the C function.
4. Create a typedef for the variable that you'll use when calling the C function.
5. Create a variable to store the path of the dynamic library.
6. Open the dynamic library that contains the C function.
7. Get a reference to the C function, and put it into a variable.
8. Call the C function.

Here's the code for each step.

1. Import `dart:ffi`.
```dart
import 'dart:ffi' as ffi;
```

2. Import the path library that you'll use to store the path of dynamic library.
```dart
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;
```

3. Create a typedef with the FFI type signature of the C function. <br>
   See [Interfacing with native types](#interfacing-with-native-types)
   for commonly used types defined by `dart:ffi` library.
```dart
typedef hello_world_func = ffi.Void Function();
```

4. Create a typedef for the variable that you'll use
   when calling the C function.
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

7. Get a reference to the C function, 
   and put it into a variable.
   This code uses the typedefs defined in steps 2 and 3, 
   along with the dynamic library variable from step 4.
```dart
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
      .asFunction();
```

8. Call the C function.
```dart
  hello();
```

Once you understand the hello_world example, 
you should be ready to look at the
[other `dart:ffi` examples](#examples).


## Bundling and loading C libraries

How you bundle (or _package_ or _distribute_)
a C library with your package or app
and then load that library
depends on your platform and the type of library.
For details, see the following:

* Flutter `dart:ffi` pages: [Android][android], [iOS][ios], and [macOS][macos] 
* [`dart:ffi` examples]({{page.samples}})

## Interfacing with native types

The `dart:ffi` library provides multiple types
that implement [`NativeType`][]
and represent native types in C.

Some native types are only used as markers in type signatures
while others (or their subtypes) can be instantiated.

#### Instantiable native types

The following native types can be used as markers in type signatures
and they (or their subtypes) can be instantiated in Dart code:

| **Dart type**                                                                               | **Description**                                                  |
|---------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| [Array]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Array-class.html)     | A fixed-sized array of items. Supertype of type specific arrays. |
| [Pointer]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Pointer-class.html) | Represents a pointer into native C memory.                       |
| [Struct]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Struct-class.html)   | The supertype of all FFI struct types.                           |
| [Union]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Union-class.html)     | The supertype of all FFI union types.                            |
{:.table .table-striped }

#### Purely marker native types

The following are platform-agnostic native types
that are used only as markers in type signatures,
and can't be instantiated in Dart code:

| **Dart type**                                                                                             | **Description**                                   |
|-----------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| [Bool]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Bool-class.html)                     | Represents a native bool in C.                    |
| [Double]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Double-class.html)                 | Represents a native 64 bit double in C.           |
| [Float]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Float-class.html)                   | Represents a native 32 bit float in C.            |
| [Int8]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Int8-class.html)                     | Represents a native signed 8 bit integer in C.    |
| [Int16]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Int16-class.html)                   | Represents a native signed 16 bit integer in C.   |
| [Int32]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Int32-class.html)                   | Represents a native signed 32 bit integer in C.   |
| [Int64]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Int64-class.html)                   | Represents a native signed 64 bit integer in C.   |
| [NativeFunction]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/NativeFunction-class.html) | Represents a function type in C.                  |
| [Opaque]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Opaque-class.html)                 | The supertype of all opaque types in C.           |
| [Uint8]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Uint8-class.html)                   | Represents a native unsigned 8 bit integer in C.  |
| [Uint16]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Uint16-class.html)                 | Represents a native unsigned 16 bit integer in C. |
| [Uint32]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Uint32-class.html)                 | Represents a native unsigned 32 bit integer in C. |
| [Uint64]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Uint64-class.html)                 | Represents a native unsigned 64 bit integer in C. |
| [Void]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Void-class.html)                     | Represents the `void` type in C.                  |
{:.table .table-striped }

There are also many [ABI][] specific marker native types
that extend [AbiSpecificInteger][].
Refer to their linked API documentation for more information and
a guideline on what types they map to on specific platforms:

| **Dart type**                                                                                                 | **Description**                                                 |
|---------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| [AbiSpecificInteger][]                                                                                        | The supertype of all ABI-specific integer types.                |
| [Int]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Int-class.html)                           | Represents the `int` type in C.                                 |
| [IntPtr]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/IntPtr-class.html)                     | Represents the `intptr_t` type in C.                            |
| [Long]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Long-class.html)                         | Represents the `long int` (`long`) type in C.                   |
| [LongLong]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/LongLong-class.html)                 | Represents the `long long` type in C.                           |
| [Short]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Short-class.html)                       | Represents the `short` type in C.                               |
| [SignedChar]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/SignedChar-class.html)             | Represents the `signed char` type in C.                         |
| [Size]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Size-class.html)                         | Represents the `size_t` type in C.                              |
| [UintPtr]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UintPtr-class.html)                   | Represents the `uintptr_t` type in C.                           |
| [UnsignedChar]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UnsignedChar-class.html)         | Represents the `unsigned char` type in C.                       |
| [UnsignedInt]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UnsignedInt-class.html)           | Represents the `unsigned int` type in C.                        |
| [UnsignedLong]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UnsignedLong-class.html)         | Represents the `unsigned long int` (`unsigned long`) type in C. |
| [UnsignedLongLong]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UnsignedLongLong-class.html) | Represents the `unsigned long long` type in C.                  |
| [UnsignedShort]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/UnsignedShort-class.html)       | Represents the `unsigned short` type in C.                      |
| [WChar]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/WChar-class.html)                       | Represents the `wchar_t` type in C.                             |
{:.table .table-striped }


## Generating FFI bindings with `package:ffigen`

For large API surfaces it can be time-consuming
to write the Dart bindings that integrate with the C code.
To reduce this burden,
you can use the [`package:ffigen`][ffigen] binding generator
to automatically create FFI wrappers from C header files.

[ABI]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Abi-class.html
[AbiSpecificInteger]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/AbiSpecificInteger-class.html
[ios]: {{site.flutter-docs}}/development/platform-integration/ios/c-interop
[android]: {{site.flutter-docs}}/development/platform-integration/android/c-interop
[macos]: {{site.flutter-docs}}/development/platform-integration/macos/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[hello_world]: {{page.hw}}
[primitives]: {{page.samples}}/primitives
[structs]: {{page.samples}}/structs
[sqlite]: https://github.com/dart-lang/sdk/tree/main/samples/ffi/sqlite
[mini tutorial.]: https://github.com/dart-lang/sdk/blob/main/samples/ffi/sqlite/docs/sqlite-tutorial.md
[`NativeType`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/NativeType-class.html
[ffigen]: {{site.pub-pkg}}/ffigen
