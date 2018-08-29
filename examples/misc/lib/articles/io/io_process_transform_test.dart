// #docregion
import 'dart:io';
import 'dart:convert';

main() async {
  Process process = await Process.start('ls', ['-l']);
  var lineStream =
      process.stdout.transform(Utf8Decoder()).transform(LineSplitter());
  await for (var line in lineStream) {
    print(line);
  }

  await process.stderr.drain();
  print('exit code: ${await process.exitCode}');
}
