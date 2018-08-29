// #docregion
import 'dart:io';

main() async {
  var semicolon = ';'.codeUnitAt(0);
  var result = <int>[];

  File script = File(Platform.script.toFilePath());
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
