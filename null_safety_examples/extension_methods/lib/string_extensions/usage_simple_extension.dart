// ignore_for_file: dead_code
// #docregion import-and-use
// Import a library that contains an extension on String.
// #docregion basic
import 'string_apis.dart';
// #enddocregion basic, import-and-use

void main() {
  // WithOUT extension methods.
  print(int.parse('42'));
  print(double.parse('42'));

  // WITH extension methods.
  // #docregion import-and-use
  print('42'.padLeft(5)); // Use a String method.
  // #docregion basic
  print('42'.parseInt()); // Use an extension method.
  // #enddocregion basic, import-and-use
  print('42'.parseDouble());

  // var vs. dynamic.
  // #docregion var
  var v = '2';
  print(v.parseInt()); // Output: 2
  // #enddocregion var

  // #docregion dynamic
  dynamic d = '2';
  // #enddocregion dynamic

  // make refresh-code-excerpts.sh happy
  if (false) {
    // #docregion dynamic
    // print(d.parseInt()); // Runtime exception: NoSuchMethodError
    // #enddocregion dynamic
  }
  print(d); // Avoid unused_local_variable hint.
}
