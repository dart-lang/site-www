// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import '../utils.dart';

final class TestDartCommand extends Command<int> {
  static const String _verboseFlag = 'verbose';

  TestDartCommand() {
    argParser.addFlag(
      _verboseFlag,
      defaultsTo: false,
      help: 'Show verbose logging.',
    );
  }

  @override
  String get description => 'Run tests on the site infra and examples.';

  @override
  String get name => 'test-dart';

  @override
  Future<int> run() async => _testDart(
        verboseLogging: argResults.get<bool>(_verboseFlag, false),
      );
}

int _testDart({
  bool verboseLogging = false,
}) {
  final directoriesToTest = [
    path.join('tool', 'dart_site'),
    ...dartProjectExampleDirectories,
  ];

  print('Testing code...');

  for (final directory in directoriesToTest) {
    if (verboseLogging) {
      print('Testing code in $directory...');
    }

    if (runPubGetIfNecessary(directory) case final pubGetResult
        when pubGetResult != 0) {
      return pubGetResult;
    }

    final dartTestOutput = Process.runSync(
      Platform.executable,
      const [
        'test',
        '--reporter',
        'expanded', // Non-animated expanded output looks better in CI and logs.
      ],
      workingDirectory: directory,
    );

    if (dartTestOutput.exitCode != 0) {
      final normalOutput = dartTestOutput.stdout.toString();
      final errorOutput = dartTestOutput.stderr.toString();

      // It's ok if the test directory is not found.
      if (!errorOutput.contains('No test') &&
          !normalOutput.contains('Could not find package `test`') &&
          !normalOutput.contains('No tests were')) {
        stderr.write(normalOutput);
        stderr.writeln('Error: Tests in $directory failed:');
        stderr.write(errorOutput);
        return 1;
      }

      if (verboseLogging) {
        print('No tests found or ran in $directory.');
      }
    } else {
      if (verboseLogging) {
        print('All tests passed in $directory.');
      }
    }
  }

  print('All tests passed successfully!');

  return 0;
}
