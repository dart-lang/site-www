import 'test.dart';

// #docregion
Future<String> reportUserRole() async {
  var username = await fetchRole();
  return 'User role: $username';
}

Future<String> reportLogins() async {
  var logins = await fetchLoginAmount();
  return 'Total number of logins: $logins';
}
// #enddocregion
