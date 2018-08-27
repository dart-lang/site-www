// BEGIN(io_random_access)
import 'dart:io';

main() async {
  var semicolon = ';'.codeUnitAt(0);
  var result = <int>[];

  File script = File(Platform.script.toFilePath());
  RandomAccessFile file = await script.open(mode: FileMode.read);

  // Callback to deal with each byte.
  onByte(int byte) async {
    result.add(byte);
    if (byte == semicolon) {
      print(String.fromCharCodes(result));
      file.close();
    } else {
      onByte(await file.readByte());
    }
  }

  onByte(await file.readByte());
}
// END(io_random_access)
