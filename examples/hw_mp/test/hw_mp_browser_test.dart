// To run this test:
// cd hw_mp
// pub run test -p chrome
@Tags(['browser'])
@TestOn('browser')

import 'dart:html';

import 'package:hw_mp/src/hw_mp_base.dart';
import 'package:test/test.dart';

void main() {
  test('gets html version of library', () {
    expect(message, equals('Hello World from JavaScript!'));
  });
}
