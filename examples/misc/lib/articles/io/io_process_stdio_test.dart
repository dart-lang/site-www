// #docregion
import 'dart:io';

void main() async {
  final output = File('output.txt').openWrite();
  Process process = await Process.start('ls', ['-l']);

  // Wait for the process to finish; get the exit code.
  final exitCode = (await Future.wait([
    process.stdout.pipe(output), // Send stdout to file.
    process.stderr.drain(), // Discard stderr.
    process.exitCode
  ]))[2];

  print('exit code: $exitCode');
}
