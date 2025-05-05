import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var word = 'hello';
  var items = [
    1,
    if (word case String(length: var wordLength)) wordLength,
    3,
  ]; // [1, 5, 3]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([1, 5, 3]));
}
