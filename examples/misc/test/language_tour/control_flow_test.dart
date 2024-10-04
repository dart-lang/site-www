import 'package:test/test.dart';

void main() {
  test('assert', () {
    // trick to make text nullable
    String? nullableText() => '';
    String? text = nullableText();
    var number = 0, urlString = 'https';
    // #docregion assert
    // Make sure the variable has a non-null value.
    assert(text != null);

    // Make sure the value is less than 100.
    assert(number < 100);

    // Make sure this is an https URL.
    assert(urlString.startsWith('https'));
    // #enddocregion assert

    // #docregion assert-with-message
    assert(urlString.startsWith('https'),
        'URL ($urlString) should start with "https".');
    // #enddocregion assert-with-message
  });
}
