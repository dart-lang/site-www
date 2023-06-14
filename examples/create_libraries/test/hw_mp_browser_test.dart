@Tags(['browser'])
@TestOn('browser')
library;

import 'package:create_libraries/hw_mp.dart';
import 'package:test/test.dart';

void main() {
  test('gets html version of library', () {
    expect(message, 'Hello World from JavaScript!');
  });
}
