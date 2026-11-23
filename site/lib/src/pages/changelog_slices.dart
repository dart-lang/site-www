// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../components/pages/changelog/changelog_index.dart';
import '../models/changelog_model.dart';
import '../util.dart';

/// Matches static raw changelog slice routes emitted by
/// [changelogSliceMemoryPages].
final RegExp changelogSlicePathPattern = RegExp(
  r'^changelog/(?:index\.json|(?:versions|tags|areas)/[^/]+\.(?:md|json))$',
);

const JsonEncoder _jsonEncoder = JsonEncoder.withIndent('  ');

const List<String> _canonicalAreaOrder = [
  'Language',
  'Libraries',
  'Tools',
  'Dart Runtime',
  'SDK',
  'Docs',
];

/// Reads and parses changelog entries from `src/data/changelog.yml`.
List<ChangelogEntry> readAndLoadChangelogEntries() {
  if (_loadedChangelogEntries case final cached?) return cached;

  var changelogFile = File(
    p.join(siteSrcDirectoryPath, 'data', 'changelog.yml'),
  );
  if (!changelogFile.existsSync()) {
    changelogFile = File(p.join('src', 'data', 'changelog.yml'));
  }

  final yamlList = loadYaml(changelogFile.readAsStringSync()) as YamlList;
  final rawEntries = <Object?>[
    for (final item in yamlList)
      <String, Object?>{
        for (final MapEntry(:key, :value) in (item as YamlMap).entries)
          key.toString(): value is YamlList ? value.toList() : value,
      },
  ];
  return _loadedChangelogEntries = ChangelogIndex.parseEntries(rawEntries);
}

List<ChangelogEntry>? _loadedChangelogEntries;

/// All pre-sliced Markdown and JSON changelog pages emitted from
/// `src/data/changelog.yml`.
List<MemoryPage> get changelogSliceMemoryPages =>
    buildChangelogSlicePages(readAndLoadChangelogEntries());

