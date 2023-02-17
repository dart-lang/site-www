// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

void main() {
  test('var-null-init', () {
    // #docregion var-null-init
    int? lineCount;
    assert(lineCount == null);
    // #enddocregion var-null-init
  });
}
