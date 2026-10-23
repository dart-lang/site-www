import 'dart:convert';

// #docregion caesar-encoder-sink
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
      buffer.writeCharCode(_shiftCodeUnit(chunk.codeUnitAt(i), _shift));
    }
    _output.add(buffer.toString());
    if (isLast) {
      _output.close();
    }
  }

  @override
  void close() => _output.close();
}
// #enddocregion caesar-encoder-sink

// #docregion basic-encoder, caesar-encoder
/// Encodes a string by shifting each letter forward in the alphabet.
// #docregion chunked-encoder
class CaesarEncoder extends Converter<String, String> {
  // #enddocregion chunked-encoder
  /// The number of positions to shift each letter forward.
  final int shift;

  /// Creates an encoder that shifts each letter by [shift] positions.
  const CaesarEncoder(this.shift);

  @override
  String convert(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      buffer.writeCharCode(_shiftCodeUnit(codeUnit, shift));
    }
    return buffer.toString();
  }
  // #enddocregion basic-encoder

  // #docregion chunked-encoder

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    // Wrap the output sink if it isn't already
    // a StringConversionSink.
    // ignore: close_sinks
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(shift, stringSink);
  }

  // #docregion basic-encoder
}
// #enddocregion caesar-encoder, chunked-encoder

// #docregion shift-code-unit
/// Shifts the specified [codeUnit] by
/// [shift] positions in the alphabet.
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
// #enddocregion basic-encoder, shift-code-unit

// #docregion basic-decoder
/// Decodes a Caesar-cipher-encoded string by
/// shifting each letter backward in the alphabet.
// #docregion chunked-decoder
class CaesarDecoder extends Converter<String, String> {
  //#enddocregion chunked-decoder
  /// The number of positions to shift each letter backward.
  final int shift;

  /// Creates a decoder that reverses a Caesar cipher with [shift] positions.
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
  // #enddocregion basic-decoder

  // #docregion chunked-decoder

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    // Wrap the output sink if it isn't already
    // a StringConversionSink.
    // ignore: close_sinks
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(26 - shift, stringSink);
  }

  // #docregion basic-decoder
}
// #enddocregion basic-decoder, chunked-decoder

// #docregion caesar-codec
/// A codec that encodes and decodes strings using a
/// [Caesar cipher](https://wikipedia.org/wiki/Caesar_cipher).
class CaesarCodec extends Codec<String, String> {
  /// The number of positions to shift each letter.
  final int shift;

  /// Creates a Caesar cipher codec with the given [shift].
  const CaesarCodec(this.shift);

  /// Creates a [CaesarCodec] that uses ROT13 encoding.
  const CaesarCodec.rot13() : shift = 13;

  @override
  CaesarEncoder get encoder => CaesarEncoder(shift);

  @override
  CaesarDecoder get decoder => CaesarDecoder(shift);
}
// #enddocregion caesar-codec

// #docregion use-encoder
void useEncoderExample() {
  const encoder = CaesarEncoder(3);
  print(encoder.convert('hello')); // khoor
  print(encoder.convert('xyz')); // abc
}
// #enddocregion use-encoder

// #docregion use-codec
void useCodecExample() {
  const cipher = CaesarCodec(3);

  final encoded = cipher.encode('hello');
  print(encoded); // khoor

  final decoded = cipher.decode(encoded);
  print(decoded); // hello

  // The `inverted` getter returns a new codec that
  // converts in the inverse direction of the original codec.
  final inverted = cipher.inverted;
  print(inverted.encode('khoor')); // hello
}
// #enddocregion use-codec

// #docregion top-level-instance
/// A [CaesarCodec] with the standard shift of 13 (ROT13).
const rot13 = CaesarCodec.rot13();
// #enddocregion top-level-instance
