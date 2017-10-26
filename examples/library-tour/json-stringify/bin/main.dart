import 'dart:convert' show JSON;

void main() {
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
}
