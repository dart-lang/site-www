---
title: Build custom codecs and converters
description: >-
  Learn how to implement your own Codec and Converter classes
  with support for streaming and composition.
---

The [`dart:convert`][] library defines [`Codec`][] and [`Converter`][]
as extensible base classes. By implementing these classes,
you give your conversion logic a standard interface
that neatly integrates with Dart's stream system
and composes with other codecs through [`fuse`][].

To illustrate the process of implementing a custom codec from scratch,
this guide walks through implementing a [Caesar cipher][],
starting with a converter and progressively adding stream support.
A _Caesar cipher_ is a relatively simple encryption scheme that
shifts each letter by a fixed number of positions in the alphabet.

:::tip
To learn more about codecs and converters and the built-in ones,
check out [Converters and codecs][].
:::

[`dart:convert`]: {{site.dart-api}}/dart-convert
[`Converter`]: {{site.dart-api}}/dart-convert/Converter-class.html
[`Codec`]: {{site.dart-api}}/dart-convert/Codec-class.html
[`fuse`]: {{site.dart-api}}/dart-convert/Codec/fuse.html

[Caesar cipher]: https://wikipedia.org/wiki/Caesar_cipher

[Converters and codecs]: /libraries/convert/converters-and-codecs

## When to build a custom codec

Build a custom `Codec` or `Converter` when your conversion:

- Is **bidirectional** and you need both encoding and decoding.
- Benefits from **streaming** because the data might be
  too large for a single in-memory transformation.
- Should **compose** with other codecs through `fuse`.
- Is meant to be **reused** across projects or published as a package.

For one-directional or internal conversions,
a purpose-built function is often simpler.
For application-level JSON serialization,
the `fromJson`/`toJson` convention with code generation is more idiomatic.
For more insight on when to use each approach,
check out [Codecs versus `fromJson` and `toJson`][when-to-use-codecs].

[when-to-use-codecs]: /libraries/convert/converters-and-codecs#when-to-use-codecs

## Build a basic converter

Start by extending `Converter<S, T>` and implementing the [`convert`][] method.
This is the minimum required to create a working converter.

The following [Caesar cipher][] encoder shifts each
lowercase letter forward in the alphabet by a given amount.
Non-letter characters pass through unchanged:

```dart
import 'dart:convert';

/// Encodes a string by shifting each letter forward in the alphabet.
class CaesarEncoder extends Converter<String, String> {
  final int shift;

  const CaesarEncoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, shift));
    }
    return buffer.toString();
  }
}

/// Shifts the specified [codeUnit] by [shift] positions in the alphabet.
///
/// Only shifts lowercase ASCII letters (a-z).
/// All other characters are returned unchanged.
int _shiftCodeUnit(int codeUnit, int shift) {
  const a = 0x61;
  const z = 0x7A;
  if (codeUnit >= a && codeUnit <= z) {
    return a + (codeUnit - a + shift) % 26;
  }
  return codeUnit;
}
```

You can now use the converter to encode strings:

```dart
void main() {
  const encoder = CaesarEncoder(3);
  print(encoder.convert('hello')); // khoor
  print(encoder.convert('xyz'));   // abc
}
```

[`convert`]: {{site.dart-api}}/dart-convert/Converter/convert.html

## Build the decoder

The inverse of a Caesar encoder with a shift of `N`
is a Caesar encoder with a shift of `26 - N`.
You could reuse `CaesarEncoder` directly,
but creating a separate class keeps the intent clear and
lets you customize behavior if needed:

```dart
/// Decodes a Caesar-cipher-encoded string by
/// shifting each letter backward in the alphabet.
class CaesarDecoder extends Converter<String, String> {
  final int shift;

  const CaesarDecoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      // Shift backward by shifting forward by (26 - shift).
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, 26 - shift));
    }
    return buffer.toString();
  }
}
```

## Wrap converters in a codec

A `Codec<S, T>` pairs an encoder (`Converter<S, T>`)
with a decoder (`Converter<T, S>`).
Extend `Codec` and override the [`encoder`][] and [`decoder`][] getters:

```dart
/// A codec that encodes and decodes string using a
/// [Caesar cipher](https://wikipedia.org/wiki/Caesar_cipher).
class CaesarCodec extends Codec<String, String> {
  @override
  final CaesarEncoder encoder;

  @override
  final CaesarDecoder decoder;

  const CaesarCodec(int shift)
    : encoder = CaesarEncoder(shift),
      decoder = CaesarDecoder(shift);

  /// Creates a [CaesarCodec] that uses ROT13 encoding.
  const CaesarCodec.rot13() : this(13);
}
```

