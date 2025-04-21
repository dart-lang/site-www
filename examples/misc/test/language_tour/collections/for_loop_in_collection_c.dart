import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var items = [1, for (var x = 2; x < 4; x++) x, 7]; // [1, 2, 3, 4, 7]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([1, 2, 3, 4, 7]));
}
