// BEGIN(io_process_stdio)
import 'dart:io';

main() async {
  var output = new File('output.txt').openWrite();
  Process process = await Process.start('ls', ['-l']);
  process.stdout.pipe(output);
  process.stderr.drain();
  print('exit code: ${await process.exitCode}');
}
// END(io_process_stdio)
