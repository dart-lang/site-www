// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';

import '../utils.dart';

/// URL to the raw Dart SDK changelog file on GitHub.
final Uri _sdkChangelogUrl = Uri.https(
  'raw.githubusercontent.com',
  'dart-lang/sdk/main/CHANGELOG.md',
);

/// Syncs changelog entries from the Dart SDK repo to the site's changelog file.
final class SyncChangelog extends Command<int> {
  /// Separator used in the changelog YAML file.
  static const String _changelogSeparator =
      '# --------------------------------------------------';

  @override
  String get description =>
      'Sync the changelog from the SDK repo to the site repo.';

  @override
  String get name => 'sync-changelog';

  SyncChangelog() {
    argParser
      ..addOption(
        'version',
        abbr: 'v',
        help: 'The Dart SDK version to sync (such as "3.9.0").',
        mandatory: true,
      )
      ..addFlag(
        'dry-run',
        abbr: 'd',
        help: 'If true, returns the generated content without writing to file.',
        defaultsTo: false,
      );
  }

  @override
  Future<int> run() async {
    final results = argResults!;
    final versionString = results.getOrThrow<String>('version');
    final dryRun = results.getOrThrow<bool>('dry-run');

    final Version version;
    try {
      version = Version.parse(versionString);
    } on FormatException {
      stderr.writeln('Invalid version: "$versionString".');
      return 1;
    }

    if (version.isPreRelease) {
      stderr.writeln('Pre-release versions are not supported: "$version".');
      return 1;
    }

    stdout.writeln('Syncing changelog for version $version...');

    try {
      final response = await http.get(_sdkChangelogUrl);
      if (response.statusCode != 200) {
        stderr.writeln(
          'Failed to fetch SDK changelog: ${response.statusCode}.',
        );
        return 1;
      }

      final patches = _parseChangelog(response.body, version.toString());
      if (patches.isEmpty) {
        stdout.writeln(
          'No entries found for version $version in SDK changelog.',
        );
        return 0;
      }

      final changelogPath = p.join(
        repositoryRoot,
        'src',
        'data',
        'changelog.yml',
      );
      final changelogFile = File(changelogPath);
      if (!await changelogFile.exists()) {
        stderr.writeln('File not found: $changelogPath');
        return 1;
      }

      final newYaml = _generateYamlString(patches);
      if (dryRun) {
        stdout.writeln(
          'Dry run successful. '
          'Found ${patches.length} entries for version $version:',
        );
        stdout.write(newYaml);
        return 0;
      }

      final currentContent = await changelogFile.readAsString();
      final newContent = _applyPatches(currentContent, newYaml);

      await changelogFile.writeAsString(newContent);

      stdout.writeln(
        'Successfully added ${patches.length} entries for '
        'version $version in $changelogPath.',
      );
      return 0;
    } catch (e, st) {
      stderr.writeln('Error executing tool: $e\n$st');
      return 1;
    }
  }

  /// Parses the SDK CHANGELOG.md [markdown] and
  /// extracts entries for the specified [targetVersion].
  static List<_ChangelogEntry> _parseChangelog(
    String markdown,
    String targetVersion,
  ) {
    // TODO: Use a proper Markdown parser instead of
    //  relying on regular expressions.
    final entries = <_ChangelogEntry>[];
    final lines = markdown.split('\n');
    final versionRegExp = RegExp(r'^##\s+(\d+\.\d+\.\d+)');
    final inlineLinkRegExp = RegExp(r'\[.*?\]\((.*?)\)');
    final referenceLinkRegExp = RegExp(r'\[.*?\]:\s+(https?://\S+)');

    // Extracts the first markdown link URL from [text], or returns null.
    String? extractLink(String text) {
      final match =
          inlineLinkRegExp.firstMatch(text) ??
          referenceLinkRegExp.firstMatch(text);
      return match?.group(1);
    }

    String? currentArea;
    String? currentSubArea;
    var inTargetVersion = false;
    final bulletBuffer = StringBuffer();
    String? pendingLink;

    void flushBullet() {
      if (bulletBuffer.isEmpty) return;

      final description = bulletBuffer.toString().trim();
      if (description.isNotEmpty) {
        var link = pendingLink;
        if (link == null) {
          // If no specific link was found, default to the SDK CHANGELOG
          // section anchor. The anchor for version "3.11.0" is "#3110".
          final anchor = targetVersion.replaceAll('.', '');
          link =
              'https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#$anchor';
        }

        entries.add(
          _ChangelogEntry(
            version: targetVersion,
            releaseDate: 'TBD',
            area: currentArea ?? 'SDK',
            subArea: currentSubArea,
            description: description,
            tags: _inferTags(description),
            link: link,
          ),
        );
      }
      bulletBuffer.clear();
      pendingLink = null;
    }

    for (final line in lines) {
      // Check for a version header to determine if
      // we are in the target version section.
      final versionMatch = versionRegExp.firstMatch(line);
      if (versionMatch != null) {
        final version = versionMatch.group(1)!;
        if (version == targetVersion) {
          inTargetVersion = true;
          currentArea = null;
          currentSubArea = null;
          continue;
        } else if (inTargetVersion) {
          flushBullet();
          break;
        }
      }

      if (!inTargetVersion) continue;

      // Detect area ("### ") and sub-area ("#### ") headers.
      if (line.startsWith('### ')) {
        flushBullet();
        currentArea = line.substring(4).trim();
        currentSubArea = null;
        continue;
      }

      if (line.startsWith('#### ')) {
        flushBullet();
        currentSubArea = line.substring(5).trim();
        continue;
      }

      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        // Preserve blank lines within multi-line bullet points.
        if (bulletBuffer.isNotEmpty) {
          bulletBuffer.writeln();
        }
        continue;
      }

      // Check for list items starting with "- ".
      if (trimmedLine.startsWith('- ')) {
        flushBullet();
        final content = trimmedLine.substring(2);
        bulletBuffer.write(content);
        pendingLink ??= extractLink(content);
      } else if (bulletBuffer.isNotEmpty) {
        bulletBuffer.write('\n$trimmedLine');
        pendingLink ??= extractLink(trimmedLine);
      }
    }

