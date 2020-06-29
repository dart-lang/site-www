// #docregion import
import 'hello.dart' deferred as hello;
// #enddocregion import

// #docregion loadLibrary
Future greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
