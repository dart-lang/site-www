// #docplaster
import 'package:test/test.dart';

void main() {
  test('sublist', () {
    // #docregion param-range
    expect([0, 1, 2, 3].sublist(1, 3), /**/ [1, 2]);
    // #enddocregion param-range
  });

  test('substring', () {
    // #docregion param-range
    expect('abcd'.substring(1, 3), /**/ 'bc');
    // #enddocregion param-range
  });
}
