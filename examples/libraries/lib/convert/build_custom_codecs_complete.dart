// #docregion complete
import 'dart:convert';

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

/// Encodes a string by shifting each letter forward in the alphabet.
class CaesarEncoder extends Converter<String, String> {
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

  @override
  StringConversionSink startChunkedConversion(Sink<String> sink) {
    // ignore: close_sinks
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(shift, stringSink);
  }
}

/// Decodes a Caesar-cipher-encoded string
/// by shifting each letter backward in the alphabet.
class CaesarDecoder extends Converter<String, String> {
  /// The number of positions to shift each letter backward.
  final int shift;

  /// Creates a decoder that reverses a Caesar cipher with [shift] positions.
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
    // ignore: close_sinks
    final stringSink = sink is StringConversionSink
        ? sink
        : StringConversionSink.from(sink);
    return _CaesarEncoderSink(26 - shift, stringSink);
  }
}

/// A codec that encodes and decodes strings using a
/// [Caesar cipher](https://wikipedia.org/wiki/Caesar_cipher).
class CaesarCodec extends Codec<String, String> {
  /// The number of positions to shift each letter.
  final int shift;

  @override
  CaesarEncoder get encoder => CaesarEncoder(shift);

  @override
  CaesarDecoder get decoder => CaesarDecoder(shift);

  /// Creates a Caesar cipher codec with the given [shift].
  const CaesarCodec(this.shift);

  /// Creates a [CaesarCodec] that uses ROT13 encoding.
  const CaesarCodec.rot13() : shift = 13;
}

void main() {
  const codec = CaesarCodec(3);

  final encoded = codec.encode('the quick brown fox');
  print(encoded); // wkh txlfn eurzq ira

  final decoded = codec.decode(encoded);
  print(decoded); // the quick brown fox
}

// #enddocregion complete
