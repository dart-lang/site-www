import 'package:test/test.dart';

void main() {
  test('var-null-init', () {
    // #docregion var-null-init
    int lineCount;
    assert(lineCount == null);
    // Variables (even if they will be numbers) are initially null.
    // #enddocregion var-null-init
  });
}
