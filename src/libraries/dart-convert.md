---
title: dart:convert
description: Learn about the major features in Dart's dart:convert library.
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>


## decoding and encoding JSON, UTF-8, and more

The dart:convert library ([API reference][dart:convert])
has converters for JSON and UTF-8, as well as support for creating
additional converters. [JSON][] is a simple text format for representing
structured objects and collections. [UTF-8][] is a common variable-width
encoding that can represent every character in the Unicode character
set.

To use this library, import dart:convert.

<?code-excerpt "misc/test/library_tour/convert_test.dart (import)"?>
```dart
import 'dart:convert';
```


### Decoding and encoding JSON

Decode a JSON-encoded string into a Dart object with `jsonDecode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-decode)"?>
```dart
// NOTE: Be sure to use double quotes ("),
// not single quotes ('), inside the JSON string.
// This string is JSON, not Dart.
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
```

Encode a supported Dart object into a JSON-formatted string with
`jsonEncode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-encode)"?>
```dart
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null}
];

var jsonText = jsonEncode(scores);
assert(jsonText ==
    '[{"score":40},{"score":80},'
        '{"score":100,"overtime":true,'
        '"special_guest":null}]');
```

Only objects of type int, double, String, bool, null, List, or Map (with
string keys) are directly encodable into JSON. List and Map objects are
encoded recursively.

You have two options for encoding objects that aren't directly
encodable. The first is to invoke `jsonEncode()` with a second argument: a
function that returns an object that is directly encodable. Your second
option is to omit the second argument, in which case the encoder calls
the object's `toJson()` method.

For more examples and links to JSON-related packages, see
[Using JSON](/guides/json).


### Decoding and encoding UTF-8 characters

Use `utf8.decode()` to decode UTF8-encoded bytes to a Dart string:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-decode)" replace="/ \/\/line-br.*//g"?>
```dart
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
```

To convert a stream of UTF-8 characters into a Dart string, specify
`utf8.decoder` to the Stream `transform()` method:

<?code-excerpt "misc/test/library_tour/io_test.dart (utf8-decoder)" replace="/utf8.decoder/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var lines = [!utf8.decoder!].bind(inputStream).transform(const LineSplitter());
try {
  await for (final line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
{% endprettify %}

Use `utf8.encode()` to encode a Dart string as a list of UTF8-encoded
bytes:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-encode)" replace="/ \/\/line-br.*//g"?>
```dart
Uint8List encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
```


### Other functionality

The dart:convert library also has converters for ASCII and ISO-8859-1
(Latin1). For details, see the [API reference for the dart:convert library.][dart:convert]

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