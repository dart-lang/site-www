import 'package:test/test.dart';

void main() {
  const aListOfStrings = ['a', 'b', 'c'];

  test('has_empty_long', () {
    // #docregion has-empty-long
    bool hasEmpty = aListOfStrings.any((s) {
      return s.isEmpty;
    });
    // #enddocregion has-empty-long

    expect(hasEmpty, isFalse);
  });

  test('has_empty_short', () {
    // #docregion has-empty-short
    bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
    // #enddocregion has-empty-short

    expect(hasEmpty, isFalse);
  });
}
