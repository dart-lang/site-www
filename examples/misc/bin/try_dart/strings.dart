// ignore: type_annotate_public_apis
main() {
  print('a single quoted string');
  print("a double quoted string");

  // Strings can be combined with the + operator.
  print("cat" + "dog");

  // Triple quotes define a multi-line string.
  print('''triple quoted strings
are for multiple lines''');

  // Dart supports string interpolation.
  var pi = 3.14;
  print('pi is $pi');
  print('tau is ${2 * pi}');
}
