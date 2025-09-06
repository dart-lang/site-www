// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fbh_front_matter/fbh_front_matter.dart' as front_matter;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../utils.dart';

final class FreshnessCommand extends Command<int> {
  static const String _includeMissingFlag = 'include-missing';
  static const String _cutoffDaysOption = 'cutoff';

  FreshnessCommand() {
    argParser.addFlag(
      _includeMissingFlag,
      defaultsTo: true,
      help: 'Whether to output files that are missing lastVerified dates.',
    );
    argParser.addOption(
      _cutoffDaysOption,
      help:
          'The cut off amount of days since lastVerified date '
          'to consider inclusion in output.',
    );
  }

  @override
  String get description => 'Check freshness of the docs on the website.';

  @override
  String get name => 'freshness';

  @override
  Future<int> run() async => determineFreshness(
    includeMissing: argResults.get<bool>(_includeMissingFlag, true),
    cutOffDays: int.tryParse(argResults.get<String>(_cutoffDaysOption, '')),
  );
}

int determineFreshness({bool includeMissing = true, int? cutOffDays}) {
  // Directories to check for content.
  final directoryPathsToCheck = [path.join('src', 'content')];

  const extensionsToConsider = {'.md', '.html', '.liquid'};

  final currentDate = DateTime.now();
  final results = FreshnessResults._();
  final initialCutoff = Duration(days: cutOffDays ?? _cutoffDays.first.days);

  for (final directory in directoryPathsToCheck.map(Directory.new)) {
    final filesToCheck = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) => extensionsToConsider.contains(path.extension(file.path)),
        )
        .where(
          (file) => !path.basenameWithoutExtension(file.path).startsWith('_'),
        )
        .where((file) => path.basenameWithoutExtension(file.path).isNotEmpty)
        .toList(growable: false);

    for (final file in filesToCheck) {
      final filePath = path.relative(file.path, from: directory.path);
      try {
        final fileContents = file.readAsStringSync();
        final frontMatter = front_matter.parse(fileContents);
        if (frontMatter.data['skipFreshness'] case final skipFreshness?
            when skipFreshness == true || skipFreshness == 'true') {
          continue;
        }

        if (frontMatter.data.containsKey('lastVerified')) {
          final lastVerifiedRaw = frontMatter.data['lastVerified'];
          if (lastVerifiedRaw case final String lastVerifiedString?) {
            final lastVerified = DateTime.tryParse(lastVerifiedString);
            if (lastVerified != null) {
              final difference = currentDate.difference(lastVerified);
              if (difference > initialCutoff) {
                results._addStale(filePath, lastVerified: lastVerified);
              }
            } else {
              results._addMisformatted(
                filePath,
                misformattedDate: lastVerifiedString,
              );
            }
          } else {
            results._addMisformatted(
              filePath,
              misformattedDate: '$lastVerifiedRaw',
            );
          }
        } else {
          results._addMissingVerified(filePath);
        }
      } catch (e) {
        results._addError(filePath, error: '$e');
      }
    }
  }

  final errorOutput = results.errorOutput();
  final staleOutput = results.staleOutput(includeMissing: includeMissing);

  print(errorOutput);
  print(staleOutput);

  return 0;
}

final List<({int days, String icon})> _cutoffDays = [
  (days: 270, icon: '🟨'),
  (days: 540, icon: '🟧'),
  (days: 810, icon: '🟥'),
];

final DateFormat _dateFormat = DateFormat('y-MM-dd');

final class FreshnessResults {
  FreshnessResults._();

  final List<StaleFile> _staleFiles = [];
  final List<MissingVerifiedDateFile> _missingVerifiedDateFiles = [];

  final List<MisformattedDateFile> _misformattedDateFiles = [];
  final List<ErrorFile> _errorFiles = [];

  void _addStale(String path, {required DateTime lastVerified}) {
    _staleFiles.add(StaleFile(path, lastVerified: lastVerified));
  }

  void _addMissingVerified(String path) {
    _missingVerifiedDateFiles.add(MissingVerifiedDateFile(path));
  }

  void _addMisformatted(String path, {required String misformattedDate}) {
    _misformattedDateFiles.add(
      MisformattedDateFile(path, misformattedDate: misformattedDate),
    );
  }

  void _addError(String path, {required String error}) {
    _errorFiles.add(ErrorFile(path, error: error));
  }

  String staleOutput({bool includeMissing = true}) {
    _staleFiles.sort((a, b) => a.lastVerified.compareTo(b.lastVerified));

    final buffer = StringBuffer();

    if (includeMissing && _missingVerifiedDateFiles.isNotEmpty) {
      _missingVerifiedDateFiles.sortByPath();
      buffer.writeln('\n====== Files with missing lastVerified dates ======\n');
      for (final missingFile in _missingVerifiedDateFiles) {
        buffer.write('❓   ');
        buffer.write('missing-date   ');
        buffer.writeln(missingFile.path);
      }
    }

    if (_staleFiles.isNotEmpty) {
      buffer.writeln('\n====== Files with stale lastVerified dates ======\n');
      final currentDate = DateTime.now();
      for (final staleFile in _staleFiles) {
        final dayDifference = currentDate
            .difference(staleFile.lastVerified)
            .inDays;
        var outputIcon = '🟩';
        for (final (:days, :icon) in _cutoffDays.reversed) {
          if (dayDifference < days) continue;

          outputIcon = icon;

          if (dayDifference >= days) break;
        }

        buffer.write(outputIcon);
        buffer.write('    ');
        buffer.write(_dateFormat.format(staleFile.lastVerified));
        buffer.write('    ');
        buffer.writeln(staleFile.path);
      }
    }

    return buffer.toString();
  }

  String errorOutput() {
    final buffer = StringBuffer();

    if (_errorFiles.isNotEmpty) {
      _errorFiles.sortByPath();
      buffer.writeln('\n====== Files with parsing or other errors ======\n');
      for (final errorFile in _errorFiles) {
        buffer.write('‼️   ');
        buffer.write('file-with-error');
        buffer.write('   ');
        buffer.writeln(errorFile.path);
        buffer.write('       ');
        buffer.writeln(errorFile.error);
      }
    }

    if (_misformattedDateFiles.isNotEmpty) {
      _misformattedDateFiles.sortByPath();
      buffer.writeln(
        '\n====== Files with misformatted lastVerified dates ======\n',
      );
      for (final misformattedFile in _misformattedDateFiles) {
        buffer.write('❗   ');
        buffer.write(misformattedFile.misformattedDate);
        buffer.write('   ');
        buffer.writeln(misformattedFile.path);
      }
    }

    return buffer.toString();
  }
}

extension on List<FileOfInterest> {
  void sortByPath() {
    sort((a, b) => a.path.compareTo(b.path));
  }
}

sealed class FileOfInterest {
  final String path;

  FileOfInterest(this.path);
}

final class MisformattedDateFile extends FileOfInterest {
  final String misformattedDate;

  MisformattedDateFile(super.path, {required this.misformattedDate});
}

final class StaleFile extends FileOfInterest {
  final DateTime lastVerified;

  StaleFile(super.path, {required this.lastVerified});
}

final class MissingVerifiedDateFile extends FileOfInterest {
  MissingVerifiedDateFile(super.path);
}

final class ErrorFile extends FileOfInterest {
  final String error;

  ErrorFile(super.path, {required this.error});
}
