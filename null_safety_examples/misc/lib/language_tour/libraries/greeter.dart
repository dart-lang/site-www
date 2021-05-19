// #docregion import
import 'hello.dart' deferred as hello;
// #enddocregion import

// #docregion loadLibrary
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
