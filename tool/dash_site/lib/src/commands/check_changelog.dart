// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../utils.dart';

/// Validates `src/data/changelog.yml` against schema, ordering, release-date,
/// duplicate-entry, and Markdown reference link invariants.
final class CheckChangelogCommand extends Command<int> {
  static const Set<String> validAreas = {
    'SDK',
    'Language',
    'Libraries',
    'Tools',
    'Dart Runtime',
    'Docs',
  };

  static const Set<String> validTags = {
    'new',
    'breaking',
    'fixed',
    'changed',
    'experimental',
    'versioned',
    'deprecated',
    'removed',
  };

  static final RegExp _isoDatePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  static final RegExp _versionXyPattern = RegExp(r'^\d+\.\d+$');
  static final RegExp _codeBlockPattern = RegExp(
    r'<pre\b[^>]*>.*?</pre>',
    dotAll: true,
    caseSensitive: false,
  );
  static final RegExp _inlineCodePattern = RegExp(
    r'<code\b[^>]*>.*?</code>',
    dotAll: true,
    caseSensitive: false,
  );
  static final RegExp _unresolvedRefLinkPattern = RegExp(
    r'\[[^\[\]]+\]\[[^\[\]]*\]',
  );
  static final RegExp _whitespacePattern = RegExp(r'\s+');

