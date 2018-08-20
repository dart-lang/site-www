import 'package:deferred_loading_example/hello.dart' deferred as hello;

main() {
  hello.loadLibrary().then((_) => hello.printGreeting());
}
