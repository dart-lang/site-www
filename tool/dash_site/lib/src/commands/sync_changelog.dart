// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../utils.dart';

/// URL to the raw Dart SDK changelog file on GitHub.
final Uri _sdkChangelogUrl = Uri.https(
  'raw.githubusercontent.com',
  'dart-lang/sdk/main/CHANGELOG.md',
);

/// Result of comparing a release section in `dart-lang/sdk/CHANGELOG.md`
/// against `src/data/changelog.yml` for semantic and issue coverage.
final class ChangelogDriftReport {
  const ChangelogDriftReport({
    required this.targetVersion,
    required this.sdkEntryCount,
    required this.siteEntryCount,
    required this.versionMissing,
    required this.missingIssueUrls,
    required this.missingSections,
  });

  final String targetVersion;
  final int sdkEntryCount;
  final int siteEntryCount;
  final bool versionMissing;
  final List<String> missingIssueUrls;
  final List<String> missingSections;

  bool get hasDrift =>
      versionMissing ||
      missingIssueUrls.isNotEmpty ||
      missingSections.isNotEmpty;
}

/// Syncs changelog entries from the Dart SDK repo to the site's changelog file.
final class SyncChangelog extends Command<int> {
  /// Separator used in the changelog YAML file.
  static const String _changelogSeparator =
      '# --------------------------------------------------';

  static final HtmlUnescape _htmlUnescape = HtmlUnescape();

  static final RegExp _versionHeaderRegExp = RegExp(
    r'^##\s+(\d+\.\d+\.\d+)(?:\s*-\s*(\d{4}-\d{2}-\d{2}))?',
  );
  static final RegExp _fenceRegExp = RegExp(r'^\s*(`{3,}|~{3,})');
  static final RegExp _releaseDateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  static final RegExp _releasedOnTextRegExp = RegExp(
    r'^Released on:\s*(\d{4}-\d{2}-\d{2})',
    caseSensitive: false,
  );
  static final RegExp _githubIssueUrlRegExp = RegExp(
    r'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/(?:issues|pull)/\d+',
    caseSensitive: false,
  );
  static final RegExp _whitespaceRegExp = RegExp(r'\s+');
  static final RegExp _entryStartRegExp = RegExp(r'^- version:\s*(\S+)');

  /// Placeholder written when no release date could be determined.
  ///
  /// The site renders this verbatim in the version header, and
  /// `check-changelog` / `changelog_data_test` reject it, so it must be
  /// replaced before merging.
  static const unknownReleaseDate = 'TBD';

  @override
  String get description =>
      'Sync or verify changelog entries from the Dart SDK repo against '
      'src/data/changelog.yml.';

  @override
  String get name => 'sync-changelog';

  SyncChangelog() {
    argParser
      ..addOption(
        'version',
        abbr: 'v',
        help: 'The Dart SDK version to sync or check (such as "3.9.0").',
        mandatory: true,
      )
      ..addOption(
        'release-date',
        abbr: 'r',
        help:
            'The release date to record, in YYYY-MM-DD format. '
            'Defaults to the "Released on" date in the SDK changelog.',
        valueHelp: 'YYYY-MM-DD',
      )
      ..addFlag(
        'dry-run',
        abbr: 'd',
        help: 'Print the generated YAML without modifying changelog.yml.',
        defaultsTo: false,
      )
      ..addFlag(
        'check',
        abbr: 'c',
        help:
            'Verify that all SDK issues and (area, subArea) sections for '
            '--version are represented in src/data/changelog.yml.',
        defaultsTo: false,
      )
      ..addOption(
        'sdk-changelog',
        help:
            'Optional path to a local SDK CHANGELOG.md file instead of '
            'fetching from GitHub.',
        valueHelp: 'PATH',
      );
  }

