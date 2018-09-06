// #docregion
import 'dart:async' show Future;
import 'dart:io';

Future<void> main() async {
  final semicolon = ';'.codeUnitAt(0);
  var result = <int>[];

  final script = File(Platform.script.toFilePath());
  RandomAccessFile file = await script.open(mode: FileMode.read);

  // Deal with each byte.
  while (true) {
    final byte = await file.readByte();
    result.add(byte);
    if (byte == semicolon) {
      print(String.fromCharCodes(result));
      await file.close();
      break;
    }
  }
}
