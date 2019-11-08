@TestOn('vm')
import 'package:hw_mp/hw_mp.dart';
import 'package:test/test.dart';

void main() {
  test('dart:io test', () {
    expect(message, equals('Hello World from the VM!'));
  });
}
