import 'package:test/test.dart';
import 'package:extension_methods_examples/string_extensions/string_apis_unnamed.dart';

void main() {
  test('unnamed extension isBlank', () {
    expect(isBlank('not-blank'), false);
    expect(isBlank(' not-blank '), false);
    expect(isBlank(''), true);
    expect(isBlank(' '), true);
  });
}
