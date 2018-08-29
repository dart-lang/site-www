// #docregion
import 'dart:async' show Future;
import 'dart:io';

Future<void> main() async {
  var output = File('output.txt').openWrite();
  Process process = await Process.start('ls', ['-l']);

  // Wait for the process to finish; get the exit code.
  final exitCode = (await Future.wait([
    process.stdout.pipe(output), // Send stdout to file
    process.stderr.drain(),
    process.exitCode
  ]))[2];

  print('exit code: $exitCode');
}
