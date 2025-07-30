import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var includeItem = true;
  var items = [0, if (includeItem) 1, 2, 3]; // [0, 1, 2, 3]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([0, 1, 2, 3]));
}
