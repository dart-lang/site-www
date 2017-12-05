void main() {
  var uri = 'http://example.org/api?foo=some message';

  var encoded = Uri.encodeFull(uri);
  assert(encoded == 'http://example.org/api?foo=some%20message');

  var decoded = Uri.decodeFull(encoded);
  assert(uri == decoded);
}
