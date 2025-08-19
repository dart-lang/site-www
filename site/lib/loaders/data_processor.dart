import 'dart:convert';
import 'dart:io' show FileSystemException, Process;

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as path;

final class DataProcessor implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    final pageLoader = page.loader;
    if (pageLoader is FilesystemLoader) {
      final sourcePath = path.canonicalize(
        path.join(pageLoader.directory, page.path),
      );

      final inputPath = path.relative(sourcePath, from: '..');
      page.apply(
        data: {
          'page': {
            'date': ?_lastModifiedDateForPath(inputPath),
            'inputPath': inputPath,
          },
        },
      );
    }
  }
}

String? _lastModifiedDateForPath(String inputPath) =>
    _lastModifiedPerPath[inputPath]?.formatted;

final Map<String, DateTime> _lastModifiedPerPath = () {
  final fileLastModified = <String, DateTime>{};

  try {
    final output =
        Process.runSync('git', [
              'log',
              '--name-only',
              '--format=commit-date:%cI',
              '--',
              '../src/content',
            ]).stdout
            as String;

    final lines = const LineSplitter().convert(output);
    DateTime? currentCommitDate;
    for (final line in lines) {
      // Check if the line is a commit date line.
      if (line.split('commit-date:') case [_, final dateString]) {
        // Extract the date string and try to parse it.
        currentCommitDate = DateTime.tryParse(dateString);
      } else if (line.isNotEmpty) {
        // If it's a non-empty line and a date is set, it's a file path.
        if (currentCommitDate case final lastModifiedTime?) {
          // Only set the last modified time for this path
          // if we haven't already stored a later modified time.
          fileLastModified.putIfAbsent(
            line,
            () => lastModifiedTime,
          );
        }
      }
    }
  } on FileSystemException catch (_) {
    // Ignore and fall through to return an empty list.
    // We just won't render the last updated time.
  }

  return fileLastModified;
}();

extension on DateTime {
  String get formatted => '$year-$month-$day';
}
