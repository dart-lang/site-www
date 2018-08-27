// BEGIN(io_file_system)
import 'dart:io';
import 'dart:async';
import 'dart:convert';

main() async {
  var file = new File(Platform.script.toFilePath());
  print("${await (file.readAsString(encoding: ASCII))}");
}
// END(io_file_system)
