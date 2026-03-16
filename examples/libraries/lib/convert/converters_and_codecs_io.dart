// #docregion stream-lines, stream-json, stream-gzip, decode-stream, encoding-param
import 'dart:convert';
import 'dart:io';

// #enddocregion stream-lines, stream-json, stream-gzip, decode-stream, encoding-param

// #docregion stream-lines
void streamLinesExample() async {
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
// #enddocregion stream-lines

// #docregion stream-json
void streamJsonExample() async {
  // Read a JSON file and decode it in a single streaming pipeline.
  final stream = File('data.json')
      .openRead() //
      .transform(utf8.decoder)
      .transform(json.decoder);

  await for (final value in stream) {
    print(value);
  }
}
// #enddocregion stream-json

// #docregion stream-gzip
void streamGzipExample() async {
  final lines = File('log.gz')
      .openRead()
      .transform(gzip.decoder)
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  await for (final line in lines) {
    print(line);
  }
}
// #enddocregion stream-gzip

// #docregion decode-stream
void decodeStreamExample() async {
  // Read and decode an entire file as a single string.
  final stream = File('data.txt').openRead();
  final content = await utf8.decodeStream(stream);
  print(content);
}
// #enddocregion decode-stream

// #docregion encoding-param
void encodingParamExample() async {
  final file = File('output.txt');
  // Write a file in Latin-1 encoding.
  await file.writeAsString('café', encoding: latin1);
}

// #enddocregion encoding-param
