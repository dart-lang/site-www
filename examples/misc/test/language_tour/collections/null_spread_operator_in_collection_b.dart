// ignore_for_file: unchecked_use_of_nullable_value
import 'package:test/test.dart';

// #docregion code_sample
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...extraOptions, // <-- Error
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   Compile-time error
// #enddocregion code_sample

void main() {
  var command = buildCommandLine('dart', ['run', 'my_script.dart'], null);

  print(command);
  expect(command, equals(['dart', 'run', 'my_script.dart']));
}