/// Builds the root `/changelog/index.json` manifest, per-version slices,
/// and cross-version tag and area slices from [entries].
List<MemoryPage> buildChangelogSlicePages(List<ChangelogEntry> entries) {
  final (sortedVersions, groupedEntries) = ChangelogIndex.groupByMinorVersion(
    entries,
  );

  // Assign deterministic card IDs in the exact same iteration order as
  // ChangelogIndex.build so JSON entry URLs match rendered HTML anchors.
  final slugCounts = <String, int>{};
  final groupedWithIds = <Version, List<_IndexedEntry>>{};
  final allIndexed = <_IndexedEntry>[];
  for (final version in sortedVersions) {
    final list = <_IndexedEntry>[];
    for (final entry in groupedEntries[version]!) {
      final indexed = _IndexedEntry(
        entry: entry,
        cardId: ChangelogIndex.nextCardId(entry, slugCounts),
      );
      list.add(indexed);
      allIndexed.add(indexed);
    }
    groupedWithIds[version] = list;
  }

  final pages = <MemoryPage>[];

  // 1. Per-version slices: /changelog/versions/<major.minor>.{md,json}
  final releaseSummaries = <Map<String, Object?>>[];
  for (final version in sortedVersions) {
    final shortVersion = version.shortVersion;
    final items = groupedWithIds[version]!;
    final rawEntries = [for (final item in items) item.entry];
    final releaseDate = ChangelogIndex.releaseDateForGroup(rawEntries);
    final versionAnchor = 'v${shortVersion.replaceAll('.', '-')}';
    final htmlUrl = '/changelog#$versionAnchor';
    final markdownUrl = '/changelog/versions/$shortVersion.md';
    final jsonUrl = '/changelog/versions/$shortVersion.json';

    final tagCounts = _countTags(rawEntries);
    final highlights = _extractHighlights(rawEntries);

    releaseSummaries.add({
      'version': shortVersion,
      'releaseDate': ?releaseDate,
      'entryCount': items.length,
      'tagCounts': tagCounts,
      if (highlights.isNotEmpty) 'highlights': highlights,
      'htmlUrl': htmlUrl,
      'markdownUrl': markdownUrl,
      'jsonUrl': jsonUrl,
    });

    pages.add(
      _rawPage(
        path: 'changelog/versions/$shortVersion.md',
        content: _renderVersionMarkdown(
          shortVersion: shortVersion,
          releaseDate: releaseDate,
          htmlUrl: htmlUrl,
          items: items,
        ),
      ),
    );
    pages.add(
      _rawPage(
        path: 'changelog/versions/$shortVersion.json',
        content: _jsonEncoder.convert({
          'version': shortVersion,
          'releaseDate': ?releaseDate,
          'entryCount': items.length,
          'htmlUrl': htmlUrl,
          'markdownUrl': markdownUrl,
          'entries': [for (final item in items) item.toJson()],
        }),
      ),
    );
  }

  // 2. Cross-version tag slices: /changelog/tags/<id>.{md,json}
  final tagSliceDefinitions = [
    (
      id: 'breaking',
      title: 'Breaking changes',
      description: 'All breaking changes across Dart SDK releases.',
      htmlUrl: '/changelog#tags=breaking',
      matches: (ChangelogEntry entry) =>
          entry.tags.contains(ChangelogTag.breaking),
    ),
    (
      id: 'deprecated-removed',
      title: 'Deprecations and removals',
      description:
          'All deprecated and removed features across Dart SDK releases.',
      htmlUrl: '/changelog#tags=deprecated,removed',
      matches: (ChangelogEntry entry) =>
          entry.tags.contains(ChangelogTag.deprecated) ||
          entry.tags.contains(ChangelogTag.removed),
    ),
  ];

  final tagSliceManifest = <Map<String, Object?>>[];
  for (final slice in tagSliceDefinitions) {
    final matching = [
      for (final item in allIndexed)
        if (slice.matches(item.entry)) item,
    ];
    final markdownUrl = '/changelog/tags/${slice.id}.md';
    final jsonUrl = '/changelog/tags/${slice.id}.json';

    tagSliceManifest.add({
      'id': slice.id,
      'title': slice.title,
      'entryCount': matching.length,
      'htmlUrl': slice.htmlUrl,
      'markdownUrl': markdownUrl,
      'jsonUrl': jsonUrl,
    });

    pages.add(
      _rawPage(
        path: 'changelog/tags/${slice.id}.md',
        content: _renderCategoryMarkdown(
          title: 'Dart SDK changelog: ${slice.title}',
          description: slice.description,
          htmlUrl: slice.htmlUrl,
          items: matching,
        ),
      ),
    );
    pages.add(
      _rawPage(
        path: 'changelog/tags/${slice.id}.json',
        content: _jsonEncoder.convert({
          'id': slice.id,
          'title': slice.title,
          'description': slice.description,
          'entryCount': matching.length,
          'htmlUrl': slice.htmlUrl,
          'markdownUrl': markdownUrl,
          'entries': [for (final item in matching) item.toJson()],
        }),
      ),
    );
  }

  // 3. Cross-version area slices: /changelog/areas/<slug>.{md,json}
  final presentAreas = {for (final item in allIndexed) item.entry.area};
  final orderedAreas = presentAreas.toList()
    ..sort((a, b) {
      final indexA = _canonicalAreaOrder.indexOf(a);
      final indexB = _canonicalAreaOrder.indexOf(b);
      if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
      if (indexA != -1) return -1;
      if (indexB != -1) return 1;
      return a.compareTo(b);
    });

  final areaSliceManifest = <Map<String, Object?>>[];
  for (final area in orderedAreas) {
    final slug = slugify(area);
    final matching = [
      for (final item in allIndexed)
        if (item.entry.area == area) item,
    ];
    final title = '$area changes';
    final description = 'All $area changelog entries across Dart SDK releases.';
    final htmlUrl = '/changelog#area=${Uri.encodeQueryComponent(area)}';
    final markdownUrl = '/changelog/areas/$slug.md';
    final jsonUrl = '/changelog/areas/$slug.json';

    areaSliceManifest.add({
      'id': slug,
      'area': area,
      'title': title,
      'entryCount': matching.length,
      'htmlUrl': htmlUrl,
      'markdownUrl': markdownUrl,
      'jsonUrl': jsonUrl,
    });

    pages.add(
      _rawPage(
        path: 'changelog/areas/$slug.md',
        content: _renderCategoryMarkdown(
          title: 'Dart SDK changelog: $title',
          description: description,
          htmlUrl: htmlUrl,
          items: matching,
        ),
      ),
    );
    pages.add(
      _rawPage(
        path: 'changelog/areas/$slug.json',
        content: _jsonEncoder.convert({
          'id': slug,
          'area': area,
          'title': title,
          'description': description,
          'entryCount': matching.length,
          'htmlUrl': htmlUrl,
          'markdownUrl': markdownUrl,
          'entries': [for (final item in matching) item.toJson()],
        }),
      ),
    );
  }

  // 4. Root JSON manifest: /changelog/index.json
  final manifest = <String, Object?>{
    'title': 'Dart SDK changelog index',
    'description':
        'Machine-readable index of Dart SDK releases with links to compact '
        'per-version and cross-version Markdown and JSON slices.',
    'htmlUrl': '/changelog',
    'markdownUrl': '/changelog.md',
    'totalEntries': allIndexed.length,
    'totalReleases': sortedVersions.length,
    if (sortedVersions.isNotEmpty) ...{
      'latestVersion': sortedVersions.first.shortVersion,
      'oldestVersion': sortedVersions.last.shortVersion,
    },
    'slices': {
      'tags': tagSliceManifest,
      'areas': areaSliceManifest,
    },
    'releases': releaseSummaries,
  };

  pages.insert(
    0,
    _rawPage(
      path: 'changelog/index.json',
      content: _jsonEncoder.convert(manifest),
    ),
  );

  return pages;
}

