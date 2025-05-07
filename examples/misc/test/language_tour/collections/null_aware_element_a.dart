// ignore_for_file: avoid_init_to_null, invalid_null_aware_operator
import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  int? absentValue = null;
  int? presentValue = 3;
  var items = [1, ?absentValue, ?presentValue, absentValue, 5]; // [1, 3, null, 5]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([1, 3, null, 5]));
}
