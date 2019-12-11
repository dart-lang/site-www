// Import a library that contains an extension on String.
// The extension (named NumberParsing) defines the extension methods
// parseInt() and parseDouble().
import 'string_apis.dart';

void main() {
  // WithOUT extension methods.
  print(int.parse('42'));
  print(double.parse('42'));

  // WITH extension methods.
  print('42'.padLeft(5)); // Use a String method.
  print('42'.parseInt()); // Use an extension method.
  print('42'.parseDouble());

  // var vs. dynamic.
  var v = '2';
  print(v.parseInt()); // Output: 2

  dynamic d = '2';
//  print(d.parseInt()); // Runtime exception: NoSuchMethodError
  print(d); // Avoid unusued_local_variable hint.
}
