---
title: "Objective-C and Swift interop using package:ffigen"
shortTitle: Objective-C & Swift interop
breadcrumb: Objective-C & Swift
description: >-
  To use Objective-C and Swift code in your Dart program, use package:ffigen.
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/native/tree/main/pkgs/ffigen/example/objective_c"
ffigenapi: "https://pub.dev/documentation/ffigen/latest/ffigen"
ffigendoc: "https://github.com/dart-lang/native/blob/main/pkgs/ffigen/doc/README.md"
appledoc: "https://developer.apple.com/documentation"
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on macOS or iOS,
can use `dart:ffi` and [`package:ffigen`]({{page.ffigen}})
to call Objective-C and Swift APIs.

`dart:ffi` enables Dart code to interact with native C APIs.
Objective-C is based on and compatible with C,
so it is possible to interact with Objective-C APIs using only `dart:ffi`.
However, doing so involves a lot of boilerplate code,
so you can use `package:ffigen` to automatically generate
the Dart FFI bindings for a given Objective-C API.
To learn more about FFI and interfacing with C code directly,
see the [C interop guide](/interop/c-interop).

You can generate Objective-C headers for Swift APIs,
enabling `dart:ffi` and `package:ffigen` to interact with Swift.

For more information about using FFIgen,
see the [FFIgen README]({{page.ffigen}})
and the [additional documentation]({{page.ffigendoc}}).

## Objective-C Example

This guide walks you through [an example]({{page.example}})
that uses `package:ffigen` to generate bindings for
[`AVAudioPlayer`]({{page.appledoc}}/avfaudio/avaudioplayer?language=objc).
This API requires at least macOS SDK 10.7,
so check your version and update Xcode if necessary:

```console
$ xcodebuild -showsdks
```

Generating bindings to wrap an Objective-C API is similar to wrapping a C API.
Direct `package:ffigen` at the header file that describes the API,
and then load the library with `dart:ffi`.

