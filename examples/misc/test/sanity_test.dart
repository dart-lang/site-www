import 'package:test/test.dart';

void main() {
  test('assert() checks are enabled', () {
    try {
      assert(false);
    } on AssertionError {
      return;
    }
    fail('assert() checks are disabled');
  });
}
