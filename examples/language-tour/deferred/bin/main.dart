import 'dart:async';
// #docregion import
import 'package:deferred/hello.dart' deferred as hello;
// #enddocregion import

// #docregion await
Future greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
// #enddocregion await

Future main() async {
  await hello.loadLibrary();
  hello.printGreeting();
  // OR...
  greet();
  greet();
  greet();
  greet();
  greet();
}
