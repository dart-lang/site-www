// #docregion test-codec
import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:libraries/convert/build_custom_codecs.dart';

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
      final inputSink = codec.encoder.startChunkedConversion(outputSink);
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
      final result = await stream.transform(codec.encoder).join();

      expect(result, equals(codec.encode(input)));
    });
  });
}

// #enddocregion test-codec
