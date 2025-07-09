import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/io.dart' as io;
import 'package:path/path.dart' as path;

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
      Platform.resolvedExecutable,
      [
        'run',
        'jaspr_cli:jaspr',
        'build',
        '--sitemap-domain=https://dart.dev',
        '--dart-define=PRODUCTION=$productionRelease',
      ],
      workingDirectory: 'site',
      mode: ProcessStartMode.inheritStdio,
    );

    final processExitCode = await process.exitCode;

    final originalOutputDirectoryPath = path.join(
      repositoryRoot,
      'site',
      'build',
      'jaspr',
    );
    if (!Directory(originalOutputDirectoryPath).existsSync()) {
      stderr.writeln(
        'Error: Jaspr output directory not found at: '
        '$originalOutputDirectoryPath',
      );
      return 1;
    }

    await io.copyPath(originalOutputDirectoryPath, siteOutputDirectoryPath);

    return processExitCode;
  }
}
