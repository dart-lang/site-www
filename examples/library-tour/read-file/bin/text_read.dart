import 'dart:async';
import 'dart:io';

Future main() async {
  var config = new File('config.txt');
  var contents;

  // Put the whole file in a single string.
  contents = await config.readAsString();
  print('The entire file is ${contents.length} characters long.');

  // Put each line of the file into its own string.
  contents = await config.readAsLines();
  print('The entire file is ${contents.length} lines long.');
}
