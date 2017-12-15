import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
      .map((line) => '${Zone.current[#filename]}: $line')
      .toList();
}

Future splitLines(filename) {
  return runZoned(() {
    return splitLinesStream(new File(filename).openRead());
  }, zoneValues: { #filename: filename });
}
main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}

