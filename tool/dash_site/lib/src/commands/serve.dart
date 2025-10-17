import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils.dart';

final class ServeSiteCommand extends Command<int> {
  @override
  String get description => 'Serve the site locally.';

  @override
  String get name => 'serve';

  ServeSiteCommand() {
    argParser.addFlag('release', defaultsTo: false);
  }

  @override
  Future<int> run() async {
    final release = argResults!.flag('release');
    installJasprCliIfNecessary();

    final process = await Process.start(
      Platform.resolvedExecutable,
      [
        'pub',
        'global',
        'run',
        'jaspr_cli:jaspr',
        'serve',
        '--no-managed-build-options',
        '--dart-define=PRODUCTION=false',
        if (release) '--release',
      ],
      workingDirectory: 'site',
      runInShell: true,
      mode: ProcessStartMode.inheritStdio,
    );

    final processExitCode = await process.exitCode;
    return processExitCode;
  }
}
