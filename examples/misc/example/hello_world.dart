import 'package:examples/effective_dart/greeter/greeter.dart';

void main() {
  // #region main
  final message = greet('Dash');
  print(message); // Hello, Dash!
  assert(message == 'Hello, Dash!'); // #hide
  // #endregion
}