  @override
  Future<int> run() async {
    final results = argResults!;
    final versionString = results.getOrThrow<String>('version');
    final dryRun = results.getOrThrow<bool>('dry-run');
    final checkOnly = results.getOrThrow<bool>('check');
    final releaseDate = results['release-date'] as String?;
    final sdkChangelogPath = results['sdk-changelog'] as String?;

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

    if (releaseDate != null && !_releaseDateRegExp.hasMatch(releaseDate)) {
      stderr.writeln(
        'Invalid release date: "$releaseDate". Use YYYY-MM-DD format.',
      );
      return 1;
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

    try {
      final String sdkMarkdown;
      if (sdkChangelogPath != null) {
        final localFile = File(sdkChangelogPath);
        if (!await localFile.exists()) {
          stderr.writeln('SDK changelog file not found: $sdkChangelogPath');
          return 1;
        }
        sdkMarkdown = await localFile.readAsString();
      } else {
        final response = await http.get(_sdkChangelogUrl);
        if (response.statusCode != 200) {
          stderr.writeln(
            'Failed to fetch SDK changelog: ${response.statusCode}.',
          );
          return 1;
        }
        sdkMarkdown = response.body;
      }

      final currentContent = await changelogFile.readAsString();

      if (checkOnly) {
        stdout.writeln(
          'Checking semantic and issue coverage for Dart $version...',
        );
        final report = checkDrift(
          sdkMarkdown: sdkMarkdown,
          siteYaml: currentContent,
          targetVersion: version.toString(),
        );
        if (report.sdkEntryCount == 0) {
          stderr.writeln(
            'No entries found for version $version in SDK CHANGELOG.md.',
          );
          return 1;
        }
        if (!report.hasDrift) {
          stdout.writeln(
            'Dart $version coverage check passed '
            '(${report.siteEntryCount} site entries covering '
            '${report.sdkEntryCount} SDK entries).',
          );
          return 0;
        }

        stderr.writeln('Drift detected for Dart $version:');
        if (report.versionMissing) {
          stderr.writeln(
            ' - Version $version has ${report.sdkEntryCount} SDK entries but '
            'is completely missing from src/data/changelog.yml.',
          );
        }
        if (report.missingSections.isNotEmpty) {
          stderr.writeln(' - Missing (area / subArea) sections:');
          for (final section in report.missingSections) {
            stderr.writeln('     * $section');
          }
        }
        if (report.missingIssueUrls.isNotEmpty) {
          stderr.writeln(' - Unreferenced SDK GitHub issue/PR URLs:');
          for (final issueUrl in report.missingIssueUrls) {
            stderr.writeln('     * $issueUrl');
          }
        }
        return 1;
      }

      stdout.writeln('Syncing changelog for version $version...');

      final parsedEntries = _parseChangelog(
        sdkMarkdown,
        version.toString(),
        releaseDate: releaseDate,
      );
      if (parsedEntries.isEmpty) {
        stdout.writeln(
          'No entries found for version $version in SDK changelog.',
        );
        return 0;
      }

      final resolvedReleaseDate = parsedEntries.first.releaseDate;
      if (resolvedReleaseDate == unknownReleaseDate) {
        stderr.writeln(
          'WARNING: No "Released on" date found for $version in the SDK '
          'changelog, so entries were written with '
          '"releaseDate: $unknownReleaseDate".\n'
          'The site shows this date in the version header, and '
          'check-changelog / changelog_data_test will fail until it is '
          'replaced.\n'
          'Re-run with --release-date=YYYY-MM-DD or edit '
          'src/data/changelog.yml before committing.',
        );
      } else {
        stdout.writeln('Using release date $resolvedReleaseDate.');
      }

      final (:addedEntries, :skippedCount) = _filterNewEntries(
        parsedEntries,
        currentContent,
        version.toString(),
      );

      if (addedEntries.isEmpty) {
        stdout.writeln(
          'All ${parsedEntries.length} entries for version $version are '
          'already present in $changelogPath (skipped $skippedCount).',
        );
        return 0;
      }

      final newYaml = _generateYamlString(addedEntries);
      if (dryRun) {
        stdout.writeln(
          'Dry run successful. '
          'Found ${addedEntries.length} new entries for version $version '
          '(skipped $skippedCount existing):',
        );
        stdout.write(newYaml);
        return 0;
      }

      final newContent = _applyPatches(currentContent, newYaml, version);
      await changelogFile.writeAsString(newContent);

      stdout.writeln(
        'Successfully added ${addedEntries.length} new entries for '
        'version $version in $changelogPath (skipped $skippedCount existing).',
      );
      return 0;
    } catch (e, st) {
      stderr.writeln('Error executing tool: $e\n$st');
      return 1;
    }
  }

  /// Parses [markdown] for [targetVersion] and returns generated YAML.
  ///
  /// If [releaseDate] is provided it's used for every entry; otherwise the
  /// date is read from the section's `**Released on:**` line (or `## X.Y.Z -
  /// YYYY-MM-DD` heading), falling back to [unknownReleaseDate] if absent.
  static String parseAndGenerateYaml(
    String markdown,
    String targetVersion, {
    String? releaseDate,
  }) => _generateYamlString(
    _parseChangelog(markdown, targetVersion, releaseDate: releaseDate),
  );

  /// Idempotently syncs entries for [targetVersion] from [sdkMarkdown] into
  /// [existingYaml], skipping entries already represented by issue URL or
  /// `(area, subArea, normalizedDescription)` fingerprint and inserting new
  /// entries in monotonic descending SemVer order.
  static ({String updatedYaml, int addedCount, int skippedCount}) syncIntoYaml({
    required String sdkMarkdown,
    required String existingYaml,
    required String targetVersion,
    String? releaseDate,
  }) {
    final parsedEntries = _parseChangelog(
      sdkMarkdown,
      targetVersion,
      releaseDate: releaseDate,
    );
    if (parsedEntries.isEmpty) {
      return (updatedYaml: existingYaml, addedCount: 0, skippedCount: 0);
    }

    final (:addedEntries, :skippedCount) = _filterNewEntries(
      parsedEntries,
      existingYaml,
      targetVersion,
    );
    if (addedEntries.isEmpty) {
      return (
        updatedYaml: existingYaml,
        addedCount: 0,
        skippedCount: skippedCount,
      );
    }

    final newYaml = _generateYamlString(addedEntries);
    final updated = _applyPatches(
      existingYaml,
      newYaml,
      Version.parse(targetVersion),
    );
    return (
      updatedYaml: updated,
      addedCount: addedEntries.length,
      skippedCount: skippedCount,
    );
  }

  /// Checks semantic and issue coverage for [targetVersion] between
  /// [sdkMarkdown] and [siteYaml] without requiring identical prose.
  static ChangelogDriftReport checkDrift({
    required String sdkMarkdown,
    required String siteYaml,
    required String targetVersion,
  }) {
    final sdkEntries = _parseChangelog(sdkMarkdown, targetVersion);
    final existingSiteEntries = _loadSiteEntriesForVersion(
      siteYaml,
      targetVersion,
    );

    if (sdkEntries.isEmpty) {
      return ChangelogDriftReport(
        targetVersion: targetVersion,
        sdkEntryCount: 0,
        siteEntryCount: existingSiteEntries.length,
        versionMissing: false,
        missingIssueUrls: const [],
        missingSections: const [],
      );
    }

    final siteIssueUrls = <String>{
      for (final entry in existingSiteEntries) ...entry.issueUrls,
    };
    final siteSections = <String>{
      for (final entry in existingSiteEntries)
        if (entry.subArea != null)
          _normalizedSectionKey(entry.area, entry.subArea!),
    };

    final missingIssueUrls = <String>[];
    final seenMissingIssues = <String>{};
    final missingSections = <String>[];
    final seenMissingSections = <String>{};

    for (final sdkEntry in sdkEntries) {
      for (final issueUrl in sdkEntry.issueUrls) {
        if (!siteIssueUrls.contains(issueUrl) &&
            seenMissingIssues.add(issueUrl)) {
          missingIssueUrls.add(issueUrl);
        }
      }
      if (sdkEntry.subArea case final subArea?) {
        final key = _normalizedSectionKey(sdkEntry.area, subArea);
        if (!siteSections.contains(key) && seenMissingSections.add(key)) {
          missingSections.add('${sdkEntry.area} / $subArea');
        }
      }
    }

    return ChangelogDriftReport(
      targetVersion: targetVersion,
      sdkEntryCount: sdkEntries.length,
      siteEntryCount: existingSiteEntries.length,
      versionMissing: existingSiteEntries.isEmpty,
      missingIssueUrls: missingIssueUrls,
      missingSections: missingSections,
    );
  }

  /// Extracts the raw lines belonging to the `## <targetVersion>` section
  /// (ignoring `##` headings inside fenced code blocks) plus any release date
  /// embedded on the `##` heading itself.
  static ({List<String> lines, String? headerReleaseDate})
  _extractVersionSection(String markdown, String targetVersion) {
    final lines = markdown.split('\n');
    final sectionLines = <String>[];
    String? headerReleaseDate;
    var inTargetVersion = false;
    String? activeFence;

    for (final line in lines) {
      final fenceMatch = _fenceRegExp.firstMatch(line);
      if (fenceMatch != null) {
        final marker = fenceMatch.group(1)!;
        if (activeFence == null) {
          activeFence = marker[0];
        } else if (marker[0] == activeFence) {
          activeFence = null;
        }
      }

      if (activeFence == null) {
        final versionMatch = _versionHeaderRegExp.firstMatch(line);
        if (versionMatch != null) {
          final version = versionMatch.group(1)!;
          if (version == targetVersion) {
            inTargetVersion = true;
            headerReleaseDate = versionMatch.group(2);
            continue;
          } else if (inTargetVersion) {
            break;
          }
        }
      }

      if (inTargetVersion) {
        sectionLines.add(line);
      }
    }

    return (lines: sectionLines, headerReleaseDate: headerReleaseDate);
  }

  /// Parses the SDK CHANGELOG.md [markdown] using `package:markdown` AST and
  /// extracts entries for the specified [targetVersion].
  static List<_ChangelogEntry> _parseChangelog(
    String markdown,
    String targetVersion, {
    String? releaseDate,
  }) {
    final (:lines, :headerReleaseDate) = _extractVersionSection(
      markdown,
      targetVersion,
    );
    if (lines.isEmpty) return const [];

    final document = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );
    final nodes = document.parseLines(lines);

    var resolvedReleaseDate = releaseDate ?? headerReleaseDate;
    if (resolvedReleaseDate == null) {
      for (final node in nodes) {
        if (node is md.Element && node.tag == 'p') {
          final match = _releasedOnTextRegExp.firstMatch(
            node.textContent.trim(),
          );
          if (match != null) {
            resolvedReleaseDate = match.group(1);
            break;
          }
        }
      }
    }
    final finalReleaseDate = resolvedReleaseDate ?? unknownReleaseDate;

    final entries = <_ChangelogEntry>[];
    String? currentArea;
    String? currentSubArea;
    var subAreaHasTopLevelList = false;
    final proseNodes = <md.Node>[];

    void addEntryFromNodes(List<md.Node> entryNodes) {
      final description = _serializeBlocks(entryNodes).trim();
      if (description.isEmpty) return;

      final firstLink = _extractFirstLink(entryNodes);
      final anchor = targetVersion.replaceAll('.', '');
      final link =
          firstLink ??
          'https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#$anchor';

      final issueUrls = {
        ..._extractIssueUrls(description),
        ..._extractIssueUrls(link),
      };

      entries.add(
        _ChangelogEntry(
          version: targetVersion,
          releaseDate: finalReleaseDate,
          area: _resolveArea(currentArea, currentSubArea),
          subArea: currentSubArea,
          description: description,
          tags: _inferTags(description),
          link: link,
          issueUrls: issueUrls,
        ),
      );
    }

    void flushProseSection() {
      if (!subAreaHasTopLevelList &&
          currentSubArea != null &&
          proseNodes.isNotEmpty) {
        addEntryFromNodes(proseNodes);
      }
      proseNodes.clear();
      subAreaHasTopLevelList = false;
    }

    for (final node in nodes) {
      if (node is md.Element) {
        if (node.tag == 'h3') {
          flushProseSection();
          currentArea = _serializeInlineNodes(node.children).trim();
          currentSubArea = null;
          continue;
        }
        if (node.tag == 'h4') {
          flushProseSection();
          currentSubArea = _serializeInlineNodes(node.children).trim();
          continue;
        }
        if (node.tag == 'p' &&
            node.textContent.trim().toLowerCase().startsWith('released on:')) {
          continue;
        }
        if ((node.tag == 'ul' || node.tag == 'ol') && proseNodes.isEmpty) {
          subAreaHasTopLevelList = true;
          for (final child in node.children ?? const <md.Node>[]) {
            if (child is md.Element && child.tag == 'li') {
              addEntryFromNodes(child.children ?? const []);
            }
          }
          continue;
        }
      }

      if (!subAreaHasTopLevelList && currentSubArea != null) {
        proseNodes.add(node);
      }
    }

    flushProseSection();
    return entries;
  }