`package:ffigen` parses Objective-C header files
using [LLVM](https://llvm.org/),
so you'll need to install that first.
See [Installing LLVM]({{page.ffigen}}#installing-llvm)
from the FFIgen README for more details.

### Configuring FFIgen for Objective-C

First, add `package:ffigen` as a dev dependency:

```console
$ dart pub add --dev ffigen
```

Then, configure FFIgen to generate bindings for the
Objective-C header containing the API.
FFIgen can be configured via YAML or Dart code,
but Dart is preferred for new projects.
The YAML config will be deprecated in future versions of FFIgen.
Start by creating a `generate_code.dart` script somewhere in your package.
A good directory to create this file in is `my_package/tool`.

The `generate_code.dart` script should create an `FfiGenerator` object,
which will contain all our configuration options,
then call its `.generate()` method.

```dart
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
);

void main() => config.generate();
```

First, you'll tell FFIgen where to find the API we're trying to
generate bindings for.
To do this, you set the `headers.entryPoints` option.

For this example, you'll load `AVAudioPlayer.h`.
This is part of the `AVFAudio` framework,
which is located in your Xcode installation.
FFIgen includes some helper functions to locate these sorts of APIs,
such as `macSdkPath`.
Using these helper functions makes your code generation script
more reliable across different machines,
which might have different SDK installation locations.

`macSdkPath` returns the result of `xcrun --show-sdk-path --sdk macosx`.
You can run this command in a terminal to locate your macOS SDKs,
or with `--sdk iphoneos` to find your iOS SDKs.
When generating bindings for an Apple API,
exploring these directories is a great way to find
the right headers to pass to FFIgen.

```dart
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
);

void main() => config.generate();
```

Next, we'll define the output file.
The main output of FFIgen is a single Dart file
containing bindings for the given inputs.
This file's location is defined by the `output.dartFile` option.

In some cases, FFIgen will also generate a `.m` file,
containing Objective-C code required for interop with the API.
This file will only be generated
if the API you're generating bindings for needs it,
such as if you're using blocks or protocols.
By default, this file has the same name as the Dart bindings,
but with `.m` at the end of the file name.
You can change its location with `output.objectiveCFile` option.
If FFIgen produces this file, you must compile it into your package,
otherwise you might get runtime exceptions relating to missing symbols.
For this example, FFIgen doesn't generate a `.m` file.

Another important option is `output.preamble`.
This is text inserted at the top of the Dart output,
which can be useful for adding a license header
or disabling specific lints that FFIgen's output doesn't adhere to.
In this case, disable several lints:

```dart highlightLines=11-16
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  output: Output(
    dartFile: Uri.file('avf_audio_bindings.dart'),
    preamble: '''
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
'''
  ),
);

void main() => config.generate();
```

The last thing we need to do is tell FFIgen
which parts of the input API to generate bindings for.
By default, FFIgen will filter out all the bindings.
In this case we want to generate bindings for `AVAudioPlayer`,
which is an Objective-C interface.
So we have to set the `objectiveC.interfaces` field.

Setting the `objectiveC` field also tells FFIgen
to generate bindings for the Objective-C language.
By default, FFIgen will generate C bindings.

```dart
import 'package:ffigen/ffigen.dart';

final config = FfiGenerator(
  headers: Headers(
    entryPoints: [
      Uri.file(
        '$macSdkPath/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h',
      ),
    ],
  ),
  objectiveC: ObjectiveC(
    interfaces: Interfaces.includeSet({'AVAudioPlayer'}),
  ),
  output: Output(
    dartFile: Uri.file('avf_audio_bindings.dart'),
    preamble: '''
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
'''
  ),
);

void main() => config.generate();
```

You can also use `includeMember` to filter out specific methods from the class,
and `rename` or `renameMember` to rename the included classes or methods.
There are similar options for protocols and categories.

See the [FFIgen API documentation]({{page.ffigenapi}})
for a full list of configuration options.

### Generating the Dart/Objective-C bindings

To generate the bindings, navigate to the example directory,
and run the script:

```console
$ dart run generate_code.dart
```

This should generate a large `avf_audio_bindings.dart` file,
similar to [this one]({{page.example}}/avf_audio_bindings.dart).
The main class we're interested in is `AVAudioPlayer`.

You may notice other classes in the file
with a comment indicating they are a stub.
FFIgen will generate stub bindings for all transitive dependencies
of the directly included APIs.
To generate full bindings for these stubs,
add them to the includes in your config.
This stubbing behavior can be changed
with the `includeTransitive` options.

### Using the Objective-C bindings

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
  DynamicLibrary.open(_dylibPath);
```

Since you're loading an internal library,
the dylib path is pointing at an internal framework dylib.
You can also load your own `.dylib` file,
or if the library is statically linked into your app (often the case on iOS)
you don't need to load anything.

The goal of the example is to play each of the audio files
specified as command line arguments one by one.
For each argument,
you first have to convert the Dart `String` to an Objective-C `NSString`.
The generated `NSString` wrapper has a convenient constructor
that handles this conversion,
and a `toDartString()` method that converts it back to a Dart `String`.

```dart
  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $file');
```

The audio player expects an `NSURL`, so next we use the [`fileURLWithPath:`](
{{page.appledoc}}/foundation/nsurl/1410828-fileurlwithpath?language=objc)
method to convert the `NSString` to an `NSURL`.

```dart
    final fileUrl = NSURL.fileURLWithPath(fileStr);
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
    final player = AVAudioPlayer.alloc().initWithContentsOfURL(
      fileUrl,
      error: nullptr,
    );
```

This Dart `AVAudioPlayer` object is a wrapper around an underlying
Objective-C `AVAudioPlayer*` object pointer.

Objective-C uses reference counting for memory management
(through retain, release, and other functions),
but on the Dart side memory management is handled automatically.
The Dart wrapper object retains a reference to the Objective-C object,
and when the Dart object is garbage collected,
the reference is automatically released.

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

Multithreading is one of the trickiest parts
of interop between Objective-C and Dart.
This is due to the relationship between Dart isolates and OS threads,
and the way Apple's APIs handle multithreading:

1. Dart isolates are not the same thing as threads.
   Isolates run on threads,
   but aren't guaranteed to run on any particular thread,
   and the VM might change which thread an isolate is running on
   without warning.
   There is an [open feature request][] to enable isolates to be
   pinned to specific threads.
2. While FFIgen supports converting
   Dart functions to Objective-C blocks,
   most Apple APIs don't make any guarantees about
   which thread a callback will run on.
3. Most APIs that involve UI interaction
   can only be called on the main thread,
   also called the platform thread in Flutter.
4. Many Apple APIs are [not thread safe][].

The first two points mean that a block created in one isolate
might be invoked on a thread running a different isolate,
or no isolate at all.
Depending on the type of block you are using,
this could cause your app to crash.
When a block is created, the isolate it was created in is its owner.
Blocks created using `FooBlock.fromFunction`
must be invoked on the owner isolate's thread,
otherwise they will crash.
Blocks created using `FooBlock.listener` or `FooBlock.blocking`
can be safely invoked from any thread,
and the function they wrap will (eventually) be invoked
inside the owner isolate,
though these constructors are only supported for blocks that return `void`.
`FooBlock.blocking` may add support for non-`void` return values in future,
if there is user demand for it.

The third point means that directly calling some Apple APIs
using the generated Dart bindings might be thread unsafe.
This could crash your app, or cause other unpredictable behavior.
In recent versions of Flutter, the main isolate runs on the platform thread,
so this isn't an issue when invoking these thread-locked APIs
from the main isolate.
If you need to invoke these APIs from other isolates,
or you need to support older versions of flutter,
you can use the [`runOnPlatformThread`][] function.
For more information, see the [Objective-C dispatch documentation][].

Regarding the last point,
although Dart isolates can switch threads,
they only ever run on one thread at a time.
So, the API you are interacting with
doesn't necessarily have to be thread safe,
as long as it is not thread hostile,
and doesn't have constraints about which thread it's called from.

You can safely interact with Objective-C code
as long as you keep these limitations in mind.

[`runOnPlatformThread`]: https://api.flutter.dev/flutter/dart-ui/runOnPlatformThread.html

## Swift example

This [example][swift_example] demonstrates how to
make a Swift class compatible with Objective-C,
generate a wrapper header, and invoke it from Dart code.

The process detailed below is quite manual.
There is an experimental project to automate these steps
called [Swiftgen][].

[Swiftgen]: https://pub.dev/packages/swiftgen

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

```console
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

### Configuring FFIgen for Swift

FFIgen only sees the Objective-C wrapper header, `swift_api.h`.
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

```console
$ echo "_TtC12swift_module10SwiftClass" | swift demangle
```

This outputs `swift_module.SwiftClass`.

### Generating the Dart/Swift bindings

As before, navigate to the example directory,
and run FFIgen:

```console
$ dart run ffigen
```

This generates `swift_api_bindings.dart`.

### Using the Swift bindings

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

```console
$ dart run example.dart
```

[`initWithContentsOfURL:error:`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc
[`duration`]: {{page.appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc
[`play`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc
[Swift documentation]: {{page.appledoc}}/swift/importing-swift-into-objective-c
[open feature request]: {{site.repo.dart.sdk}}/issues/46943
[`package:cupertino_http`]: {{site.repo.dart.org}}/http/blob/master/pkgs/cupertino_http/src/CUPHTTPClientDelegate.m
[not thread safe]: {{site.apple-dev}}/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
[Objective-C dispatch documentation]: {{page.appledoc}}/dispatch?language=objc
[swift_example]: {{site.repo.dart.org}}/native/tree/main/pkgs/ffigen/example/swift
