// BEGIN(io_process)
import 'dart:io';

main() async {
  // List all files in the current directory,
  // in UNIX-like operating systems.
  ProcessResult results = await Process.run('ls', ['-l']);
  print(results.stdout);
}
// END(io_process)
