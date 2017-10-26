//import 'dart:mirrors';
// BEGIN
import 'todo.dart';

@Todo('seth', 'make this do something')
void doSomething() {
  print('do something');
}
// END

void main() {
  // PENDING: Once reflection on annotations is implemented, show that here.
  print('tbd');
}
