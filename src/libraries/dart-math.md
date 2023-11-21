---
title: dart:math
description: Learn about the major features in Dart's dart:math library.
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>


## dart:math - math and random

The dart:math library ([API reference][dart:math])
provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use this library in your app, import dart:math.

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
```dart
import 'dart:math';
```


### Trigonometry

The Math library provides basic trigonometric functions:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
```dart
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
```

{{site.alert.note}}
  These functions use radians, not degrees!
{{site.alert.end}}


### Maximum and minimum

The Math library provides `max()` and `min()` methods:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
```dart
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
```


### Math constants

Find your favorite constants—*pi*, *e*, and more—in the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
```dart
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
```


### Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (Random)"?>
```dart
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (Random-bool)"?>
```dart
var random = Random();
random.nextBool(); // true or false
```

{{site.alert.warning}}
  The default implementation of `Random` supplies a stream of pseudorandom bits
  that are unsuitable for cryptographic purposes.
  To create a cryptographically secure random number generator,
  use the [`Random.secure()`][] constructor.
{{site.alert.end}}

### More information

Refer to the [Math API reference][dart:math] for a full list of methods.
Also see the API reference for [num,][num] [int,][int] and [double.][double]

[ArgumentError]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[Assert]: /language/error-handling#assert
[Comparable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Comparable-class.html
[Dart API]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}
[DateTime]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/DateTime-class.html
[Duration]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Duration-class.html
[Exception]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
[Expando]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Expando-class.html
[Finalizable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Finalizable-class.html
[Finalizer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Finalizer-class.html
[Future.wait()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/wait.html
[Future]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[IndexedDB]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[Iterable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterator-class.html
[JSON]: https://www.json.org/
[List]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[Map]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Match]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Match-class.html
[NativeFinalizer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/NativeFinalizer-class.html
[NoSuchMethodError]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError-class.html
[Object]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[`ParallelWaitError`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/ParallelWaitError-class.html
[Pattern]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Pattern-class.html
[Random]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random-class.html
[RegExp]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/RegExp-class.html
[Set]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[Stream]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[StringBuffer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StringBuffer-class.html
[String]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String-class.html
[Symbol]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[Uri]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[WeakReference]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/WeakReference-class.html
[`Random.secure()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random/Random.secure.html
[dart:async]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart:collection]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart:convert]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:core]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart:ffi]: /guides/libraries/c-interop
[dart:io tour]: #dartio
[dart:math]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart:typed\_data]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[docs.flutter]: {{site.flutter-api}}
[double]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double-class.html
[garbage-collected]: https://medium.com/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30
[int]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int-class.html
[language tour]: /language
[num]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num-class.html
[toStringAsFixed()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsPrecision.html
[weak reference]: https://en.wikipedia.org/wiki/Weak_reference
[web audio]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[webdev libraries]: /web/libraries