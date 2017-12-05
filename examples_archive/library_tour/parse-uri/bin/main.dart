void main() {
  var uri = Uri.parse('http://example.org:8080/foo/bar#frag');

  assert(uri.scheme == 'http');
  assert(uri.host == 'example.org');
  assert(uri.path == '/foo/bar');
  assert(uri.fragment == 'frag');
  assert(uri.origin == 'http://example.org:8080');
}