The codec inherits the `encode` and `decode` methods from `Codec`
that delegate to the overriden encoder and decoder.
It also inherits the `fuse` method and `inverted` getter:

```dart
void main() {
  const caesar = CaesarCodec(3);

  final encoded = caesar.encode('hello');
  print(encoded); // khoor

  final decoded = caesar.decode(encoded);
  print(decoded); // hello

  // The `inverted` getter returns a new codec that
  // applies converts in the inverse direction of the codec.
  final inverted = caesar.inverted;
  print(inverted.encode('khoor')); // hello
}
```

At this point you have a fully functional codec.
The following sections add stream support,
enabling consumers to use the codec with the [`Stream.transform`][] method.

[`encoder`]: {{site.dart-api}}/dart-convert/Codec/encoder.html
[`decoder`]: {{site.dart-api}}/dart-convert/Codec/decoder.html
[`Stream.transform`]: {{site.dart-api}}/dart-async/Stream/transform.html

## Add chunked conversion for streams

The basic `convert` method processes all input at once.
To support streaming, override the
`startChunkedConversion` method in your converter.
This method receives a downstream output sink and
returns an upstream input sink.
The chunked conversion then follows this sequence:

1.  The caller passes an output sink
    to `startChunkedConversion` on the converter.
    The converter creates and returns an input sink.
1.  The caller calls `inputSink.add(data)`
    one or more times with chunks of input.
    Each call converts the data and
    forwards the result to the output sink.
1.  The caller calls `inputSink.close()`.
    The input sink sends any remaining converted data
    to the output sink, then closes it.

To implement this in your converter, start by
creating a sink class that performs the conversion:

```dart
/// A [StringConversionSink] that applies a Caesar cipher [_shift] and
/// forwards the result to the [_output] sink.
class _CaesarEncoderSink extends StringConversionSinkBase {
  final int _shift;
  final StringConversionSink _output;

  _CaesarEncoderSink(this._shift, this._output);

  @override
  void addSlice(String chunk, int start, int end, bool isLast) {
    final buffer = StringBuffer();
    for (var i = start; i < end; i++) {
      buffer.writeCharCode(
        _shiftCodeUnit(chunk.codeUnitAt(i), _shift),
      );
    }
    _output.add(buffer.toString());
    if (isLast) {
      _output.close();
    }
  }
}
```

The `addSlice` method receives a chunk of the input string along with
`start` and `end` indices that define the relevant portion of the chunk.
The `isLast` flag indicates whether this is the final chunk.
When `isLast` is `true`, the sink closes the output without
requiring a separate `close` call.

:::note
`StringConversionSink` is a base class that
implements `add`, `addSlice`, and `close` in terms of each other.
You only need to override `addSlice()`.
For byte-oriented converters, use `ByteConversionSink` instead.
:::

Next, override `startChunkedConversion` in your encoder
to return an instance of your sink:

```dart
class CaesarEncoder extends Converter<String, String> {
  final int shift;

  const CaesarEncoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, shift));
    }
    return buffer.toString();
  }

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    // Wrap the output sink if it isn't already
    // a StringConversionSink.
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(shift, stringSink);
  }
}
```

Apply the same approach to `CaesarDecoder`,
using `26 - shift` as the shift value in its sink.

With chunked conversion implemented,
the converter automatically works as a `StreamTransformer`
through the inherited `bind` method.

### Chunked conversion type versus synchronous type

The chunked (streaming) type signature of a converter
doesn't always match the synchronous `convert` signature.
For example, `LineSplitter` synchronously converts
all lines in a `String` to a `List<String>` at once,
but in chunked mode it converts `String` chunks to `String` chunks
where each output chunk is a single line.
The chunked type is determined by
what's most useful as a `StreamTransformer`.

## Use your codec with streams

Once your converters support chunked conversion,
you can use them with the [`transform`][] method on `Stream`:

```dart
import 'dart:convert';
import 'dart:io';

void main() async {
  const caesar = CaesarCodec(3);

  // Encrypt a file as a stream.
  final encrypted = File('message.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(caesar.encoder);

  await for (final chunk in encrypted) {
    stdout.write(chunk);
  }
}
```

You can also compose your codec with others using [`fuse`][codec-fuse]
to build data pipelines:

```dart
import 'dart:convert';
import 'dart:io';

void main() async {
  const caesar = CaesarCodec(3);

  // Create a codec that encrypts, then compresses.
  final encryptAndCompress = caesar.fuse(utf8).fuse(gzip);

  // Write encrypted, compressed data.
  final output = File('message.gz').openWrite();
  output.add(encryptAndCompress.encode('Secret message.'));
  await output.close();

  // Read and decrypt.
  final bytes = await File('message.gz').readAsBytes();
  final decrypted = encryptAndCompress.decode(bytes);
  print(decrypted); // Secret message.
}
```