  /// Extracts the first hyperlink `href` from [nodes], ignoring code blocks.
  static String? _extractFirstLink(List<md.Node> nodes) {
    for (final node in nodes) {
      if (node is md.Element) {
        if (node.tag == 'pre' || node.tag == 'code') continue;
        if (node.tag == 'a') {
          final href = node.attributes['href']?.trim();
          if (href != null && href.isNotEmpty) {
            return _htmlUnescape.convert(href);
          }
        }
        if (node.children case final children?) {
          final nested = _extractFirstLink(children);
          if (nested != null) return nested;
        }
      }
    }
    return null;
  }

  /// Serializes a list of block/inline AST [nodes] back into clean Markdown
  /// with all reference links inlined.
  static String _serializeBlocks(List<md.Node> nodes) {
    final blocks = <String>[];
    final inlineBuffer = StringBuffer();

    void flushInline() {
      final text = inlineBuffer.toString().trim();
      if (text.isNotEmpty) {
        blocks.add(text);
      }
      inlineBuffer.clear();
    }

    for (final node in nodes) {
      if (node is md.Element && _isBlockTag(node.tag)) {
        flushInline();
        final serialized = _serializeBlockElement(node).trimRight();
        if (serialized.isNotEmpty) {
          blocks.add(serialized);
        }
      } else {
        inlineBuffer.write(_serializeInlineNode(node));
      }
    }
    flushInline();

    return blocks.join('\n\n');
  }

