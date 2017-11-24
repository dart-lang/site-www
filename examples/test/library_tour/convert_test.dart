// #docregion import
import 'dart:convert';
// #enddocregion import
import 'package:test/test.dart';

void main() {
  test('JSON.decode()', () {
    // #docregion JSON-decode
    // NOTE: Be sure to use double quotes ("),
    // not single quotes ('), inside the JSON string.
    // This string is JSON, not Dart.
    var jsonString = '''
      [
        {"score": 40},
        {"score": 80}
      ]
    ''';

    var scores = JSON.decode(jsonString);
    assert(scores is List);

    var firstScore = scores[0];
    assert(firstScore is Map);
    assert(firstScore['score'] == 40);
    // #enddocregion JSON-decode
  });

  test('JSON.encode()', () {
    // #docregion JSON-encode
    var scores = [
      {'score': 40},
      {'score': 80},
      {'score': 100, 'overtime': true, 'special_guest': null}
    ];

    var jsonText = JSON.encode(scores);
    assert(jsonText ==
        '[{"score":40},{"score":80},'
        '{"score":100,"overtime":true,'
        '"special_guest":null}]');
    // #enddocregion JSON-encode
  });

  test('UTF8.encode() & .decode()', () {
    // #docregion UTF8-decode
    List<int> utf8Bytes = [
      0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9, //line-br
      0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3, //line-br
      0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4, //line-br
      0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5, //line-br
      0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1 //line-br
    ];

    var funnyWord = UTF8.decode(utf8Bytes);

    assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
    // #enddocregion UTF8-decode
    // #docregion UTF8-encode
    List<int> encoded = UTF8.encode('Îñţérñåţîöñåļîžåţîờñ');

    assert(encoded.length == utf8Bytes.length);
    for (int i = 0; i < encoded.length; i++) {
      assert(encoded[i] == utf8Bytes[i]);
    }
    // #enddocregion UTF8-encode
  });
}
