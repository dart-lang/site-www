---
title: "Objective-C interop using package:ffigen"
description: "To use Objective-C code in your Dart program, use package:ffigen."
ffigen: "https://github.com/dart-lang/ffigen"
example: "https://github.com/dart-lang/ffigen/tree/master/example/objective_c"
appledoc: "https://developer.apple.com/documentation"
---

Dart mobile, command-line, and server apps
running on the [Dart Native platform](/overview#platform), on Mac or iOS,
can use `dart:ffi` and `package:ffigen` to call Objective-C APIs.

`dart:ffi` allows Dart code to interact with C (see the [C interop](
/guides/libraries/c-interop) guide for more information about FFI).
Objective-C is based on and compatible with C. So it is possible to
interact with Objective-C APIs using only `dart:ffi`. But this involves a lot
of boilerplate, so you can use `package:ffigen` to automatically generate
the Dart FFI bindings for a given Objective-C API.

## Example: AVAudioPlayer

This guide will walk you through [an example]({{page.example}}) that uses
`package:ffigen` to generate bindings for [`AVAudioPlayer`](
{{page.appledoc}}/avfaudio/avaudioplayer?language=objc).

Generating bindings to wrap an Objective-C API is similar to wrapping a C API.
You point `package:ffigen` at the header file that describes the API, and then
load the library with `dart:ffi`.

`package:ffigen` parses your Objective-C header files using LLVM, so you'll
need to install that first. See the [ffigen readme](
{{page.ffigen}}#installing-llvm) for details.

### The config file

The first step is to configure ffigen. A minimal config file for Objective-C
looks like this:

```yaml
language: objc
output: 'foo_bindings.dart'
headers:
  entry-points:
    - 'foo.h'
```

Alternatively, you can put this yaml in your pubspec.yaml file, under
`ffigen:`.

For our example, the entry point is the internal `AVAudioPlayer.h` header, and
the output is `avf_audio_bindings.dart`. We've also set the `name:` and the
`description:`.

```yaml
name: AVFAudio
description: Bindings for AVFAudio.
language: objc
output: 'avf_audio_bindings.dart'
headers:
  entry-points:
    - '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h'
```

Another imortant thing you'll see, if you look at the
[example config]({{page.example}}/pubspec.yaml), is a lot of exclusions.
By default, ffigen will generate bindings for everything it finds
in the header, and everything that those bindings depend on in other
headers. Most Objective-C libraries depend on Apple's internal
libraries, which are very large. If bindings are generated without any
filters, the resulting file can be millions of lines long. To solve this
problem, the ffigen config has fields that allow you to filter out
all the functions, structs, enums etc that you're not interested in.
For our case, we're only interested in `AVAudioPlayer`, and we exclude
everything else.

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

Since we've included `AVAudioPlayer`, ffigen will exclude all other interfaces.
The `exclude:` lines are all excluding the regex `'.*'`, which matches anything.
The result is that nothing is included except `AVAudioPlayer`, and the
things that it depends on, such as `NSObject`, `NSString`, etc. So instead
of several million lines of bindings, we end up with tens of thousands.

In the full example config, we also added a `preamble:`, to insert some linter
ignore rules at the top of the generated file. You can find a full list of
config options in the [ffigen readme]({{page.ffigen}}#configurations).

### Generating the bindings

To generate the bindings, navigate to the example directory, and run
`dart run ffigen`. This will search in the pubspec.yaml file for an `ffigen:`
config. If your config is in a standalone file, then use
`dart run ffigen --config foo.yaml`.

For our example, this will generate
[avf_audio_bindings.dart]({{page.example}}/avf_audio_bindings.dart).

This file contains a class called `AVFAudio`, which is the native library
wrapper that holds all the loaded function pointers etc. The other classes
in this file are all Dart wrappers around the Objective-C interfaces that
we need, such as `AVAudioPlayer` and its dependencies.

### Using the bindings

Now we're ready to load and interact with our library. Our example app,
[play_audio.dart]({{page.example}}/play_audio.dart), loads and plays
audio files passed as command line arguments.
The first step is to load the dylib and instantiate the native
library, `AVFAudio`.

```dart
import 'dart:ffi';
import 'avf_audio_bindings.dart';

const _dylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';

void main(List<String> args) async {
  final lib = AVFAudio(DynamicLibrary.open(_dylibPath));
```

Since we're loading an internal library, we're pointing at an internal
framework dylib. You can also load your own `foo.dylib` file, or if the
library is statically linked into your app (often the case on iOS) you
can use `DynamicLibrary.process()`:

```dart
  final lib = AVFAudio(DynamicLibrary.process());
```

We want to play each of the files in the command line args one by one.
For each arg, the we first have to convert the Dart `String` to an
Objective-C `NSString`. The generated `NSString` wrapper has a convenient
constructor that handles this conversion, and a `toString()` method that
converts it back to a Dart `String`.

```dart
  for (final file in args) {
    final fileStr = NSString(lib, file);
    print('Loading $fileStr');
```

The audio player expects an `NSURL`, so next we use the [`fileURLWithPath:`](
{{page.appledoc}}/foundation/nsurl/1410828-fileurlwithpath?language=objc)
method to convert the `NSString` to an `NSURL`. Since `:` is not a
valid character in a Dart method name, it has been translated to `_`.

```dart
    final fileUrl = NSURL.fileURLWithPath_(lib, fileStr);
```

Now we can construct our `AVAudioPlayer`. Constructing an Objective-C
object has two stages. `alloc` allocates the memory for the object, but
doesn't initialize it. Methods with names starting with `init*` do the
initialization. Some interfaces also provide `new*` methods that do
both these steps.

The init method we will use is [`initWithContentsOfURL:error:`](
{{page.appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc).

```dart
    final player =
        AVAudioPlayer.alloc(lib).initWithContentsOfURL_error_(fileUrl, nullptr);
```

Objective-C uses reference counting for memory management (eg `retain` and
`release`), but on the Dart side this is all handled automatically. The
Dart wrapper object retains a reference to the Objective-C object, and
when the Dart object is garbage collected it automatically releases that
reference.

Next we look up the length of the audio file, which we'll need later.
The [`duration`](
{{page.appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc)
is a `@property(readonly)`. Objective-C properties are translated into
getters and setters on the Dart wrapper object. Since `duration` is
`readonly`, only the getter is generated.

The resulting `NSTimeInterval` is just a typedefed `double`, so we can
immediately use the Dart `.ceil()` method to round up to the next second.

```dart
    final durationSeconds = player.duration.ceil();
    print('$durationSeconds sec');
```

Finally, we [`play`](
{{page.appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc)
the audio, check the status, and wait for the duration of the audio file.

```dart
    final status = player.play();
    if (status) {
      print('Playing...');
      await Future<void>.delayed(Duration(seconds: durationSeconds));
    } else {
      print('Failed to play audio.');
    }
```
