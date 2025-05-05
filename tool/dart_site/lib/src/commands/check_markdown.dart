// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import '../utils.dart';

final class CheckMarkdownCommand extends Command<int> {
  @override
  String get description =>
      'Scan Markdown files for any instances of known issues.';

  @override
  String get name => 'check-markdown';

  @override
  List<String> get aliases => ['check-md'];

  @override
  Future<int> run() async {
    print('Checking for problems in Markdown files...');

    try {
      print('\nChecking for merge conflict remnants...');
      final mergeConflictRemnants = _findMergeConflictRemnants(
        path.join(repositoryRoot, 'src'),
        extensionsToConsider: {'.md'},
      );
      if (mergeConflictRemnants.isNotEmpty) {
        stderr.writeln(
          'Found merge conflict remnants in the following files:\n',
        );
        for (final filePath in mergeConflictRemnants) {
          stderr.writeln(' - $filePath');
        }
        return 1;
      }
      print('No merge conflict remnants found.\n');

      print('No problems found in Markdown files.');
      return 0;
    } catch (e, stackTrace) {
      stderr.writeln('An unexpected error occurred:');
      stderr.writeln(e);
      stderr.writeln(stackTrace);
      return 1;
    }
  }
}

List<String> _findMergeConflictRemnants(
  String directoryPath, {
  Set<String> extensionsToConsider = const {'.md'},
}) {
  final directory = Directory(directoryPath);
  final filesWithConflictRemnants = <String>[];

  if (!directory.existsSync()) {
    throw ArgumentError('The provided path is not a directory: $directoryPath');
  }

  final files =
      directory.listSync(recursive: true, followLinks: false).whereType<File>();

  for (final file in files) {
    // If the file doesn't have one of the specified extensions, skip it.
    if (!extensionsToConsider.contains(path.extension(file.path))) continue;

    final content = file.readAsStringSync();

    if (content.contains('<<<<<<<') ||
        content.contains('\n=======\n') ||
        content.contains('>>>>>>>')) {
      filesWithConflictRemnants.add(file.path);
    }
  }

  return filesWithConflictRemnants;
}
