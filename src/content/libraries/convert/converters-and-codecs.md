---
title: Converters and codecs
description: >-
  Learn how to use Dart's codec and converter classes
  to encode, decode, and transform data.
---

<?code-excerpt path-base="libraries"?>
<?code-excerpt plaster="none"?>

The [`dart:convert`][] library provides a framework for
encoding, decoding, and transforming data in Dart.
At its core are two abstractions:
**converters** that transform data from one representation to another and
**codecs** that group two inverse converters together.

You already use this system every time you call [`json.decode`][] or
read a text file with [`Utf8Decoder`][] retrieved using [`utf8.decoder`][].
This guide explains the concepts behind these tools
and shows you how to get more out of them.

[`dart:convert`]: {{site.dart-api}}/dart-convert
[`json.decode`]: {{site.dart-api}}/dart-convert/JsonCodec/decode.html
[`Utf8Decoder`]: {{site.dart-api}}/dart-convert/Utf8Decoder-class.html
[`utf8.decoder`]: {{site.dart-api}}/dart-convert/Utf8Codec/decoder.html

## What codecs and converters are

[`Converter`][]
: Transforms data from one type to another.
  Every converter extends `Converter<S, T>`,
  where `S` is the input type and `T` is the output type.
  For example, `JsonEncoder` converts a Dart object to a JSON string,
  and `Utf8Encoder` converts a string to UTF-8 bytes.

[`Codec`][]
: Groups two converters that are inverses of each other:
  an encoder and a decoder.
  Every codec extends `Codec<S, T>`,
  where encoding goes from `S` to `T`
  and decoding goes from `T` back to `S`.
  For example, `JsonCodec` pairs `JsonEncoder` with `JsonDecoder`.

Converters also implement [`StreamTransformer`][].
As a result, you can use any converter directly with
the [`Stream.transform`][] instance method to process data incrementally,
without loading everything into memory at once.

[`Converter`]: {{site.dart-api}}/dart-convert/Converter-class.html
[`Codec`]: {{site.dart-api}}/dart-convert/Codec-class.html
[`StreamTransformer`]: {{site.dart-api}}/dart-async/StreamTransformer-class.html
[`Stream.transform`]: {{site.dart-api}}/dart-async/Stream/transform.html

## Built-in codecs

Besides JSON and UTF-8, the `dart:convert` library provides
codecs for several common formats.
It also provides top-level variables with
default-configured codec instances for convenience:

| Codec class       | Encodes from | Encodes to    | Default instance |
|-------------------|--------------|---------------|------------------|
| [`JsonCodec`][]   | Objects      | JSON string   | [`json`][]       |
| [`Utf8Codec`][]   | String       | UTF-8 bytes   | [`utf8`][]       |
| [`AsciiCodec`][]  | String       | ASCII bytes   | [`ascii`][]      |
| [`Latin1Codec`][] | String       | Latin-1 bytes | [`latin1`][]     |
| [`Base64Codec`][] | Bytes        | Base64 string | [`base64`][]     |

{:.table .table-striped}

The `dart:io` library additionally provides a few compression codecs:

| Codec class     | Encodes from | Encodes to            | Default instance |
|-----------------|--------------|-----------------------|------------------|
| [`GZipCodec`][] | Bytes        | GZip-compressed bytes | [`gzip`][]       |
| [`ZLibCodec`][] | Bytes        | ZLib-compressed bytes | [`zlib`][]       |

{:.table .table-striped}

Besides the provided codecs and their converters,
`dart:convert` also provides the [`HtmlEscape`][] converter,
a converter that escapes HTML special characters, and [`LineSplitter`][],
a stream transformer that splits strings into individual lines.

