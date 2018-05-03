import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  var file = new File(args[0]);
  var lines = file
      .openRead()
      .transform(utf8.decoder) //!<br>
      .transform(const LineSplitter());
  await for (var line in lines) {
    if (!line.startsWith('#')) print(line);
  }
}
