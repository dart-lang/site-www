// BEGIN(io_file_system)
import 'dart:io';
import 'dart:async';
import 'dart:convert';

main() async {
  var file = File(Platform.script.toFilePath());
  print("${await (file.readAsString(encoding: ascii))}");
}
// END(io_file_system)