[`JsonCodec`]: {{site.dart-api}}/dart-convert/JsonCodec-class.html
[`json`]: {{site.dart-api}}/dart-convert/json-constant.html
[`Utf8Codec`]: {{site.dart-api}}/dart-convert/Utf8Codec-class.html
[`utf8`]: {{site.dart-api}}/dart-convert/utf8-constant.html
[`AsciiCodec`]: {{site.dart-api}}/dart-convert/AsciiCodec-class.html
[`ascii`]: {{site.dart-api}}/dart-convert/ascii-constant.html
[`Latin1Codec`]: {{site.dart-api}}/dart-convert/Latin1Codec-class.html
[`latin1`]: {{site.dart-api}}/dart-convert/latin1-constant.html
[`Base64Codec`]: {{site.dart-api}}/dart-convert/Base64Codec-class.html
[`base64`]: {{site.dart-api}}/dart-convert/base64-constant.html

[`GZipCodec`]: {{site.dart-api}}/dart-io/GZipCodec-class.html
[`gzip`]: {{site.dart-api}}/dart-io/gzip-constant.html
[`ZLibCodec`]: {{site.dart-api}}/dart-io/ZLibCodec-class.html
[`zlib`]: {{site.dart-api}}/dart-io/zlib-constant.html

[`HtmlEscape`]: {{site.dart-api}}/dart-convert/HtmlEscape-class.html
[`LineSplitter`]: {{site.dart-api}}/dart-convert/LineSplitter-class.html

## Encode and decode data

Every codec provides [`encode`][] and [`decode`][] convenience methods.
These delegate to the codec's [`encoder`][] and [`decoder`][] converters:

<?code-excerpt "lib/convert/converters_and_codecs.dart (encode-decode)" replace="/encodeDecodeExample/main/g"?>
```dart highlightLines=5,9
import 'dart:convert';

void main() {
  // Encode a Dart object to a JSON string.
  final jsonString = json.encode({'name': 'Dash', 'age': 5});
  print(jsonString); // {"name":"Dash","age":5}

  // Decode a JSON string back to a Dart object.
  final data = json.decode(jsonString) as Map<String, Object?>;
  print(data['name']); // Dash
}
```

The top-level functions [`jsonEncode`][] and [`jsonDecode`][]
are shorthand for [`json.encode`][] and [`json.decode`][].
The same pattern applies to some other built-in converters,
such as [`base64Decode`][] being a shorthand for [`base64.decode`][].

You can also use the [`encoder`][] and [`decoder`][] properties
to access the underlying converters:

<?code-excerpt "lib/convert/converters_and_codecs.dart (encoder-decoder)" replace="/encoderDecoderExample/main/g"?>
```dart highlightLines=4,7
import 'dart:convert';

void main() {
  final bytes = utf8.encoder.convert('Hello, 世界!');
  print(bytes); // [72, 101, 108, 108, 111, ...]

  final text = utf8.decoder.convert(bytes);
  print(text); // Hello, 世界!
}
```

The shorthands and the default top-level codec instances use
a default configuration of the underlying converters.
If you want to customize them, you can
create custom instances of the converters and codecs:

<?code-excerpt "lib/convert/converters_and_codecs.dart (custom-config)" replace="/customConfigExample/main/g"?>
```dart highlightLines=5-6,14-15
import 'dart:convert';

void main() {
  // Pretty-print JSON with two-space indentation.
  const encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert({'name': 'Dash', 'age': 5}));
  // {
  //   "name": "Dash",
  //   "age": 5
  // }

  // Leniently decode UTF-8 that might contain invalid byte sequences
  // instead of throwing a FormatException.
  const lenientUtf8 = Utf8Codec(allowMalformed: true);
  final decoded = lenientUtf8.decode([0x48, 0x65, 0xFF, 0x6C]);
  print(decoded); // He�l
}
```

[`encode`]: {{site.dart-api}}/dart-convert/Codec/encode.html
[`decode`]: {{site.dart-api}}/dart-convert/Codec/decode.html
[`encoder`]: {{site.dart-api}}/dart-convert/Codec/encoder.html
[`decoder`]: {{site.dart-api}}/dart-convert/Codec/decoder.html

