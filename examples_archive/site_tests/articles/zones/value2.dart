import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
      .toList();
}

Future splitLines(filename) {
  return splitLinesStream(new File(filename).openRead());
}
main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}