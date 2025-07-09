import 'dart:io' show File, Process;

import 'package:collection/collection.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as path;

import '../lints.dart';

final class DataProcessor implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    final pageData = page.data.page;

    if (pageData['processLints'] == true) {
      final lintRules = loadLints(page.data['linter_rules']);

      final filteredLints = lintRules
          .where(
            (lint) =>
                lint.sinceDartSdk != 'Unreleased' &&
                !lint.sinceDartSdk.contains('wip') &&
                lint.state != 'removed' &&
                lint.state != 'internal',
          )
          .sortedBy((lint) => lint.name);

      page.apply(data: {'lintsToShow': filteredLints});
    }

    final pageLoader = page.loader;
    if (pageLoader is FilesystemLoader) {
      final sourcePath = path.canonicalize(
        path.join(pageLoader.directory, page.path),
      );
      final pageFile = File(sourcePath);
      if (await pageFile.exists()) {
        final lastModified =
            await _lastModifiedWithGit(sourcePath) ??
            await pageFile.lastModified();
        page.apply(
          data: {
            'page': {
              'date': lastModified.formatted,
              'inputPath': path.relative(sourcePath, from: '..'),
            },
          },
        );
      }
    }
  }
}

Future<DateTime?> _lastModifiedWithGit(String filePath) async {
  try {
    final processResult = await Process.run(
      'git',
      ['log', '-1', '--pretty=format:%ci', '--', filePath],
    );

    if (processResult.exitCode != 0) {
      return null;
    }

    final commitDateString = (processResult.stdout as String?)?.trim();
    if (commitDateString == null || commitDateString.isEmpty) {
      return null;
    }

    return DateTime.tryParse(commitDateString);
  } catch (_) {
    return null;
  }
}

extension on DateTime {
  String get formatted => '$year-$month-$day';
}