[`jsonEncode`]: {{site.dart-api}}/dart-convert/jsonEncode.html
[`jsonDecode`]: {{site.dart-api}}/dart-convert/jsonDecode.html
[`json.encode`]: {{site.dart-api}}/dart-convert/JsonCodec/encode.html
[`json.decode`]: {{site.dart-api}}/dart-convert/JsonCodec/decode.html
[`base64Decode`]: {{site.dart-api}}/dart-convert/base64Decode.html
[`base64.decode`]: {{site.dart-api}}/dart-convert/Base64Codec/decode.html

## Compose codecs with fuse

One of the most powerful features of codecs is composition.
The [`fuse`][codec-fuse] method on `Codec` combines two codecs into one,
potentially eliminating the intermediate representation:

<?code-excerpt "lib/convert/converters_and_codecs.dart (fuse-codec)" replace="/fuseCodecExample/main/g;"?>
```dart highlightLines=4,8,12
import 'dart:convert';

// Create a codec that goes directly from Dart objects to UTF-8 bytes.
final Codec<Object?, List<int>> jsonUtf8 = json.fuse(utf8);

void main() {
  // Encode directly to bytes without an intermediate string.
  final bytes = jsonUtf8.encode({'greeting': 'hello'});
  print(bytes); // [123, 34, 103, ...]

  // Decode directly from bytes without an intermediate string.
  final data = jsonUtf8.decode(bytes) as Map<String, Object?>;
  print(data['greeting']); // hello
}
```

When you fuse `json` with `utf8`, the result isn't just
a wrapper that calls `utf8.encode(json.encode(data))`.
The `JsonCodec` class overrides `fuse` to use [`JsonUtf8Encoder`][],
an optimized encoder implementation that directly
writes UTF-8 bytes without creating an intermediate JSON string.
This makes `json.fuse(utf8)` both more convenient and more efficient
than encoding in two separate steps.

Converters also have a [`fuse`][converter-fuse] method for
composing one-way transformations:

<?code-excerpt "lib/convert/converters_and_codecs.dart (fuse-converter)" replace="/fuseConverterExample/main/g"?>
```dart highlightLines=5-6
import 'dart:convert';

void main() {
  // Chain two converters: JSON encode, then UTF-8 encode.
  final encoder = json.encoder.fuse(utf8.encoder);
  final bytes = encoder.convert({'key': 'value'});
  print(bytes); // [123, 34, 107, ...]
}
```

[codec-fuse]: {{site.dart-api}}/dart-convert/Codec/fuse.html
[converter-fuse]: {{site.dart-api}}/dart-convert/Converter/fuse.html
[`JsonUtf8Encoder`]: {{site.dart-api}}/dart-convert/JsonUtf8Encoder-class.html

## Transform streams with converters

Because every `Converter` implements [`StreamTransformer`][],
you can use converters to process data as it flows through a stream.
This can be important when working with large files or network data
that shouldn't be loaded entirely into memory at once.

Use the [`transform`][] method to apply a converter to a stream:

<?code-excerpt "lib/convert/converters_and_codecs_io.dart (stream-lines)" replace="/streamLinesExample/main/g"?>
```dart highlightLines=7-10
import 'dart:convert';
import 'dart:io';

void main() async {
  // Read a file as a stream of bytes, decode UTF-8 into a string,
  // then split the single string into lines.
  final lines = File('data.txt')
      .openRead() //
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  await for (final line in lines) {
    print(line);
  }
}
```

You can build longer transformation pipelines by
chaining multiple `transform` calls or by fusing converters first:

<?code-excerpt "lib/convert/converters_and_codecs_io.dart (stream-json)" replace="/streamJsonExample/main/g"?>
```dart highlightLines=6-9
import 'dart:convert';
import 'dart:io';

void main() async {
  // Read a JSON file and decode it in a single streaming pipeline.
  final stream = File('data.json')
      .openRead() //
      .transform(utf8.decoder)
      .transform(json.decoder);

  await for (final value in stream) {
    print(value);
  }
}
```

Streaming conversion is especially useful with compression.
The following example decompresses and decodes a gzipped text file
without loading the entire file into memory:

