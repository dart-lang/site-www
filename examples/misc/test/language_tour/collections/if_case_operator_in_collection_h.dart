// ignore_for_file: dead_code
import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  var name = 'apple';
  var items = [
    0,
    if (name == 'kiwi') 1 else if (name == 'pear') 10,
    2,
    3,
  ]; // [0, 2, 3]
  // #enddocregion code_sample

  print(items);
  expect(items, equals([0, 2, 3]));
}