    flushBullet();
    return entries;
  }

  /// Inserts [newYaml] after the first separator line in [content].
  static String _applyPatches(String content, String newYaml) {
    if (content.startsWith(_changelogSeparator)) {
      final lines = content.split('\n');
      final buffer = StringBuffer()
        ..writeln(lines.first)
        ..write(newYaml)
        ..write(lines.skip(1).join('\n'));
      return buffer.toString();
    }

    return newYaml + content;
  }

  /// Generates a YAML string from the given changelog [entries].
  static String _generateYamlString(List<_ChangelogEntry> entries) {
    final newYaml = StringBuffer();

    // Returns [value] as a plain scalar if it only contains simple characters,
    // otherwise wraps it in YAML single quotes.
    String yamlQuote(String value) {
      if (RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) return value;
      // In YAML single-quoted scalars, the only escape is '' for a literal '.
      return "'${value.replaceAll("'", "''")}'";
    }

    for (final entry in entries) {
      newYaml
        ..writeln('- version: ${entry.version}')
        ..writeln('  releaseDate: ${entry.releaseDate}')
        ..writeln('  area: ${yamlQuote(entry.area)}');

      if (entry.subArea case final entrySubArea?) {
        newYaml.writeln('  subArea: ${yamlQuote(entrySubArea)}');
      }
      newYaml.writeln('  description: |');
      for (final line in entry.description.split('\n')) {
        newYaml.writeln('    $line');
      }
      if (entry.tags.isNotEmpty) {
        newYaml.writeln('  tags:');
        for (final tag in entry.tags) {
          newYaml.writeln('    - ${tag.yamlName}');
        }
      }
      if (entry.link case final entryLink?) {
        newYaml.writeln('  link: ${yamlQuote(entryLink)}');
      }
      newYaml.writeln(_changelogSeparator);
    }
    return newYaml.toString();
  }

  /// Infers changelog tags from [description] using keyword matching.
  static Set<_ChangelogTag> _inferTags(String description) {
    final lower = description.toLowerCase();
    bool hasWord(String word) => RegExp('\\b$word\\b').hasMatch(lower);

    final tags = {
      for (final tag in _ChangelogTag.values)
        if (tag.words.any(hasWord) || tag.phrases.any(lower.contains)) tag,
    };

    return tags.isEmpty ? const {_ChangelogTag.changed} : tags;
  }
}

/// Types of changes for Dart SDK changelog entries.
///
/// Each tag includes [words] and [phrases] to
/// search for when inferring the tag.
enum _ChangelogTag {
  breaking(
    words: ['breaking'],
    phrases: [
      'breaking change',
      'no longer compile',
      'compile-time error',
      'runtime error',
    ],
  ),
  added(
    yamlName: 'new',
    words: ['added', 'adds', 'introduces', 'introduced', 'initial', 'enable'],
    phrases: ['new feature', 'support for'],
  ),
  fixed(
    words: ['fixed', 'fixes', 'fix', 'bug', 'issue', 'resolves', 'resolved'],
    phrases: [],
  ),
  deprecated(
    words: ['deprecated', 'deprecates', 'deprecation'],
    phrases: ['legacy'],
  ),
  removed(
    words: ['removed', 'removes', 'deleted', 'drop', 'dropped'],
    phrases: ['no longer supported', 'no longer supports'],
  ),
  experimental(words: ['experimental', 'experiment', 'preview'], phrases: []),
  changed(words: [], phrases: []);

  const _ChangelogTag({
    String? yamlName,
    required this.words,
    required this.phrases,
  }) : _yamlName = yamlName;

  /// The name written to the YAML output.
  String get yamlName => _yamlName ?? name;
  final String? _yamlName;

  /// Words that trigger this tag if contained.
  final List<String> words;

  /// Phrases that trigger this tag if contained.
  final List<String> phrases;
}

/// A single entry from the Dart SDK changelog.
class _ChangelogEntry {
  final String version;
  final String releaseDate;
  final String area;
  final String? subArea;
  final String description;
  final Set<_ChangelogTag> tags;
  final String? link;

  _ChangelogEntry({
    required this.version,
    required this.releaseDate,
    required this.area,
    this.subArea,
    required this.description,
    required this.tags,
    this.link,
  });
}