<?code-excerpt "lib/convert/converters_and_codecs_io.dart (stream-gzip)" replace="/streamGzipExample/main/g"?>
```dart highlightLines=5-9
import 'dart:convert';
import 'dart:io';

void main() async {
  final lines = File('log.gz')
      .openRead()
      .transform(gzip.decoder)
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  await for (final line in lines) {
    print(line);
  }
}
```

[`StreamTransformer`]: {{site.dart-api}}/dart-async/StreamTransformer-class.html
[`transform`]: {{site.dart-api}}/dart-async/Stream/transform.html

## Character encodings

The [`Encoding`][] base class is specialized for character-encoding codecs,
where its subclasses encode and decode strings to lists of bytes.
It adds a `name` property and a static `getByName` method
for looking up built-in, supported encodings by their [IANA name][]:

<?code-excerpt "lib/convert/converters_and_codecs.dart (encoding-lookup)" replace="/encodingLookupExample/main/g"?>
```dart highlightLines=4
import 'dart:convert';

void main() {
  final encoding = Encoding.getByName('utf-8');
  print(encoding?.name); // utf-8
}
```

The built-in encodings include:

- UTF-8 with [`Utf8Codec`][] and a `name` of "utf-8".
- ASCII with [`AsciiCodec`][] and a `name` of "us-ascii".
- ISO Latin-1 with [`Latin1Codec`][] and a `name` of "iso-8859-1".

For other character sets such as UTF-16, GBK, or Shift-JIS,
check out third-party packages like [`package:charset`][] that
provide many codecs implementing the `Encoding` interface.

`Encoding` also provides a default implementation of [`decodeStream`][].
In contrast to `Stream.transform` which returns a `Stream<String>`,
the `decodeStream` method reads a byte stream and
returns a single decoded `String` (wrapped in a `Future`).

<?code-excerpt "lib/convert/converters_and_codecs_io.dart (decode-stream)" replace="/decodeStreamExample/main/g"?>
```dart highlightLines=6-7
import 'dart:convert';
import 'dart:io';

void main() async {
  // Read and decode an entire file as a single string.
  final stream = File('data.txt').openRead();
  final content = await utf8.decodeStream(stream);
  print(content);
}
```

Many `dart:io` APIs accept an `Encoding` parameter,
making it straightforward to read and write files with
different character encodings:

<?code-excerpt "lib/convert/converters_and_codecs_io.dart (encoding-param)" replace="/encodingParamExample/main/g"?>
```dart highlightLines=7
import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('output.txt');
  // Write a file in Latin-1 encoding.
  await file.writeAsString('café', encoding: latin1);
}
```

[`Encoding`]: {{site.dart-api}}/dart-convert/Encoding-class.html
[`decodeStream`]: {{site.dart-api}}/dart-convert/Encoding/decodeStream.html
[`package:charset`]: {{site.pub-pkg}}/charset
[iana name]: https://www.iana.org/assignments/character-sets/character-sets.xhtml

## Codecs versus `fromJson` and `toJson` {:#when-to-use-codecs}

For serialization of application-level data and objects,
where you want to convert between Dart model classes and JSON,
the `fromJson` and `toJson` convention supported by packages such as
[`package:json_serializable`][] is the idiomatic approach in Dart apps.
These tools generate simple factory constructors and methods
that work directly with `Map<String, Object?>`.

The `Codec` and `Converter` classes serve a different purpose.
They're designed for data format transformations:
encoding schemes, compression, character sets, and
other conversions where streaming support, bidirectional symmetry,
and composability through `fuse` matter.

If the conversion is about how data is _represented_,
such as with bytes, strings, or compressed data,
the codec pattern is a natural fit.
If the conversion is about how data is _structured_,
such as mapping JSON fields to Dart class properties,
use a pattern like `fromJson` and `toJson`.

If you do want to build your own codecs and converters,
check out [Build custom codecs and converters][].

[`package:json_serializable`]: {{site.pub-pkg}}/json_serializable
[`package:freezed`]: {{site.pub-pkg}}/freezed
[Build custom codecs and converters]: /libraries/convert/build-custom-codecs
