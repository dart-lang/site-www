---
title: dart:math
description: Learn about the major features in Dart's dart:math library.
prevpage:
  url: /libraries/dart-async
  title: dart:async
nextpage:
  url: /libraries/dart-convert
  title: dart:convert
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

The dart:math library ([API reference][dart:math])
provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use this library in your app, import dart:math.

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
```dart
import 'dart:math';
```


## Trigonometry

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

:::note
These functions use radians, not degrees!
:::


## Maximum and minimum

The Math library provides `max()` and `min()` methods:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
```dart
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
```


## Math constants

Find your favorite constants—*pi*, *e*, and more—in the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
```dart
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
```


## Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (random)"?>
```dart
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (random-bool)"?>
```dart
var random = Random();
random.nextBool(); // true or false
```

:::warning
The default implementation of `Random` supplies a stream of pseudorandom bits
that are unsuitable for cryptographic purposes.
To create a cryptographically secure random number generator,
use the [`Random.secure()`][] constructor.
:::

## More information

Refer to the [Math API reference][dart:math] for a full list of methods.
Also see the API reference for [num,][num] [int,][int] and [double.][double]

[Random]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-math/Random-class.html
[`Random.secure()`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-math/Random/Random.secure.html
[dart:math]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-math/dart-math-library.html
[double]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/double-class.html
[int]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/int-class.html
[num]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/num-class.html