MemoryPage _rawPage({required String path, required String content}) {
  return MemoryPage(
    path: path,
    keepSuffix: true,
    initialData: const {
      'page': <String, Object?>{
        'sitemap': false,
      },
    },
    content: content,
  );
}

String _renderVersionMarkdown({
  required String shortVersion,
  required String? releaseDate,
  required String htmlUrl,
  required List<_IndexedEntry> items,
}) {
  final buffer = StringBuffer();
  buffer.writeln('# Dart $shortVersion changelog');
  buffer.writeln();
  final countLabel = items.length == 1 ? '1 entry' : '${items.length} entries';
  buffer.writeln(
    '> Release notes for Dart $shortVersion ($countLabel). '
    'Browse interactively at [$htmlUrl]($htmlUrl) or inspect the '
    '[changelog JSON index](/changelog/index.json).',
  );
  buffer.writeln();
  if (releaseDate != null) {
    buffer.writeln('_Released: ${releaseDate}_');
    buffer.writeln();
  }
  for (final item in items) {
    ChangelogIndex.writeEntryMarkdown(buffer, item.entry);
  }
  return buffer.toString().trimRight();
}

String _renderCategoryMarkdown({
  required String title,
  required String description,
  required String htmlUrl,
  required List<_IndexedEntry> items,
}) {
  final buffer = StringBuffer();
  buffer.writeln('# $title');
  buffer.writeln();
  final countLabel = items.length == 1 ? '1 entry' : '${items.length} entries';
  final summary = description.endsWith('.')
      ? description.substring(0, description.length - 1)
      : description;
  buffer.writeln(
    '> $summary ($countLabel). '
    'Browse interactively at [$htmlUrl]($htmlUrl) or inspect the '
    '[changelog JSON index](/changelog/index.json).',
  );
  buffer.writeln();

  String? currentMinor;
  for (final item in items) {
    final minor = item.entry.version.shortVersion;
    if (minor != currentMinor) {
      currentMinor = minor;
      buffer.writeln('## Dart $minor');
      buffer.writeln();
    }
    ChangelogIndex.writeEntryMarkdown(buffer, item.entry);
  }
  return buffer.toString().trimRight();
}

Map<String, int> _countTags(List<ChangelogEntry> entries) {
  final counts = <String, int>{};
  for (final tag in ChangelogTag.values) {
    if (tag == ChangelogTag.none) continue;
    final count = entries.where((e) => e.tags.contains(tag)).length;
    if (count > 0) {
      counts[tag.id] = count;
    }
  }
  return counts;
}

List<String> _extractHighlights(
  List<ChangelogEntry> entries, {
  int maxCount = 5,
}) {
  final seen = <String>{};
  final highlights = <String>[];
  for (final entry in entries) {
    final subArea = entry.subArea?.trim();
    if (subArea == null || subArea.isEmpty) continue;
    final label = '$subArea (${entry.area})';
    if (seen.add(label)) {
      highlights.add(label);
      if (highlights.length >= maxCount) break;
    }
  }
  return highlights;
}

final class _IndexedEntry {
  const _IndexedEntry({required this.entry, required this.cardId});

  final ChangelogEntry entry;
  final String cardId;

  Map<String, Object?> toJson() {
    final orderedTags = [
      for (final tag in ChangelogTag.values)
        if (tag != ChangelogTag.none && entry.tags.contains(tag)) tag.id,
    ];
    return {
      'id': cardId,
      'url': '/changelog#$cardId',
      'version': entry.version.toString(),
      'releaseDate': ?entry.releaseDate,
      'area': entry.area,
      'subArea': ?entry.subArea,
      'tags': orderedTags,
      'description': entry.description.trim(),
      'link': ?entry.link,
    };
  }
}