[`transform`]: {{site.dart-api}}/dart-async/Stream/transform.html
[codec-fuse]: {{site.dart-api}}/dart-convert/Codec/fuse.html

## Test your codec

Codecs have several properties that make good test cases.
At a minimum, verify that encoding and decoding are inverses,
that edge cases are handled, and that chunked conversion produces
the same results as single-pass conversion.

To test chunked conversion without setting up a stream,
you can use the `ChunkedConversionSink.withCallback` factory constructor:

```dart
import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';

void main() {
  const codec = CaesarCodec(3);

  group('CaesarCodec', () {
    test('encode shifts letters forward', () {
      expect(codec.encode('abc'), equals('def'));
      expect(codec.encode('xyz'), equals('abc'));
    });

    test('decode reverses encode', () {
      const original = 'the quick brown fox';
      final encoded = codec.encode(original);
      expect(codec.decode(encoded), equals(original));
    });

    test('non-letter characters pass through unchanged', () {
      expect(codec.encode('hello, world!'), equals('khoor, zruog!'));
    });

    test('empty string encodes to empty string', () {
      expect(codec.encode(''), equals(''));
    });

    test('inverted codec swaps encode and decode', () {
      final inverted = codec.inverted;
      expect(inverted.encode('def'), equals('abc'));
      expect(inverted.decode('abc'), equals('def'));
    });

    test('chunked conversion matches single-pass conversion', () {
      final chunks = <String>[];
      final outputSink = ChunkedConversionSink<String>.withCallback(
        (accumulated) => chunks.addAll(accumulated),
      );

      // Manually drive a chunked conversion.
      final inputSink = codec.encoder.startChunkedConversion(
        outputSink,
      );
      inputSink.add('hel');
      inputSink.add('lo ');
      inputSink.add('world');
      inputSink.close();

      expect(chunks.join(), equals(codec.encode('hello world')));
    });

    test('chunked conversion works with streams', () async {
      const input = 'hello world';

      // Split the input into chunks and convert as a stream.
      final stream = Stream.fromIterable(['hel', 'lo ', 'world']);
      final result = await stream
          .transform(codec.encoder)
          .join();

      expect(result, equals(codec.encode(input)));
    });
  });
}
```

## Complete example

The following example brings together all the pieces from this guide,
implementing a complete Caesar cipher codec:

```dart
import 'dart:convert';

/// Shifts the specified [codeUnit] by [shift] positions in the alphabet.
///
/// Only shifts lowercase ASCII letters (a-z).
/// All other characters are returned unchanged.
int _shiftCodeUnit(int codeUnit, int shift) {
  const a = 0x61;
  const z = 0x7A;
  if (codeUnit >= a && codeUnit <= z) {
    return a + (codeUnit - a + shift) % 26;
  }
  return codeUnit;
}

/// A [StringConversionSink] that applies a Caesar cipher shift
/// and forwards the result to [_output].
class _CaesarEncoderSink extends StringConversionSinkBase {
  final int _shift;
  final StringConversionSink _output;

  _CaesarEncoderSink(this._shift, this._output);

  @override
  void addSlice(String chunk, int start, int end, bool isLast) {
    final buffer = StringBuffer();
    for (var i = start; i < end; i++) {
      buffer.writeCharCode(
        _shiftCodeUnit(chunk.codeUnitAt(i), _shift),
      );
    }
    _output.add(buffer.toString());
    if (isLast) {
      _output.close();
    }
  }
}

/// Encodes a string by shifting each letter forward in the alphabet.
class CaesarEncoder extends Converter<String, String> {
  final int shift;

  const CaesarEncoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, shift));
    }
    return buffer.toString();
  }

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(shift, stringSink);
  }
}

/// Decodes a Caesar-cipher-encoded string
/// by shifting each letter backward in the alphabet.
class CaesarDecoder extends Converter<String, String> {
  final int shift;

  const CaesarDecoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, 26 - shift));
    }
    return buffer.toString();
  }

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(26 - shift, stringSink);
  }
}

/// A codec that encodes and decodes strings using a
/// [Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher).
class CaesarCodec extends Codec<String, String> {
  @override
  final CaesarEncoder encoder;

  @override
  final CaesarDecoder decoder;

  const CaesarCodec(int shift)
      : encoder = CaesarEncoder(shift),
        decoder = CaesarDecoder(shift);

  /// Creates a [CaesarCodec] that uses ROT13 encoding.
  const CaesarCodec.rot13() : this(13);
}

void main() {
  const codec = CaesarCodec(3);

  final encoded = codec.encode('the quick brown fox');
  print(encoded); // wkh txlfn eurzq ira

  final decoded = codec.decode(encoded);
  print(decoded); // the quick brown fox
}
```