  static bool _isBlockTag(String tag) => const {
    'p',
    'ul',
    'ol',
    'pre',
    'blockquote',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'hr',
  }.contains(tag);

  static String _serializeBlockElement(md.Element element) {
    switch (element.tag) {
      case 'p':
        return _serializeInlineNodes(element.children).trim();
      case 'pre':
        final codeElement = element.children
            ?.whereType<md.Element>()
            .firstWhere((e) => e.tag == 'code', orElse: () => element);
        final langClass = codeElement?.attributes['class'] ?? '';
        final lang = langClass.startsWith('language-')
            ? langClass.substring('language-'.length)
            : '';
        final rawCode = _htmlUnescape.convert(
          codeElement?.textContent ?? element.textContent,
        );
        final trimmedCode = rawCode.endsWith('\n')
            ? rawCode.substring(0, rawCode.length - 1)
            : rawCode;
        return '```$lang\n$trimmedCode\n```';
      case 'ul':
      case 'ol':
        final isOrdered = element.tag == 'ol';
        final lines = <String>[];
        var index = 1;
        for (final child in element.children ?? const <md.Node>[]) {
          if (child is! md.Element || child.tag != 'li') continue;
          final prefix = isOrdered ? '${index++}. ' : '- ';
          final indent = ' ' * prefix.length;
          final body = _serializeBlocks(child.children ?? const []);
          final bodyLines = body.split('\n');
          if (bodyLines.isEmpty) continue;
          lines.add('$prefix${bodyLines.first}');
          for (final continuation in bodyLines.skip(1)) {
            lines.add(continuation.isEmpty ? '' : '$indent$continuation');
          }
        }
        return lines.join('\n');
      case 'blockquote':
        final inner = _serializeBlocks(element.children ?? const []);
        return inner
            .split('\n')
            .map((line) => line.isEmpty ? '>' : '> $line')
            .join('\n');
      case 'h5':
        return '##### ${_serializeInlineNodes(element.children).trim()}';
      case 'h6':
        return '###### ${_serializeInlineNodes(element.children).trim()}';
      case 'hr':
        return '---';
      default:
        return _serializeInlineNodes(element.children).trim();
    }
  }

