import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var numbers = [1, 2, 3, 4, 5, 6, 7];
  var items = [
    0,
    for (var n in numbers)
      if (n.isEven) n,
    8,
  ]; // [0, 2, 4, 6, 8]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([0, 2, 4, 6, 8]));
}