## Design considerations

When designing your own codecs and converters,
keep the following best practices in mind.

### Make codecs const-constructable when possible

If your codec's configuration is able to be immutable,
specify its constructors as `const`.
This lets callers create compile-time constant instances
and follows the pattern set by the built-in codecs.

### Add named parameters for configurable codecs

If a codec supports configuration options,
add named parameters to both the constructor (for defaults)
and the `encode` and `decode` methods (for per-call overrides).
`JsonCodec` demonstrates this pattern,
where its constructor accepts a default `reviver`,
and its `decode` method accepts one that overrides it per call:

```dart
class JsonCodec extends Codec<Object?, String> {
  // ...

  // Constructor sets defaults.
  const JsonCodec({this.reviver, this.toEncodable});

  // Method overrides accept per-call options.

  @override
  dynamic decode(String source, {
    Object? Function(Object?, Object?)? reviver,
  }) { /* ... */ }

  @override
  String encode(Object? value, {
    Object? Function(dynamic)? toEncodable,
  }) { /* ... */ }

  // ...
}
```

### Override fuse for optimized composition

If your codec is commonly composed with another specific codec,
override the `fuse` method to return an optimized implementation.
The built-in `JsonCodec` does this: when fused with `Utf8Codec`,
it returns a codec that uses [`JsonUtf8Encoder`][] to
bypass the intermediate string representation.

[`JsonUtf8Encoder`]: {{site.dart-api}}/dart-convert/JsonUtf8Encoder-class.html

### Choose the right sink base class

Dart provides specialized sink base classes that can
improve performance by avoiding unnecessary conversions:

[`StringConversionSink`][]
: For converters that input or output strings.
  Provides an `addSlice` method with start and end indices
  to avoid substring allocation.

[`ByteConversionSink`][]
: For converters that input or output byte lists.
  Provides an `addSlice` method with start and end indices
  to avoid copying byte ranges.

[`ChunkedConversionSink`][]
: The general-purpose base class.
  Use this when your data is neither strings nor bytes.

:::important
Custom chunked conversion sinks should prefer extending or mixing-in
the corresponding base class rather than implementing the interface directly.
This helps your sink continue to work correctly if
new members are added to super types in the future.
:::

[`StringConversionSink`]: {{site.dart-api}}/dart-convert/StringConversionSink-class.html
[`ByteConversionSink`]: {{site.dart-api}}/dart-convert/ByteConversionSink-class.html
[`ChunkedConversionSink`]: {{site.dart-api}}/dart-convert/ChunkedConversionSink-class.html

### Respect data ownership in sinks

Data passed to a sink's `add` method shouldn't be
modified by the caller afterward.
Sinks are allowed to hold references to the data
rather than copying it immediately.
Since they're immutable, this is naturally safe for strings,
but for `List<int>` byte data, the caller must
either pass a fresh list or avoid reusing it.

The `addSlice` method on `ByteConversionSink` relaxes this restriction because
it accepts `start` and `end` indices with a copy-on-need contract.
Therefore, the caller can reuse the underlying list after the call returns.
This is one of the key performance advantages of the specialized sink classes.

### Handle state across chunks carefully

Some conversions carry state between chunks.
For example, a UTF-8 decoder might receive a chunk
that ends in the middle of a multibyte character.
If your conversion has this property,
store intermediate state in your sink class
and finalize it in the `close` method.

A safe but inefficient fallback for complex conversions is to
buffer all incoming chunks and perform the entire conversion in `close`.
This trades streaming efficiency for implementation simplicity and
might be an appropriate starting point before optimizing.

### Provide top-level instances

Following the convention of the built-in codecs, consider
exposing commonly used configurations as `const` top-level instances:

```dart
/// A [CaesarCodec] with the standard shift of 13 (ROT13).
const rot13 = CaesarCodec.rot13();
```

This makes the codec easy to discover and use.

## What's next

- For detailed documentation on all built-in codecs and converters,
  browse the [`dart:convert` API docs][library-api-docs].
- For examples of well-implemented codecs and converters,
  such as `HexCodec` and its `HexEncoder` and `HexDecoder`,
  reference the implementation of [`package:convert`][].
- If you haven't yet, read the [Converters and codecs][] for
  an introduction to using the built-in codecs and converters.

[library-api-docs]: {{site.dart-api}}/dart-convert
[`package:convert`]: {{site.pub-pkg}}/convert
[Converters and codecs]: /libraries/convert/converters-and-codecs
