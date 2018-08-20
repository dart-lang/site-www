import 'package:test/test.dart' as test;

/// Like the [test.prints] matcher, but accepts non-String arguments. If [any]
/// is an [Iterable], this matches the equivalent of `any.forEach(print)`;
/// otherwise this matches `'$any'`.
test.Matcher prints(dynamic any) {
  Iterable args = any is Iterable ? any : [any];
  return test.prints(args.map((arg) => '$arg').join('\n') + '\n');
}
