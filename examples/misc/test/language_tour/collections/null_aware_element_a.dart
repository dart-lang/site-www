import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  int? a = null;
  int? b = 3;
  int? c = null;
  var items = [1, ?a, ?b, c, 5]; // [1, 3, null, 5]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([1, 3, null, 5]));
}
