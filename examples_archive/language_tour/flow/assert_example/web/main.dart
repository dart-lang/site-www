void main() {
  var text = 'Hi';
  var number = 99;
  String urlString = 'https://github.com/';

  // #docregion
  // Make sure the variable has a non-null value.
  assert(text != null);

  // Make sure the value is less than 100.
  assert(number < 100);

  // Make sure this is an https URL.
  assert(urlString.startsWith('https'));
  // #enddocregion

  // #docregion assert-with-message
  assert(urlString.startsWith('https'),
      'URL ($urlString) should start with "https".');
  // #enddocregion assert-with-message

  print('About to call assert(false).');
  assert(false);
  print('Oops, you weren\'t running in checked mode.');
}
