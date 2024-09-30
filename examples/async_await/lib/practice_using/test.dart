import 'package:examples_util/codelabs.dart';

import 'solution.dart';

const _result = result;

// #docregion
const role = 'administrator';
const logins = 42;
const passed = 'PASSED';
const testFailedMessage = 'Test failed for the function:';
const typoMessage = 'Test failed! Check for typos in your return value';
const didNotImplement =
    'Test failed! Did you forget to implement or return from ';
const oneSecond = Duration(seconds: 1);
List<String> messages = [];
Future<String> fetchRole() => Future.delayed(oneSecond, () => role);
Future<int> fetchLoginAmount() => Future.delayed(oneSecond, () => logins);

void main() async {
  try {
    messages
      ..add(makeReadable(
          testLabel: 'Part 1',
          testResult: await asyncEquals(
              expected: 'User role: administrator',
              actual: await reportUserRole(),
              typoKeyword: role),
          readableErrors: {
            typoMessage: typoMessage,
            'null': '$didNotImplement reportUserRole?',
            'User role: Instance of \'Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role: Instance of \'_Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role:':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: ':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: tester':
                '$testFailedMessage reportUserRole. Did you invoke fetchRole to fetch the user\'s role?',
          }))
      ..add(makeReadable(
          testLabel: 'Part 2',
          testResult: await asyncEquals(
              expected: 'Total number of logins: 42',
              actual: await reportLogins(),
              typoKeyword: logins.toString()),
          readableErrors: {
            typoMessage: typoMessage,
            'null': '$didNotImplement reportLogins?',
            'Total number of logins: Instance of \'Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: Instance of \'_Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: ':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins:':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins: 57':
                '$testFailedMessage reportLogins. Did you invoke fetchLoginAmount to fetch the number of user logins?',
          }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      _result(true);
    } else {
      _result(false, messages);
    }
  } on UnimplementedError {
    _result(false, [
      '$didNotImplement reportUserRole?',
    ]);
  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: $e']);
  }
}

////////////////////////////////////////
///////////// Test Helpers /////////////
////////////////////////////////////////
String makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    var readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

///////////////////////////////////////
//////////// Assertions ///////////////
///////////////////////////////////////
Future<String> asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return passed;
    } else if (strActual.contains(typoKeyword)) {
      return typoMessage;
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}
// #enddocregion
