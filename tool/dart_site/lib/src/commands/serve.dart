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
      [
        'tsx',
        'node_modules/@11ty/eleventy/cmd.cjs',
        '--config=eleventy.config.ts',
        '--serve',
        '--incremental',
        '--port=${Platform.environment['PORT'] ?? 4000}',
      ],
      environment: const {'PRODUCTION': 'false'},
      runInShell: true,
      mode: ProcessStartMode.inheritStdio,
    );

    final processExitCode = await process.exitCode;
    return processExitCode;
  }
}
