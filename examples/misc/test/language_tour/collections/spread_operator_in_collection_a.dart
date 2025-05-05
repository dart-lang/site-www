import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var a = [1, 2, null, 4];
  var items = [0, ...a, 5]; // [0, 1, 2, null, 4, 5]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([0, 1, 2, null, 4, 5]));
}
