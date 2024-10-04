import 'package:test/test.dart' as test;

/// Like the [test.prints] matcher, but accepts non-String arguments. If [any]
/// is an [Iterable], this matches the equivalent of `any.forEach(print)`;
/// otherwise this matches `'$any'`.
test.Matcher prints(dynamic any) {
  final args = any is Iterable ? any : [any];
  return test.prints('${args.map((arg) => '$arg').join('\n')}\n');
}

/// Cleans up [lines] by trimming off leading whitespace and adding a trailing
/// newline before passing the result to the test package [prints] matcher.
test.Matcher printsLines(String lines) {
  lines = _trim(lines);
  if (!lines.endsWith('\n')) lines += '\n';
  return test.prints(lines);
}

String _trim(String s) => s.trimLeft().replaceAll(RegExp(r'\n\s*'), '\n');
