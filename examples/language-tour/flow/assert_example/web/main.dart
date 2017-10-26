void main() {
  var text = 'Hi';
  var number = 99;
  String urlString = 'https://github.com/';
  bool showMessage = true;

  // Make sure the variable has a non-null value.
  assert(text != null);

  // Make sure the value is less than 100.
  assert(number < 100);

  // Make sure this is an https URL.
  if (!showMessage) {
    assert(urlString.startsWith('https'));
  } else {
    assert(urlString.startsWith('https'),
        'URL ($urlString) should start with "https".');
  }

  print('About to call assert(false).');
  assert(false);
  print('Oops, you weren\'t running in checked mode.');
}
