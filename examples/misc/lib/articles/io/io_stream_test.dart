// #docregion
import 'dart:io';

Future<void> main() async {
  final result = <int>[];

  Stream<List<int>> stream = File(Platform.script.toFilePath()).openRead();
  final semicolon = ';'.codeUnitAt(0);

  await for (final data in stream) {
    for (int i = 0; i < data.length; i++) {
      result.add(data[i]);
      if (data[i] == semicolon) {
        print(String.fromCharCodes(result));
        return;
      }
    }
  }
}
