import 'dart:async';
import 'package:deferred/hello.dart' deferred as hello;

Future greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}

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
