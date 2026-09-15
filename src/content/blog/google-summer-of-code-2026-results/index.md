---
title: "Google Summer of Code 2026 results"
description: >-
  Today, we spotlight the projects and results from contributors
  mentored by Dart and Flutter in Google Summer of Code 2026.
publishDate: 2026-09-15
author: jonasfj
image: images/hero.webp
category: other
layout: blog
---

The [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) program
focuses on engaging new developers worldwide
in open source software development.
Google sponsors contributors to work with
a mentoring open source organization
on a 12-week programming project during the summer.
Over the past 20 years,
more than 20,000 contributors have participated in Google Summer of Code.

<DashImage src="images/hero.webp" alt="Dash wearing a sun hat lounges on a pool float with a laptop, under the Google Summer of Code sun logo." />

This year, Dart and Flutter participated as a mentoring organization
in Google Summer of Code for the seventh consecutive year.
We received nearly 100 project proposals from prospective participants
around the world.
Today, we spotlight some of the projects we mentored this summer.
The contributors describe their projects in this post.

## Add WebSocket and gRPC support to Flutter DevTools Network panel

*By Yash Hosalli*

While working with real-time systems,
I noticed a gap in the developer experience.
Flutter DevTools provides great visibility into HTTP requests,
but once a WebSocket connection comes alive,
it becomes much harder to see what is actually happening.
Frame flow, connection lifecycle, and activity over time
can quickly turn into a black box,
making real-time debugging frustrating.

Many modern apps rely on WebSockets,
and have little to no visibility for debugging.
This project brings that missing visibility into the existing
Dart and Flutter tooling stack.
I extended `dart:io`, `dart:developer`, and the VM Service
to capture lightweight connection-level and frame-level WebSocket data,
following the architecture already established for HTTP profiling.
The goal was to make WebSocket debugging feel familiar
rather than introducing an entirely new profiling workflow.

The collected data is then surfaced directly in the DevTools Network panel,
where developers can inspect connections, sizes, timestamps,
and lifecycle events as they happen.
This turns WebSocket communication into something
developers can actually observe and understand.

