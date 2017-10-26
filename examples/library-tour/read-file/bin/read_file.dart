import 'dart:io';
import 'dart:convert';
import 'dart:async';

void readFileStreamApi() {
  var config = new File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  inputStream.transform(UTF8.decoder).transform(new LineSplitter()).listen(
      (String line) {
    print('Got ${line.length} characters from stream');
  }, onDone: () {
    print('file is now closed');
  }, onError: (e) {
    print(e);
  });
}

Future readFileAwaitFor() async {
  var config = new File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream.transform(UTF8.decoder).transform(new LineSplitter());
  try {
    await for (var line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}

Future main() async {
  await readFileAwaitFor();
  print('----------');
  readFileStreamApi();
}
