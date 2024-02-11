import 'dart:io';

import 'package:args/command_runner.dart';

import '../utils.dart';

final class BuildSiteCommand extends Command<int> {
  static const String _releaseFlag = 'release';

  BuildSiteCommand() {
    argParser.addFlag(
      _releaseFlag,
      defaultsTo: false,
      help: 'Build a release build for dart.dev. Optimizes site resources.',
    );
  }

  @override
  String get description => 'Build the site.';

  @override
  String get name => 'build';

  @override
  Future<int> run() async {
    final productionRelease = argResults.get<bool>(_releaseFlag, false);

    final process = await Process.start(
      'npx',
      const ['eleventy'],
      environment: {
        'PRODUCTION': '$productionRelease',
      },
    );

    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);

    final processExitCode = await process.exitCode;
    return processExitCode;
  }
}