To learn more, check out my [GSoC progress tracking page](https://victowolf.github.io/GSoC-Progress-Tracking/).

<DashImage src="images/devtools-websocket-overview.webp" alt="Flutter DevTools Network panel showing WebSocket connection overview details such as status, bytes, and frames sent and received." />

<DashImage src="images/devtools-websocket-frames.webp" alt="Flutter DevTools Network panel showing a table of WebSocket frames with timestamps, directions, events, and sizes." />

<DashImage src="images/devtools-websocket-network-panel.webp" alt="Flutter DevTools Network panel listing HTTP and WebSocket network requests." />

## C++/C compatibility tool for FFIgen

*By Hassnaa Mohamed Ahmed*

The primary goal of this project is to extend `package:ffigen`
to automatically generate Dart FFI bindings for C++ APIs.
Dart can communicate with C and C-compatible APIs through the FFI package,
and FFIgen can automatically generate Dart bindings for these APIs.
However, C++ introduces concepts that are not directly represented by Dart FFI,
such as classes, constructors and destructors, inheritance,
and native object ownership.
As a result, using C++ libraries from Dart requires additional glue code
and careful handling of the relationship between Dart objects
and their underlying C++ objects.

The experimental C++ support in FFIgen addresses these challenges
by generating Dart bindings for C++ classes
together with the required C++ glue code.
The generated bindings support C++ class pointers
and native object lifetime management,
allowing Dart objects to interact with their underlying C++ objects
while preserving native ownership semantics.
This makes it possible to work with C++ classes from Dart
without requiring users to manually write the bindings
and memory-management layer.

Example C++ header:

```cpp
class Animal {
public:
  int age;
  Animal(int age);
  ~Animal();
  void speak();
  int getAge() const;
  static int getCount();
};
```

Generated C++ glue code:

```cpp
FFIGEN_EXPORT Animal* Animal_new(int age) {
  return new Animal(age);
}

FFIGEN_EXPORT int Animal_getAge(const Animal* self) {
  return self->getAge();
}

FFIGEN_EXPORT void Animal_delete(Animal* self) {
  delete self;
}
```

Generated Dart binding usage:

```dart
// Instantiate the C++ class through the generated constructor wrapper.
final animal = Animal(10);
expect(animal.getAge(), 10);

animal.speak();

// Invoke a static C++ method.
expect(Animal.getCount(), 42);

// Deterministically release the native object.
animal.dispose();
```

This approach provides a bridge between C++ object-oriented APIs
and Dart's FFI model,
while keeping the generated bindings as close as possible
to the semantics of the original C++ API.

For more details, check out the [GSoC 2026 project report on GitHub](https://github.com/Hassnaa9/GSoC-2026-Report).

## Migrate IntelliJ plugins off Weberknecht WebSocket library

*By Javad Asadi*

IntelliJ's Dart and Flutter plugins used the Weberknecht library
for communicating with the Dart Tooling Daemon and VM service.
Weberknecht is an old, unmaintained library
and continuing to depend on it was no longer a viable choice.

In GSoC 2026,
we decided to replace this library with JDK's built-in WebSocket client.
It has been available since Java 11,
enabling us to avoid another external dependency.

The migration happened one service at a time,
first in the Dart plugin and later in the Flutter plugin.
In each phase,
I tried to write tests that target the WebSocket
on both happy paths and edge cases.
The goal was to have the test pass before and after the migration.

The migration was completed successfully.
Both the Dart and Flutter plugins now use the JDK's built-in WebSocket client
while preserving the existing behavior across all workflows.
After the final migration phase,
all references to Weberknecht—including its dependencies
and bundled JAR files—were removed from both repositories.
As a result,
the plugins no longer depend on an outdated external WebSocket library.

<DashImage src="images/intellij-plugin-websocket-architecture.webp" alt="Architecture diagram showing the IntelliJ Dart and Flutter plugins connecting to the Dart SDK VM Service and Dart Tooling Daemon via WebSockets." />

More information about this project can be found in my [project summary gist](https://gist.github.com/JavadAsadi/10b0935ae19405a43ecc311e9bdd7921).

## Android JCA backend for package:webcrypto

*By M. Fazri Nizar*

`package:webcrypto` currently ships an additional BoringSSL native library
with Android apps.
During GSoC 2026,
I explored using Android's own cryptography APIs
through Java Cryptography Architecture (JCA) and `package:jni` instead.
Because Android already provides built-in cryptography,
leveraging it could eventually reduce the extra native code shipped with an app.
The first milestone was getting the SHA-256 primitive working.

After the first primitive was merged,
I added HMAC and AES,
followed by RSA, elliptic-curve operations, HKDF,
and secure random generation.
Running the package's existing tests throughout development
allowed me to compare the JCA implementation
with the BoringSSL and browser backends.
Those tests also uncovered differences between providers,
especially around AES-GCM parameters and RSA private keys
on older Android versions.
PBKDF2 remains unresolved because Web Crypto accepts raw password bytes
while JCA's standard API accepts characters.

The JCA backend implements the existing interface,
meaning the public API remains completely unchanged.
As a result, developers will be able to benefit from reduced app sizes
without changing any of their code.

To learn more about the implementation and ongoing work, check out my [GSoC 2026 project report on GitHub](https://github.com/mfazrinizar/GSoC-2026-Report).

## Inspect native memory in Dart DevTools

*By Nourhan H.*

When debugging Dart code involving `Pointer<X>`,
the debugger often displays unhelpful and vague information.
This forces developers to rely on print statements
instead of inspecting variables directly.

For example, given the following code:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class MyStruct extends Struct {
  @Int32()
  external int a;

  @Double()
  external double b;
}

void main() {
  final pInt16 = malloc<Int16>()..value = -500;
  final ptr = malloc<MyStruct>();

  ptr.ref.a = 42;
  ptr.ref.b = 3.14;

  malloc.free(ptr);
  malloc.free(pInt16);
}
```

The debugger previously showed:

<DashImage src="images/devtools-pointer-inspection-before.webp" alt="Dart DevTools debugger variables pane before the fix, displaying unhelpful Pointer<Never> type information for pointer variables." />

Additionally, attempting to inspect a pointer to invalid memory
previously resulted in segmentation faults,
making memory inspection unsafe.
This issue affected various `Pointer<X>` types,
including primitive types, structs, unions, and more.

We resolved this issue to make memory inspection both safe
and developer-friendly.

For instance, consider inspecting a container with multiple pointer types:

```dart
import 'dart:developer';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class MultiPointerContainer {
  final Pointer pInt16;
  final Pointer pInt32;
  final Pointer pDouble;
  final Pointer pNull;
  final Pointer pGarbage;
  final Pointer pBool;

  MultiPointerContainer({
    required this.pInt16,
    required this.pInt32,
    required this.pDouble,
    required this.pNull,
    required this.pGarbage,
    required this.pBool,
  });
}

void main() {
  final pInt16 = calloc()..value = -500;
  final pInt32 = calloc()..value = -100;
  final pDouble = calloc()..value = 1.5;
  final pGarbage = Pointer.fromAddress(0xDEADBEEF);
  final pBool = calloc()..value = true;

  final container = MultiPointerContainer(
    pInt16: pInt16,
    pInt32: pInt32,
    pDouble: pDouble,
    pNull: nullptr,
    pGarbage: pGarbage,
    pBool: pBool,
  );

  debugger();

  calloc.free(pInt16);
  calloc.free(pInt32);
  calloc.free(pDouble);
  calloc.free(pGarbage);
  calloc.free(pBool);
}
```

The debugger now displays:

<DashImage src="images/devtools-pointer-inspection-after.webp" alt="Dart DevTools debugger variables pane after the fix, displaying structured pointer information including raw bytes, addresses, and error handling for invalid memory." />

Invalid memory reads and `null` pointers are now handled completely safely.
We integrated low-level kernel APIs to prevent segmentation faults
during arbitrary memory reads across five major operating systems:

- **Linux & Android:** `pread64(/proc/self/mem)`
- **Windows:** `ReadProcessMemory`
- **macOS & iOS:** `mach_vm_read_overwrite`

This fix significantly enhances the developer experience
for anyone writing Dart code who needs clear, reliable visibility
into what happens under the hood when working with pointers.

For more information about the project, check out the [GSoC 2026 project repository on GitHub](https://github.com/TheNourhan/Dart-GSoC26).
