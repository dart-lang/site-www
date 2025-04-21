import 'package:test/test.dart';

void main() {
  // #docregion code_sample
  dynamic data = 123;
  var typeInfo = [
    if (data case int i) 'Data is an integer: $i',
    if (data case String s) 'Data is a string: $s',
    if (data case bool b) 'Data is a boolean: $b',
    if (data case double d) 'Data is a double: $d',
  ]; // [Data is an integer: 123, Data is a double: 123]
  // #enddocregion code_sample

  print(typeInfo);
  expect(
    typeInfo,
    equals(['Data is an integer: 123', 'Data is a double: 123']),
  );
}
