// BEGIN(io_stream)
import 'dart:io';
import 'dart:async';

main() async {
  var result = <int>[];

  Stream<List<int>> stream = File(Platform.script.toFilePath()).openRead();
  int semicolon = ';'.codeUnitAt(0);

  await for (var data in stream) {
    for (int i = 0; i < data.length; i++) {
      result.add(data[i]);
      if (data[i] == semicolon) {
        print(String.fromCharCodes(result));
        return;
      }
    }
  }
}
// END(io_stream)
