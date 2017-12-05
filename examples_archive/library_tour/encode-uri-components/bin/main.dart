void main() {
  var uri = 'http://example.org/api?foo=some message';

  var encoded = Uri.encodeComponent(uri);
  assert(encoded == 'http%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message');

  var decoded = Uri.decodeComponent(encoded);
  assert(uri == decoded);
}
