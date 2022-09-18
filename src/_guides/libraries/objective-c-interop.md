---
title: "Objective-C and Swift interop using package:ffigen"
description: "To use Objective-C and Swift code in your Dart program, use package:ffigen."
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/ffigen/tree/master/example/objective_c"
swift_example: "https://github.com/dart-lang/ffigen/tree/master/example/swift"
appledoc: "https://developer.apple.com/documentation"
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on macOS or iOS,
can use `dart:ffi` and [`package:ffigen`]({{page.ffigen}})
to call Objective-C and Swift APIs.

{{site.alert.note}}
  This interop feature is **experimental**,
  and [in active development](https://github.com/dart-lang/sdk/issues/49673).
{{site.alert.end}}

`dart:ffi` allows Dart code to interact with native C APIs.
Objective-C is based on and compatible with C,
so it is possible to interact with Objective-C APIs using only `dart:ffi`.
However, doing so involves a lot of boilerplate code,
so you can use `package:ffigen` to automatically generate
the Dart FFI bindings for a given Objective-C API.
To learn more about FFI and interfacing with C code directly,
see the [C interop guide](/guides/libraries/c-interop).

You can generate Objective-C headers for Swift APIs,
allowing `dart:ffi` and `package:ffigen` to interact with Swift.

## Objective-C Example

This guide walks you through [an example]({{page.example}})
that uses `package:ffigen` to generate bindings for
[`AVAudioPlayer`]({{page.appledoc}}/avfaudio/avaudioplayer?language=objc).
This API requires at least macOS SDK 10.7,
so check your version and update Xcode if necessary:

```terminal
$ xcodebuild -showsdks
```

Generating bindings to wrap an Objective-C API is similar to wrapping a C API.
Direct `package:ffigen` at the header file that describes the API,
and then load the library with `dart:ffi`.

`package:ffigen` parses Objective-C header files
using [LLVM](https://llvm.org/),
so you'll need to install that first.
See [Installing LLVM]({{page.ffigen}}#installing-llvm)
from the ffigen README for more details.

### Configuring ffigen

First, add `package:ffigen` as a dev dependency:

```terminal
$ dart pub add --dev ffigen
```

Then, configure ffigen to generate bindings for the
Objective-C header containing the API.
The ffigen configuration options go in your `pubspec.yaml` file,
under a top-level `ffigen` entry.
Alternatively, you can put the ffigen config in its own `.yaml` file.

```yaml
ffigen:
  name: AVFAudio
  description: Bindings for AVFAudio.
  language: objc
  output: 'avf_audio_bindings.dart'
  headers:
    entry-points:
      - '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h'
```

The `name` is the name of the native library wrapper class
that will be generated,
and the `description` will be used in the documentation for that class.
The `output` is the path of the Dart file that ffigen will create.
The entry point is the header file containing the API.
In this example, it is the internal `AVAudioPlayer.h` header.

Another import thing you'll see,
if you look at the [example config]({{page.example}}/pubspec.yaml),
is the exclude and include options.
By default, `ffigen` generates bindings for everything
it finds in the header,
and everything that those bindings depend on in other headers.
Most Objective-C libraries depend on Apple's internal libraries,
which are very large.
If bindings are generated without any filters,
the resulting file can be millions of lines long.
To solve this problem,
the ffigen config has fields that allow you to filter out
all the functions, structs, enums, etc., that you're not interested in.
For this example, we're only interested in `AVAudioPlayer`,
so you can exclude everything else:

```yaml
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - 'AVAudioPlayer'
```

Since `AVAudioPlayer` is explicitly included like this,
`ffigen` excludes all other interfaces.
The `exclude-all-by-default` flag tells `ffigen` to
exclude everything else.
The result is that nothing is included except `AVAudioPlayer`,
and its dependencies, such as `NSObject` and `NSString`.
So instead of several million lines of bindings,
you end up with tens of thousands.

If you need more granular control,
you can exclude or include all declarations individually,
rather than using `exclude-all-by-default`:

```yaml
  functions:
    exclude:
      - '.*'
  structs:
    exclude:
      - '.*'
  unions:
    exclude:
      - '.*'
  globals:
    exclude:
      - '.*'
  macros:
    exclude:
      - '.*'
  enums:
    exclude:
      - '.*'
  unnamed-enums:
    exclude:
      - '.*'
```

These `exclude` entries all exclude the regular expression `'.*'`,
which matches anything.

You can also use the `preamble` option
to insert text at the top of the generated file.
In this example, the `preamble` was used
to insert some linter ignore rules at the top of the generated file:

```yaml
  preamble: |
    // ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
```

See the [ffigen readme]({{page.ffigen}}#configurations)
for a full list of configuration options.

### Generating the Dart bindings

To generate the bindings, navigate to the example directory,
and run ffigen:

```terminal
$ dart run ffigen
```

This will search in the `pubspec.yaml` file for a top-level `ffigen` entry.
If you chose to put the ffigen config in a separate file, use the
`--config` option and specify that file:

```terminal
$ dart run ffigen --config my_ffigen_config.yaml
```

For this example, this will generate
[avf_audio_bindings.dart]({{page.example}}/avf_audio_bindings.dart).

This file contains a class called `AVFAudio`, which is the native library
wrapper that loads all the API functions using FFI,
and provides convenient wrapper methods to call them.
The other classes in this file are all Dart wrappers
around the Objective-C interfaces that we need,
such as `AVAudioPlayer` and its dependencies.

### Using the bindings

Now you're ready to load and interact with the generated library.
The example app, [play_audio.dart]({{page.example}}/play_audio.dart),
loads and plays audio files passed as command line arguments.
The first step is to load the
[dylib]({{page.appledoc}}/avfaudio?language=objc)
and instantiate the native `AVFAudio` library:

```dart
import 'dart:ffi';
import 'avf_audio_bindings.dart';

const _dylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';

void main(List<String> args) async {
  final lib = AVFAudio(DynamicLibrary.open(_dylibPath));
```

Since you're loading an internal library,
the dylib path is pointing at an internal framework dylib.
You can also load your own `.dylib` file,
or if the library is statically linked into your app (often the case on iOS)
you can use [`DynamicLibrary.process()`](
{{site.dart-api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html):

```dart
  final lib = AVFAudio(DynamicLibrary.process());
```

The goal of the example is to play each of the audio files
specified as command line arguments one by one.
For each argument,
you first have to convert the Dart `String` to an Objective-C `NSString`.
The generated `NSString` wrapper has a convenient constructor
that handles this conversion,
and a `toString()` method that converts it back to a Dart `String`.

```dart
  for (final file in args) {
    final fileStr = NSString(lib, file);
    print('Loading $fileStr');
```

The audio player expects an `NSURL`, so next we use the [`fileURLWithPath:`](
{{page.appledoc}}/foundation/nsurl/1410828-fileurlwithpath?language=objc)
method to convert the `NSString` to an `NSURL`.
Since `:` is not a valid character in a Dart method name,
it has been translated to `_` in the bindings.

```dart
    final fileUrl = NSURL.fileURLWithPath_(lib, fileStr);
```

Now, you can construct the `AVAudioPlayer`.
Constructing an Objective-C object has two stages.
`alloc` allocates the memory for the object,
but doesn't initialize it.
Methods with names starting with `init*` do the initialization.
Some interfaces also provide `new*` methods that do both of these steps.

To initialize the `AVAudioPlayer`,
use the [`initWithContentsOfURL:error:`][] method:

```dart
    final player =
        AVAudioPlayer.alloc(lib).initWithContentsOfURL_error_(fileUrl, nullptr);
```

Objective-C uses reference counting for memory management
(through retain, release, and other functions),
but on the Dart side memory management is handled automatically.
The Dart wrapper object retains a reference to the Objective-C object,
and when the Dart object is garbage collected,
the generated code automatically releases that reference using a
[`NativeFinalizer`]({{site.dart-api}}/dart-ffi/NativeFinalizer-class.html).

Next, look up the length of the audio file,
which you'll need later to wait for the audio to finish.
The [`duration`][] is a `@property(readonly)`.
Objective-C properties are translated into getters and setters
on the generated Dart wrapper object.
Since `duration` is `readonly`, only the getter is generated.

The resulting `NSTimeInterval` is just a type aliased `double`,
so you can immediately use the Dart `.ceil()` method
to round up to the next second:

```dart
    final durationSeconds = player.duration.ceil();
    print('$durationSeconds sec');
```

Finally, you can use the [`play`][] method to play the audio,
then check the status, and wait for the duration of the audio file:

```dart
    final status = player.play();
    if (status) {
      print('Playing...');
      await Future<void>.delayed(Duration(seconds: durationSeconds));
    } else {
      print('Failed to play audio.');
    }
```

### Callbacks and multithreading limitations

Multithreading issues are the biggest limitation
of Dart's experimental support for Objective-C interop.
These limitations are due to the relationship between
Dart isolates and OS threads,
and the way Apple's APIs handle multithreading:

* Dart isolates are not the same thing as threads.
  Isolates run on threads,
  but aren't guaranteed to run on any particular thread,
  and the VM might change which thread an isolate is running on
  without warning.
  There is an [open feature request][] to allow isolates to be
  pinned to specific threads.
* While `ffigen` supports converting
  Dart functions to Objective-C blocks,
  most Apple APIs don't make any guarantees about
  on which thread a callback will run.
* Most APIs that involve UI interaction
  can only be called on the main thread,
  also called the _platform_ thread in Flutter.
* Many Apple APIs are [not thread safe][].

The first two points mean that a callback created in one isolate
might be invoked on a thread running a different isolate,
or no isolate at all.
This will cause your app to crash.
You can work around this limitation by writing some
Objective-C code that intercepts your callback and
forwards it over a [`Dart_Port`]({{site.dart-api}}/dart-ffi/NativePort.html)
to the correct isolate.
For an example of this,
see the implementation of [`package:cupertino_http`][].

The third point means that directly calling some Apple APIs
using the generated Dart bindings might be thread unsafe.
This could crash your app, or cause other unpredictable behavior.
You can work around this limitation by writing some
Objective-C code that dispatches your call
to the main thread.
For more information, see the [Objective-C dispatch documentation][].

Regarding the last point,
although Dart isolates can switch threads,
they only ever run on one thread at a time.
So, the API you are interacting with
doesn't necessarily have to be thread safe,
as long as it is not thread hostile,
and doesn't have constraints about which thread it's called from.

You can safely interact with Objective-C code,
as long as you keep these limitations in mind.

## Swift example

This [example]({{page.swift_example}}) demonstrates how to
make a Swift class compatible with Objective-C,
generate a wrapper header, and invoke it from Dart code.

### Generating the Objective-C wrapper header

Swift APIs can be made compatible with Objective-C,
by using the `@objc` annotation.
Make sure to make any classes or methods you want to use
`public`, and have your classes extend `NSObject`.

```swift
import Foundation

@objc public class SwiftClass: NSObject {
  @objc public func sayHello() -> String {
    return "Hello from Swift!";
  }

  @objc public var someField = 123;
}
```

If you're trying to interact with a third-party library,
and can't modify their code,
you might need to write an Objective-C compatible wrapper class
that exposes the methods you want to use.

For more information about Objective-C / Swift interoperability,
see the [Swift documentation][].

Once you've made your class compatible,
you can generate an Objective-C wrapper header.
You can do this using Xcode,
or using the Swift command-line compiler, `swiftc`.
This example uses the command line:

```terminal
$ swiftc -c swift_api.swift             \
    -module-name swift_module           \
    -emit-objc-header-path swift_api.h  \
    -emit-library -o libswiftapi.dylib
```

This command compiles the Swift file, `swift_api.swift`,
and generates a wrapper header, `swift_api.h`.
It also generates the dylib you're going to load later,
`libswiftapi.dylib`.

You can verify that the header generated correctly by opening it, 
and checking that the interfaces are what you expect.
Towards the bottom of the file,
you should see something like the following:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
- (NSString * _Nonnull)sayHello SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic) NSInteger someField;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
```

If the interface is missing, or doesn't have all its methods,
make sure they're all annotated with `@objc` and `public`.

### Configuring ffigen

Ffigen only sees the Objective-C wrapper header, `swift_api.h`.
So most of this config looks similar
to the Objective-C example,
including setting the language to `objc`.

```yaml
ffigen:
  name: SwiftLibrary
  description: Bindings for swift_api.
  language: objc
  output: 'swift_api_bindings.dart'
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - 'SwiftClass'
    module:
      'SwiftClass': 'swift_module'
  headers:
    entry-points:
      - 'swift_api.h'
  preamble: |
    // ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
```

As before, set the language to `objc`,
and the entry point to the header;
exclude everything by default,
and explicitly include the interface you are binding.

One important difference between the config
for a wrapped Swift API and a pure Objective-C API:
the `objc-interfaces` -> `module` option.
When `swiftc` compiles the library,
it gives the Objective-C interface a module prefix.
Internally, `SwiftClass` is actually registered as
`swift_module.SwiftClass`.
You need to tell `ffigen` about this prefix,
so it loads the correct class from the dylib.

Not every class gets this prefix.
For example, `NSString` and `NSObject` 
won't get a module prefix, 
because they are internal classes.
This is why the `module` option maps
from class name to module prefix.
You can also use regular expressions to match
multiple class names at once.

The module prefix is whatever you passed to
`swiftc` in the `-module-name` flag.
In this example, it's `swift_module`.
If you don't explicitly set this flag,
it defaults to the name of the Swift file.

If you aren't sure what the module name is,
you can also check the generated Objective-C header.
Above the `@interface`, you'll find a `SWIFT_CLASS` macro:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
```

The string inside the macro is a bit cryptic, but you can
see it contains the module name and the class name:
`"_TtC12`***`swift_module`***`10`***`SwiftClass`***`"`.

Swift can even demangle this name for us:

```terminal
$ echo "_TtC12swift_module10SwiftClass" | swift demangle
```

This outputs `swift_module.SwiftClass`.

### Generating the Dart bindings

As before, navigate to the example directory,
and run ffigen:

```terminal
$ dart run ffigen
```

This generates `swift_api_bindings.dart`.

### Using the bindings

Interacting with these bindings is exactly the same
as for a normal Objective-C library:

```dart
import 'dart:ffi';
import 'swift_api_bindings.dart';

void main() {
  final lib = SwiftLibrary(DynamicLibrary.open('libswiftapi.dylib'));
  final object = SwiftClass.new1(lib);
  print(object.sayHello());
  print('field = ${object.someField}');
  object.someField = 456;
  print('field = ${object.someField}');
}
```

Note that the module name is not mentioned
in the generated Dart API.
It's only used internally,
to load the class from the dylib.

Now you can run the example using:

```terminal
$ dart run example.dart
```

[`initWithContentsOfURL:error:`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc
[`duration`]: {{page.appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc
[`play`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc
[Swift documentation]: {{page.appledoc}}/swift/importing-swift-into-objective-c
[open feature request]: https://github.com/dart-lang/sdk/issues/46943
[`package:cupertino_http`]: https://github.com/dart-lang/http/blob/master/pkgs/cupertino_http/src/CUPHTTPClientDelegate.m
[not thread safe]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
[Objective-C dispatch documentation]: {{page.appledoc}}/dispatch?language=objc
