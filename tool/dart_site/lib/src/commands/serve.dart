import 'dart:io';

import 'package:args/command_runner.dart';

final class ServeSiteCommand extends Command<int> {
  @override
  String get description => 'Serve the site locally.';

  @override
  String get name => 'serve';

  @override
  Future<int> run() async {
    final process = await Process.start(
      'npx',
      const ['eleventy', '--serve', '--incremental'],
      environment: const {
        'PRODUCTION': 'false',
      },
      runInShell: true,
      mode: ProcessStartMode.inheritStdio,
    );

    final processExitCode = await process.exitCode;
    return processExitCode;
  }
}
