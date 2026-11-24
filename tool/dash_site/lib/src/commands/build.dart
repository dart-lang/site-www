// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
  Future<int> run() =>
      buildSite(productionRelease: argResults.get<bool>(_releaseFlag, false));
}

/// Starts the Jaspr site build process.
Future<Process> startSiteBuildProcess({
  bool productionRelease = false,
  String? rootDirectory,
}) async {
  installJasprCliIfNecessary();

  final baseDirectory = rootDirectory ?? repositoryRoot;
  final siteDirectory = path.join(baseDirectory, 'site');

  return await Process.start(
    Platform.resolvedExecutable,
    [
      'pub',
      'global',
      'run',
      'jaspr_cli:jaspr',
      'build',
      // Use build_web_compiler options specified in build.yaml instead of
      // those specified by jaspr_cli.
      '--no-managed-build-options',
      '--sitemap-domain=https://dart.dev',
      // Exclude secondary Markdown, plain-text, XML, and JSON outputs.
      r'--sitemap-exclude=\.(md|txt|xml|json)$',
      '--dart-define=PRODUCTION=$productionRelease',
    ],
    workingDirectory: siteDirectory,
    mode: ProcessStartMode.inheritStdio,
  );
}

Future<int> buildSite({
  bool productionRelease = false,
  String? rootDirectory,
}) async {
  final Process process;
  try {
    process = await startSiteBuildProcess(
      productionRelease: productionRelease,
      rootDirectory: rootDirectory,
    );
  } on ProcessException catch (e) {
    return e.errorCode;
  }

  final baseDirectory = rootDirectory ?? repositoryRoot;
  final processExitCode = await process.exitCode;
  if (processExitCode != 0) {
    return processExitCode;
  }

  final originalOutputDirectoryPath = path.join(
    baseDirectory,
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

  // Copy the entire site output to the _site directory.
  final siteOut = path.join(baseDirectory, '_site');
  io.copyPathSync(originalOutputDirectoryPath, siteOut);

  _move404File(siteOut);

  return processExitCode;
}

/// Moves the 404 file to the location expected by Firebase hosting.
void _move404File([String? targetDirectory]) {
  final siteOut = targetDirectory ?? siteOutputDirectoryPath;
  final initial404Directory = path.join(siteOut, '404');
  final original404File = File(path.join(initial404Directory, 'index.html'));
  if (original404File.existsSync()) {
    // If the 404 is in its own directory,
    // copy the 404.html file to the root of the output directory.
    original404File.copySync(path.join(siteOut, '404.html'));
    Directory(initial404Directory).deleteSync(recursive: true);
  }
}
