// #docregion
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  var file = File(Platform.script.toFilePath());
  print(await (file.readAsString(encoding: ascii)));
}