  CheckChangelogCommand() {
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'Path to the changelog YAML file to validate.',
    );
  }

  @override
  String get description =>
      'Validate src/data/changelog.yml schema, SemVer ordering, release '
      'dates, duplicates, and Markdown reference links.';

  @override
  String get name => 'check-changelog';

  @override
  Future<int> run() async {
    final filePath =
        argResults?['file'] as String? ??
        path.join(repositoryRoot, 'src', 'data', 'changelog.yml');
    final file = File(filePath);
    if (!file.existsSync()) {
      stderr.writeln('Error: Changelog file not found at $filePath.');
      return 1;
    }

    print('Validating changelog data at $filePath...');
    final errors = validateChangelogYaml(file.readAsStringSync());
    if (errors.isNotEmpty) {
      stderr.writeln('Found ${errors.length} changelog validation error(s):\n');
      for (final error in errors) {
        stderr.writeln(' - $error');
      }
      return 1;
    }

    print('Changelog data is valid.');
    return 0;
  }

  /// Validates [yamlContent] and returns a list of human-readable error
  /// messages (empty when valid).
  static List<String> validateChangelogYaml(String yamlContent) {
    final errors = <String>[];

    final Object? parsed;
    try {
      parsed = loadYaml(yamlContent);
    } on YamlException catch (e) {
      return ['Invalid YAML syntax: ${e.message}'];
    }

    if (parsed is! YamlList || parsed.isEmpty) {
      return ['Changelog YAML must be a non-empty list of entries.'];
    }

    Version? previousVersion;
    String? previousVersionRaw;
    final dateByVersion = <String, String>{};
    final reportedDateConflicts = <String>{};
    final seenFingerprints = <String, int>{};

    for (var i = 0; i < parsed.length; i++) {
      final entryNum = i + 1;
      final item = parsed[i];
      if (item is! YamlMap) {
        errors.add('Entry #$entryNum must be a YAML map.');
        continue;
      }

      // SITE-CHANGELOG-01: Required non-empty fields & valid SemVer.
      final versionRaw = item['version']?.toString().trim() ?? '';
      Version? version;
      if (versionRaw.isEmpty) {
        errors.add('Entry #$entryNum is missing required field "version".');
      } else {
        version = _tryParseVersion(versionRaw);
        if (version == null) {
          errors.add(
            'Entry #$entryNum has invalid SemVer version "$versionRaw".',
          );
        }
      }

      final releaseDate = item['releaseDate']?.toString().trim() ?? '';
      if (releaseDate.isEmpty) {
        errors.add(
          'Entry #$entryNum ($versionRaw) is missing required field '
          '"releaseDate".',
        );
      } else if (!_isValidIsoDate(releaseDate)) {
        errors.add(
          'Entry #$entryNum ($versionRaw) has invalid releaseDate '
          '"$releaseDate" (expected concrete YYYY-MM-DD date).',
        );
      }

      // SITE-CHANGELOG-02: Strict area and tags enum validation.
      final area = item['area']?.toString().trim() ?? '';
      if (area.isEmpty) {
        errors.add(
          'Entry #$entryNum ($versionRaw) is missing required field "area".',
        );
      } else if (!validAreas.contains(area)) {
        errors.add(
          'Entry #$entryNum ($versionRaw) has invalid area "$area". '
          'Expected one of: ${validAreas.join(', ')}.',
        );
      }

      final subArea = item['subArea']?.toString().trim();

      final description = item['description']?.toString() ?? '';
      if (description.trim().isEmpty) {
        errors.add(
          'Entry #$entryNum ($versionRaw) is missing required field '
          '"description".',
        );
      }

      final rawTags = item['tags'];
      if (rawTags is! YamlList || rawTags.isEmpty) {
        errors.add(
          'Entry #$entryNum ($versionRaw) must define a non-empty "tags" list.',
        );
      } else {
        final seenTags = <String>{};
        for (final rawTag in rawTags) {
          final tag = rawTag?.toString().trim() ?? '';
          if (!validTags.contains(tag)) {
            errors.add(
              'Entry #$entryNum ($versionRaw) has unknown tag "$tag". '
              'Expected one of: ${validTags.join(', ')}.',
            );
          } else if (!seenTags.add(tag)) {
            errors.add(
              'Entry #$entryNum ($versionRaw) lists duplicate tag "$tag".',
            );
          }
        }
      }

      final rawLink = item['link']?.toString().trim();
      if (rawLink != null &&
          rawLink.isNotEmpty &&
          !rawLink.startsWith('https://') &&
          !rawLink.startsWith('http://') &&
          !rawLink.startsWith('/')) {
        errors.add(
          'Entry #$entryNum ($versionRaw) has invalid link "$rawLink" '
          '(expected an absolute https:// URL or site-relative /path).',
        );
      }

      // SITE-CHANGELOG-03: Monotonic SemVer ordering & intra-version dates.
      if (version != null) {
        if (previousVersion != null && previousVersion < version) {
          errors.add(
            'Entry #$entryNum ($versionRaw) breaks monotonic descending '
            'SemVer ordering after $previousVersionRaw.',
          );
        }
        previousVersion = version;
        previousVersionRaw = versionRaw;

        if (_isValidIsoDate(releaseDate)) {
          final canonicalVersion = version.toString();
          final existingDate = dateByVersion[canonicalVersion];
          if (existingDate == null) {
            dateByVersion[canonicalVersion] = releaseDate;
          } else if (existingDate != releaseDate) {
            final conflictKey = '$canonicalVersion:$releaseDate';
            if (reportedDateConflicts.add(conflictKey)) {
              errors.add(
                'Entry #$entryNum ($versionRaw) has conflicting releaseDate '
                '"$releaseDate" (earlier entries for $canonicalVersion use '
                '"$existingDate").',
              );
            }
          }
        }
      }

      // SITE-CHANGELOG-04: Duplicate entry fingerprints & rendered ref links.
      if (version != null && area.isNotEmpty && description.trim().isNotEmpty) {
        final normalizedDescription = description
            .trim()
            .toLowerCase()
            .replaceAll(_whitespacePattern, ' ');
        final fingerprint =
            '${version.toString()}|$area|${subArea ?? ''}|'
            '$normalizedDescription';
        final previousEntry = seenFingerprints[fingerprint];
        if (previousEntry != null) {
          errors.add(
            'Entry #$entryNum ($versionRaw, $area'
            '${subArea != null ? ' / $subArea' : ''}) duplicates entry '
            '#$previousEntry.',
          );
        } else {
          seenFingerprints[fingerprint] = entryNum;
        }
      }

      if (description.trim().isNotEmpty) {
        for (final unresolved in _findUnresolvedMarkdownRefs(description)) {
          errors.add(
            'Entry #$entryNum ($versionRaw, $area'
            '${subArea != null ? ' / $subArea' : ''}) contains unresolved '
            'Markdown reference link "$unresolved" in description.',
          );
        }
      }
      if (subArea != null && subArea.isNotEmpty) {
        for (final unresolved in _findUnresolvedMarkdownRefs(subArea)) {
          errors.add(
            'Entry #$entryNum ($versionRaw, $area) contains unresolved '
            'Markdown reference link "$unresolved" in subArea.',
          );
        }
      }
    }

    return errors;
  }

  static Version? _tryParseVersion(String raw) {
    final normalized = _versionXyPattern.hasMatch(raw) ? '$raw.0' : raw;
    try {
      return Version.parse(normalized);
    } on FormatException {
      return null;
    }
  }

  static bool _isValidIsoDate(String raw) {
    final match = _isoDatePattern.firstMatch(raw);
    if (match == null) return false;
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1 || day > 31) return false;
    final parsed = DateTime.utc(year, month, day);
    return parsed.year == year && parsed.month == month && parsed.day == day;
  }

  /// Renders [markdownText] through `package:markdown` (GFM) and checks for
  /// dangling `[label][ref]` / `[label][]` syntax outside code spans/blocks.
  static List<String> _findUnresolvedMarkdownRefs(String markdownText) {
    final renderedHtml = md.markdownToHtml(
      markdownText,
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
    final withoutCode = renderedHtml
        .replaceAll(_codeBlockPattern, '')
        .replaceAll(_inlineCodePattern, '');
    return [
      for (final match in _unresolvedRefLinkPattern.allMatches(withoutCode))
        match.group(0)!,
    ];
  }
}
