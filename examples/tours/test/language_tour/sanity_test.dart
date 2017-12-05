// ignore_for_file: unused_local_variable
import 'package:test/test.dart';

void main() {
  test('ensure assert() is checked', () {
    try {
      assert(false);
      expect(false, isTrue);
    } on AssertionError {
      return;
    }
    expect(false, isTrue);
  });
}
