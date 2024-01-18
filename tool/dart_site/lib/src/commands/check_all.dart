import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils.dart';

final class CheckAllCommand extends Command<int> {
  @override
  String get description => 'Run all site tests and verification.';

  @override
  String get name => 'check-all';

  @override
  Future<int> run() async {
    const verificationTasks = [
      ['format-dart', '--check'],
      ['analyze-dart'],
      ['test-dart'],
      ['refresh-excerpts', '--fail-on-update'],
      ['verify-firebase-json'],
    ];

    var seenFailure = false;

    for (final task in verificationTasks) {
      groupStart(task.first);
      final process = await Process.start(
        Platform.executable,
        ['run', 'dart_site', ...task],
      );
      await stdout.addStream(process.stdout);
      await stderr.addStream(process.stderr);
      final processExitCode = await process.exitCode;
      if (processExitCode != 0) {
        seenFailure = true;
      }
      groupEnd();
    }

    return seenFailure ? 1 : 0;
  }
}
