import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Rot extends Codec<List<int>, List<int>> {
  final key;
  const Rot(this.key);

  List<int> encode(List<int> data, {int key}) {
    if (key == null) key = this.key;
    return new RotConverter(key).convert(data);
  }

  List<int> decode(List<int> data, {int key}) {
    if (key == null) key = this.key;
    return new RotConverter(-key).convert(data);
  }

  RotConverter get encoder => new RotConverter(key);
  RotConverter get decoder => new RotConverter(-key);
}

abstract class CipherSink extends ChunkedConversionSink<List<int>> {
  void addModifiable(List<int> data) {
    add(data);
  }
}

class RotConverter extends Converter<List<int>, List<int>> {
  final _key;
  const RotConverter(this._key);

  List<int> convert(List<int> data, {int key}) {
    if (key == null) key = this._key;
    var result = new List<int>(data.length);
    for (int i = 0; i < data.length; i++) {
      result[i] = (data[i] + key) % 256;
    }
    return result;
  }

  /// Works more efficiently if given a CipherSink as argument.
  CipherSink startChunkedConversion(
      ChunkedConversionSink<List<int>> sink) {
    if (sink is! CipherSink) sink = new _CipherSinkAdapter(sink);
    return new _RotSink(_key, sink);
  }
}

class _CipherSinkAdapter implements CipherSink {
  ChunkedConversionSink<List<int>> sink;
  _CipherSinkAdapter(this.sink);

  void add(data) {
    sink.add(data);
  }
  void addModifiable(data) {
    sink.add(data);
  }
  void close() {
    sink.close();
  }
}

class _RotSink extends CipherSink {
  final _key;
  final CipherSink _outSink;
  _RotSink(this._key, this._outSink);

  void add(List<int> data) {
    addModifiable(new Uint8List.fromList(data));
  }

  void addModifiable(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = (data[i] + _key) % 256;
    }
    _outSink.addModifiable(data);
  }

  void close() {
    _outSink.close();
  }
}

class ToModifiableConverter extends Converter<List<int>, List<int>> {
  List<int> convert(List<int> data) => data;
  ToModifiableSink startChunkedConversion(CipherSink sink) {
    return new ToModifiableSink(sink);
  }
}

class ToModifiableSink extends ChunkedConversionSink<List<int>> {
  final CipherSink sink;
  ToModifiableSink(this.sink);

  void add(List<int> data) {
    sink.addModifiable(data);
  }
  void close() {
    sink.close();
  }
}

const Rot ROT128 = const Rot(128);
const Rot ROT1 = const Rot(1);
main2() {
  print(const RotConverter(128).convert([0, 128, 255, 1]));
  print(const RotConverter(128).convert([128, 0, 127, 129]));
  print(const RotConverter(-128).convert([128, 0, 127, 129]));

  print(ROT1.decode(ROT1.encode([0, 128, 255, 1])));
  print(ROT128.decode(ROT128.encode([0, 128, 255, 1])));

  var outSink = new ChunkedConversionSink<List<int>>.withCallback(
      (chunks) {
    print(chunks);
  });
  var inSink = new RotConverter(30).startChunkedConversion(outSink);
  inSink.add([1, 2, 3]);
  inSink.add([250, 251, 252]);
  inSink.close();
}

main8(args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  new File(inFile)
      .openRead()
      .transform(new RotConverter(key))
      .pipe(new File(outFile).openWrite());
}

main4() {
  var outSink = new ChunkedConversionSink<List<int>>.withCallback(
      (chunks) {
    print(chunks);
  });
  var inSink = new RotConverter(30).startChunkedConversion(outSink);
  inSink.addModifiable([1, 2, 3]);
  inSink.addModifiable([250, 251, 252]);
  inSink.close();
}

main5(args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  new File(inFile)
      .openRead()
      .transform(
          new ToModifiableConverter().fuse(new RotConverter(key)))
      .pipe(new File(outFile).openWrite());
}

main(args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  var transformer = new ToModifiableConverter()
      .fuse(new RotConverter(key))
      .fuse(new RotConverter(key));
  new File(inFile)
      .openRead()
      .transform(transformer)
      .pipe(new File(outFile).openWrite());
}