  static String _serializeInlineNodes(List<md.Node>? nodes) {
    if (nodes == null || nodes.isEmpty) return '';
    final buffer = StringBuffer();
    for (final node in nodes) {
      buffer.write(_serializeInlineNode(node));
    }
    return buffer.toString();
  }

  static String _serializeInlineNode(md.Node node) {
    if (node is md.Text) {
      return _htmlUnescape.convert(node.text);
    }
    if (node is md.Element) {
      switch (node.tag) {
        case 'code':
          final text = _htmlUnescape.convert(node.textContent);
          if (text.contains('`')) {
            return '`` $text ``';
          }
          return '`$text`';
        case 'strong':
          return '**${_serializeInlineNodes(node.children)}**';
        case 'em':
          return '*${_serializeInlineNodes(node.children)}*';
        case 'del':
          return '~~${_serializeInlineNodes(node.children)}~~';
        case 'a':
          final label = _serializeInlineNodes(node.children);
          final href = _htmlUnescape.convert(node.attributes['href'] ?? '');
          return href.isNotEmpty ? '[$label]($href)' : label;
        case 'br':
          return '\n';
        default:
          return _serializeInlineNodes(node.children);
      }
    }
    return _htmlUnescape.convert(node.textContent);
  }

  /// Filters out entries from [incoming] that already appear in [existingYaml]
  /// for [targetVersion] (by shared GitHub issue/PR URL or normalized
  /// `(area, subArea, description)` fingerprint).
  static ({List<_ChangelogEntry> addedEntries, int skippedCount})
  _filterNewEntries(
    List<_ChangelogEntry> incoming,
    String existingYaml,
    String targetVersion,
  ) {
    final existing = _loadSiteEntriesForVersion(existingYaml, targetVersion);
    if (existing.isEmpty) {
      return (addedEntries: incoming, skippedCount: 0);
    }

    final existingIssueUrls = <String>{
      for (final entry in existing) ...entry.issueUrls,
    };
    final existingFingerprints = <String>{
      for (final entry in existing) entry.fingerprint,
    };

    final addedEntries = <_ChangelogEntry>[];
    var skippedCount = 0;

    for (final entry in incoming) {
      final matchesIssue =
          entry.issueUrls.isNotEmpty &&
          entry.issueUrls.any(existingIssueUrls.contains);
      final matchesFingerprint = existingFingerprints.contains(
        entry.fingerprint,
      );
      if (matchesIssue || matchesFingerprint) {
        skippedCount++;
        continue;
      }
      addedEntries.add(entry);
      existingIssueUrls.addAll(entry.issueUrls);
      existingFingerprints.add(entry.fingerprint);
    }

    return (addedEntries: addedEntries, skippedCount: skippedCount);
  }

