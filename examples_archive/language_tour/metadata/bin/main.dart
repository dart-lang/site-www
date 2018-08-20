//import 'dart:mirrors';
// #docregion
import 'todo.dart';

@Todo('seth', 'make this do something')
void doSomething() {
  print('do something');
}
// #enddocregion

void main() {
  // PENDING: Once reflection on annotations is implemented, show that here.
  print('tbd');
}
