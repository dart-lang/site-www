import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var numbers = [2, 3, 4];
  var items = [1, for (var n in numbers) n * n, 7]; // [1, 4, 9, 16, 7]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([1, 4, 9, 16, 7]));
}
