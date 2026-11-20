// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io' show Process, ProcessException;

import '../util.dart';

/// Determines the last modified date for a given path
/// in the form `yyyy-mm-dd`.
///
/// The [inputPath] should be relative to the repository root and
/// within the `src` directory, such as `src/data/linter_rules.json`.
///
/// Uses `git log` to get the last modified date from the git history.
/// Returns `null` if no date can be determined.
///
/// In production builds, throws a [StateError] on first use if
/// the full git history isn't available.
///
/// Can only be called on the server, not from the client.
String? lastModifiedDateForPath(String inputPath) =>
    _lastModifiedPerPath[inputPath]?.formatted;

/// The latest commit date of each file in `src`,
/// keyed by its path relative to the repository root.
///
/// Built lazily on first use from a single `git log` of the directory.
/// Empty if git or the repository's history isn't available.
final Map<String, DateTime> _lastModifiedPerPath = () {
  final output = _runGit([
    'log',
    '--name-only',
    '--format=commit-date:%cI',
    '--',
    siteSrcDirectoryPath,
  ]);

  // Production builds publish these dates in the sitemap, so they must
  // come from the full history. Without it, pages would instead report
  // the date of the latest commit or, if no date is found, the build time.
  if (productionBuild && (output == null || !_hasFullGitHistory)) {
    throw StateError(
      'Production builds need the full git history to determine '
      'last-modified dates. Run `git fetch --unshallow` first.',
    );
  }

  final fileLastModified = <String, DateTime>{};
  DateTime? currentCommitDate;
  for (final line in const LineSplitter().convert(output ?? '')) {
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

  return fileLastModified;
}();

/// Whether the full git history of the repository is available.
///
/// This is `false` for shallow clones and
/// if git or the repository can't be found.
bool get _hasFullGitHistory =>
    _runGit(['rev-parse', '--is-shallow-repository'])?.trim() == 'false';

/// Runs `git` with [args] and returns its standard output,
/// or `null` if git is unavailable or the command fails.
String? _runGit(List<String> args) {
  try {
    final result = Process.runSync('git', args);
    return result.exitCode == 0 ? result.stdout as String : null;
  } on ProcessException {
    return null;
  }
}

/// Formats dates for use in page and sitemap data.
extension on DateTime {
  /// This date in `yyyy-mm-dd` format, such as `2026-11-03`.
  ///
  /// Uses this date's own time zone, which is UTC for
  /// dates parsed from strings with a time zone offset.
  String get formatted {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