  static List<_SiteEntrySummary> _loadSiteEntriesForVersion(
    String yamlContent,
    String targetVersion,
  ) {
    if (yamlContent.trim().isEmpty) return const [];
    final parsed = loadYaml(yamlContent);
    if (parsed is! YamlList) return const [];

    final targetSemVer = Version.parse(targetVersion);
    final result = <_SiteEntrySummary>[];

    for (final item in parsed) {
      if (item is! YamlMap) continue;
      final versionStr = item['version']?.toString().trim() ?? '';
      if (versionStr.isEmpty) continue;
      final Version entryVersion;
      try {
        entryVersion = Version.parse(
          RegExp(r'^\d+\.\d+$').hasMatch(versionStr)
              ? '$versionStr.0'
              : versionStr,
        );
      } on FormatException {
        continue;
      }
      if (entryVersion != targetSemVer) continue;

      final area = item['area']?.toString().trim() ?? '';
      final subArea = item['subArea']?.toString().trim();
      final description = item['description']?.toString() ?? '';
      final link = item['link']?.toString() ?? '';
      final issueUrls = {
        ..._extractIssueUrls(description),
        ..._extractIssueUrls(link),
      };

      result.add(
        _SiteEntrySummary(
          area: area,
          subArea: (subArea != null && subArea.isNotEmpty) ? subArea : null,
          issueUrls: issueUrls,
          fingerprint: _entryFingerprint(area, subArea, description),
        ),
      );
    }

    return result;
  }

  static Set<String> _extractIssueUrls(String text) => {
    for (final match in _githubIssueUrlRegExp.allMatches(text))
      match.group(0)!.toLowerCase(),
  };

