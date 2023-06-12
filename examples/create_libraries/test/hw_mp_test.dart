@TestOn('vm')
library;

import 'package:create_libraries/hw_mp.dart';
import 'package:test/test.dart';

void main() {
  test('dart:io test', () {
    expect(message, 'Hello World from the VM!');
  });
}
