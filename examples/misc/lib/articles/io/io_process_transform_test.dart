// #docregion
import 'dart:convert';
import 'dart:io';

void main() async {
  final process = await Process.start('ls', ['-l']);
  final lineStream = process.stdout
      .transform(const Utf8Decoder())
      .transform(const LineSplitter());

  await for (final line in lineStream) {
    print(line);
  }

  await process.stderr.drain();
  print('exit code: ${await process.exitCode}');
}
