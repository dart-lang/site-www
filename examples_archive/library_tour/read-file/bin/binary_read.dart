import 'dart:async';
import 'dart:io';

Future main() async {
  var config = new File('config.txt');

  var contents = await config.readAsBytes();
  print('The entire file is ${contents.length} bytes long');
}
