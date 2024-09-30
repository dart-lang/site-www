// #docregion import
import 'hello.dart' deferred as hello;
// #enddocregion import

// #docregion load-library
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
// #enddocregion load-library
