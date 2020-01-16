// #docregion
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final process = await Process.start('ls', ['-l']);
  var lineStream =
      process.stdout.transform(Utf8Decoder()).transform(LineSplitter());
  await for (var line in lineStream) {
    print(line);
  }

  await process.stderr.drain();
  print('exit code: ${await process.exitCode}');
}
