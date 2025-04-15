// #docregion code_sample
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...?extraOptions, // <-- OK now.
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   [dart, run, my_script.dart]
// #enddocregion code_sample

void main() {
  var command = buildCommandLine('dart', ['run', 'my_script.dart'], null);
  print(command);
}
