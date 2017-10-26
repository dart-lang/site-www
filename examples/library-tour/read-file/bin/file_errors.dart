import 'dart:io';
import 'dart:async';

Future main() async {
  var config = new File('config.txt');
  try {
    var contents = await config.readAsString();
    print(contents);
  } catch (e) {
    print(e);
  }
}