  static String _normalizedSectionKey(String area, String subArea) {
    final cleanSub = subArea.trim().replaceAll('`', '').toLowerCase();
    return '${area.trim().toLowerCase()}|$cleanSub';
  }

  static String _entryFingerprint(
    String area,
    String? subArea,
    String description,
  ) {
    final normalizedDesc = description.trim().toLowerCase().replaceAll(
      _whitespaceRegExp,
      ' ',
    );
    final normalizedSub = (subArea ?? '')
        .trim()
        .replaceAll('`', '')
        .toLowerCase();
    return '${area.trim().toLowerCase()}|$normalizedSub|$normalizedDesc';
  }

  /// Resolves the changelog area, inferring from [subArea] when an `### <Area>`
  /// header was omitted in `CHANGELOG.md` (e.g. orphan `#### Pub` headers).
  static String _resolveArea(String? area, String? subArea) {
    if (area != null && area.isNotEmpty) return area;
    if (subArea != null) {
      final normalized = subArea.toLowerCase();
      if (normalized.startsWith('`dart:') ||
          normalized.startsWith('dart:') ||
          normalized.startsWith('`package:') ||
          normalized.startsWith('package:')) {
        return 'Libraries';
      }
      if (normalized.contains('analyzer') ||
          normalized.contains('linter') ||
          normalized.contains('pub') ||
          normalized.contains('formatter') ||
          normalized.contains('format') ||
          normalized.contains('devtools') ||
          normalized.contains('compiler') ||
          normalized.contains('ddc') ||
          normalized.contains('dart2js') ||
          normalized.contains('dart2wasm') ||
          normalized.contains('cli')) {
        return 'Tools';
      }
      if (normalized.contains('vm') ||
          normalized.contains('wasm') ||
          normalized.contains('runtime') ||
          normalized.contains('c api') ||
          normalized.contains('embedder') ||
          normalized == 'build') {
        return 'Dart Runtime';
      }
    }
    return 'SDK';
  }

  /// Inserts [newYaml] at the monotonic descending SemVer position for
  /// [targetVersion] in [content].
  static String _applyPatches(
    String content,
    String newYaml,
    Version targetVersion,
  ) {
    final lines = content.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final match = _entryStartRegExp.firstMatch(lines[i]);
      if (match == null) continue;
      final raw = match.group(1)!;
      final Version existingVersion;
      try {
        existingVersion = Version.parse(
          RegExp(r'^\d+\.\d+$').hasMatch(raw) ? '$raw.0' : raw,
        );
      } on FormatException {
        continue;
      }
      if (existingVersion <= targetVersion) {
        final before = lines.sublist(0, i).join('\n');
        final after = lines.sublist(i).join('\n');
        if (before.isEmpty) {
          return '$newYaml$after';
        }
        return '$before\n$newYaml$after';
      }
    }

    if (content.isEmpty) return newYaml;
    return content.endsWith('\n') ? '$content$newYaml' : '$content\n$newYaml';
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
        newYaml.writeln(line.isEmpty ? '' : '    $line');
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
    this._yamlName,
    required this.words,
    required this.phrases,
  });

  /// The name written to the YAML output.
  String get yamlName => _yamlName ?? name;
  final String? _yamlName;

  /// Words that trigger this tag if contained.
  final List<String> words;

  /// Phrases that trigger this tag if contained.
  final List<String> phrases;
}

/// A single entry from the Dart SDK changelog.
final class _ChangelogEntry {
  final String version;
  final String releaseDate;
  final String area;
  final String? subArea;
  final String description;
  final Set<_ChangelogTag> tags;
  final String? link;
  final Set<String> issueUrls;

  _ChangelogEntry({
    required this.version,
    required this.releaseDate,
    required this.area,
    this.subArea,
    required this.description,
    required this.tags,
    this.link,
    required this.issueUrls,
  });

  String get fingerprint =>
      SyncChangelog._entryFingerprint(area, subArea, description);
}

final class _SiteEntrySummary {
  const _SiteEntrySummary({
    required this.area,
    required this.subArea,
    required this.issueUrls,
    required this.fingerprint,
  });

  final String area;
  final String? subArea;
  final Set<String> issueUrls;
  final String fingerprint;
}
