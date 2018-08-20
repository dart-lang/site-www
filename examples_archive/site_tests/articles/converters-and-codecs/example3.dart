import 'dart:convert';
import 'dart:async';

main() async {
  // HtmlEscape synchronously converts Strings to Strings.
  print(const HtmlEscape().convert("foo")); // "foo".
  // When used in a chunked way it converts from Strings
  // to Strings.
  var stream = new Stream.fromIterable(["f", "o", "o"]);
  print(await (stream.transform(const HtmlEscape())
                     .toList())); // ["f", "o", "o"].

  // LineSplitter synchronously converts Strings to Lists of String.
  print(const LineSplitter().convert("foo\nbar")); // ["foo", "bar"]
  // However, asynchronously it converts from Strings to Strings (and
  // not Lists of Strings).
  var stream2 = new Stream.fromIterable(["fo", "o\nb", "ar"]);
  print("${await (stream2.transform(const LineSplitter())
                          .toList())}");
}
