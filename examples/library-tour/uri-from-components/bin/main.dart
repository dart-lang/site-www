void main() {
  var uri = new Uri(
      scheme: 'http', host: 'example.org', path: '/foo/bar', fragment: 'frag');
  assert(uri.toString() == 'http://example.org/foo/bar#frag');
}
