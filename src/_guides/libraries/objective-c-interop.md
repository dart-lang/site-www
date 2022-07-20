---
title: "Objective-C interop using package:ffigen"
description: "To use Objective-C code in your Dart program, use package:ffigen."
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/ffigen/tree/master/example/objective_c"
appledoc: "https://developer.apple.com/documentation"
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on macOS or iOS,
can use `dart:ffi` and [`package:ffigen`]({{page.ffigen}})
to call Objective-C APIs.

`dart:ffi` allows Dart code to interact with native C APIs.
Objective-C is based on and compatible with C,
so it is possible to interact with Objective-C APIs using only `dart:ffi`.
However, doing so involves a lot of boilerplate code,
so you can use `package:ffigen` to automatically generate
the Dart FFI bindings for a given Objective-C API.
To learn more about FFI and interfacing with C code directly,
see the [C interop guide](/guides/libraries/c-interop).

## Example: AVAudioPlayer

This guide walks you through [an example]({{page.example}})
that uses `package:ffigen` to generate bindings for
[`AVAudioPlayer`]({{page.appledoc}}/avfaudio/avaudioplayer?language=objc).

Generating bindings to wrap an Objective-C API is similar to wrapping a C API.
Direct `package:ffigen` at the header file that describes the API,
and then load the library with `dart:ffi`.

`package:ffigen` parses Objective-C header files
using [LLVM](https://llvm.org/),
so you'll need to install that first.
See [Installing LLVM]({{page.ffigen}}#installing-llvm)
from the ffigen README for more details.

### Configuring ffigen

First, add `package:ffiigen` as a dev dependency:

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
is a lot of exclusions.
By default, ffigen will generate bindings for everything
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
  objc-interfaces:
    include:
      - 'AVAudioPlayer'
```

Since `AVAudioPlayer` is explicitly included like this,
ffigen will exclude all other interfaces.
The `exclude` entries are all excluding the regular expression `'.*'`,
which matches anything.
The result is that nothing is included except `AVAudioPlayer`,
and the things that it depends on, such as `NSObject` and `NSString`.
So instead of several million lines of bindings,
you end up with tens of thousands.

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

### Generating the bindings

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

[`initWithContentsOfURL:error:`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc
[`duration`]: {{page.appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc
[`play`]: {{page.appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc
