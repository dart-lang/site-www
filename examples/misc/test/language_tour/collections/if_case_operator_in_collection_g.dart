import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var name = 'apple';
  var items = [0, if (name == 'orange') 1 else 10, 2, 3]; // [0, 10, 2, 3]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([0, 10, 2, 3]));
}
