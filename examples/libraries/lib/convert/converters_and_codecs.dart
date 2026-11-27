// #docregion encode-decode, encoder-decoder, custom-config, fuse-codec, fuse-converter, encoding-lookup
import 'dart:convert';

// #enddocregion encode-decode, encoder-decoder, custom-config, fuse-codec, fuse-converter, encoding-lookup

// #docregion encode-decode
void encodeDecodeExample() {
  // Encode a Dart object to a JSON string.
  final jsonString = json.encode({'name': 'Dash', 'age': 5});
  print(jsonString); // {"name":"Dash","age":5}

  // Decode a JSON string back to a Dart object.
  final data = json.decode(jsonString) as Map<String, Object?>;
  print(data['name']); // Dash
}
// #enddocregion encode-decode

// #docregion encoder-decoder
void encoderDecoderExample() {
  final bytes = utf8.encoder.convert('Hello, 世界!');
  print(bytes); // [72, 101, 108, 108, 111, ...]

  final text = utf8.decoder.convert(bytes);
  print(text); // Hello, 世界!
}
// #enddocregion encoder-decoder

// #docregion custom-config
void customConfigExample() {
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
// #enddocregion custom-config

// #docregion fuse-codec
// Create a codec that goes directly from Dart objects to UTF-8 bytes.
final Codec<Object?, List<int>> jsonUtf8 = json.fuse(utf8);

void fuseCodecExample() {
  // Encode directly to bytes without an intermediate string.
  final bytes = jsonUtf8.encode({'greeting': 'hello'});
  print(bytes); // [123, 34, 103, ...]

  // Decode directly from bytes without an intermediate string.
  final data = jsonUtf8.decode(bytes) as Map<String, Object?>;
  print(data['greeting']); // hello
}
// #enddocregion fuse-codec

// #docregion fuse-converter
void fuseConverterExample() {
  // Chain two converters: JSON encode, then UTF-8 encode.
  final encoder = json.encoder.fuse(utf8.encoder);
  final bytes = encoder.convert({'key': 'value'});
  print(bytes); // [123, 34, 107, ...]
}
// #enddocregion fuse-converter

// #docregion encoding-lookup
void encodingLookupExample() {
  final encoding = Encoding.getByName('utf-8');
  print(encoding?.name); // utf-8
}

// #enddocregion encoding-lookup
