import 'test.dart';

// #docregion
Future<String> changeUsername() async {
  try {
    return await fetchNewUsername();
  } catch (err) {
    return err.toString();
  }
}
// #enddocregion
