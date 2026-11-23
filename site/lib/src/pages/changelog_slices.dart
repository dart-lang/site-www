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
List<ChangelogEntry> readAndLoadChangelogEntries() =>
    _loadedChangelogEntries ??= ChangelogIndex.parseEntries(
      readRawChangelogEntries(),
    );

/// Reads the unparsed entry maps from `src/data/changelog.yml`.
List<Map<String, Object?>> readRawChangelogEntries() {
  var changelogFile = File(
    p.join(siteSrcDirectoryPath, 'data', 'changelog.yml'),
  );
  if (!changelogFile.existsSync()) {
    changelogFile = File(p.join('src', 'data', 'changelog.yml'));
  }

  final yamlList = loadYaml(changelogFile.readAsStringSync()) as YamlList;
  return [
    for (final item in yamlList)
      <String, Object?>{
        for (final MapEntry(:key, :value) in (item as YamlMap).entries)
          key.toString(): value is YamlList ? value.toList() : value,
      },
  ];
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
  final releaseDateByMinor = <String, String?>{};
  for (final version in sortedVersions) {
    final shortVersion = version.shortVersion;
    final items = groupedWithIds[version]!;
    final rawEntries = [for (final item in items) item.entry];
    final releaseDate = ChangelogIndex.releaseDateForGroup(rawEntries);
    releaseDateByMinor[shortVersion] = releaseDate;
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
    final (:manifestEntry, pages: slicePages) = _buildCategorySlice(
      directory: 'tags',
      id: slice.id,
      title: slice.title,
      description: slice.description,
      htmlUrl: slice.htmlUrl,
      items: [
        for (final item in allIndexed)
          if (slice.matches(item.entry)) item,
      ],
      releaseDateByMinor: releaseDateByMinor,
    );
    tagSliceManifest.add(manifestEntry);
    pages.addAll(slicePages);
  }

  // 3. Cross-version area slices: /changelog/areas/<slug>.{md,json}
  final orderedAreas = {for (final item in allIndexed) item.entry.area}.toList()
    ..sort(_compareAreas);

  final areaSliceManifest = <Map<String, Object?>>[];
  for (final area in orderedAreas) {
    final (:manifestEntry, pages: slicePages) = _buildCategorySlice(
      directory: 'areas',
      id: slugify(area),
      area: area,
      title: '$area changes',
      description: 'All $area changelog entries across Dart SDK releases.',
      htmlUrl: '/changelog#area=${Uri.encodeQueryComponent(area)}',
      items: [
        for (final item in allIndexed)
          if (item.entry.area == area) item,
      ],
      releaseDateByMinor: releaseDateByMinor,
    );
    areaSliceManifest.add(manifestEntry);
    pages.addAll(slicePages);
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

/// Orders areas by [_canonicalAreaOrder], then any other areas by name.
int _compareAreas(String a, String b) {
  final indexA = _canonicalAreaOrder.indexOf(a);
  final indexB = _canonicalAreaOrder.indexOf(b);
  if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
  if (indexA != -1) return -1;
  if (indexB != -1) return 1;
  return a.compareTo(b);
}

/// Builds the Markdown and JSON pages for a cross-version slice under
/// `/changelog/<directory>/<id>`, along with its `index.json` manifest entry.
({Map<String, Object?> manifestEntry, List<MemoryPage> pages})
_buildCategorySlice({
  required String directory,
  required String id,
  required String title,
  required String description,
  required String htmlUrl,
  required List<_IndexedEntry> items,
  required Map<String, String?> releaseDateByMinor,
  String? area,
}) {
  final markdownUrl = '/changelog/$directory/$id.md';
  final jsonUrl = '/changelog/$directory/$id.json';

  return (
    manifestEntry: {
      'id': id,
      'area': ?area,
      'title': title,
      'entryCount': items.length,
      'htmlUrl': htmlUrl,
      'markdownUrl': markdownUrl,
      'jsonUrl': jsonUrl,
    },
    pages: [
      _rawPage(
        path: 'changelog/$directory/$id.md',
        content: _renderCategoryMarkdown(
          title: 'Dart SDK changelog: $title',
          description: description,
          htmlUrl: htmlUrl,
          items: items,
          releaseDateByMinor: releaseDateByMinor,
        ),
      ),
      _rawPage(
        path: 'changelog/$directory/$id.json',
        content: _jsonEncoder.convert({
          'id': id,
          'area': ?area,
          'title': title,
          'description': description,
          'entryCount': items.length,
          'htmlUrl': htmlUrl,
          'markdownUrl': markdownUrl,
          'entries': [for (final item in items) item.toJson()],
        }),
      ),
    ],
  );
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
  ChangelogIndex.writeReleaseDateMarkdown(buffer, releaseDate);
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
  required Map<String, String?> releaseDateByMinor,
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
      ChangelogIndex.writeReleaseDateMarkdown(
        buffer,
        releaseDateByMinor[minor],
      );
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

/// Picks up to [maxCount] distinct `subArea (area)` labels that
/// summarize a minor release in `index.json`.
///
/// Labels from the `x.y.0` release are used before labels from its patch
/// releases, and they're taken one area at a time in [_canonicalAreaOrder]
/// so the entries of a single area can't fill every slot.
List<String> _extractHighlights(
  List<ChangelogEntry> entries, {
  int maxCount = 5,
}) {
  final seen = <String>{};
  final highlights = <String>[];

  void addOneAreaAtATime(Iterable<ChangelogEntry> candidates) {
    final labelsByArea = <String, List<String>>{};
    for (final entry in candidates) {
      final subArea = entry.subArea?.trim();
      if (subArea == null || subArea.isEmpty) continue;
      final label = '$subArea (${entry.area})';
      if (seen.add(label)) {
        labelsByArea.putIfAbsent(entry.area, () => []).add(label);
      }
    }

    final areas = labelsByArea.keys.toList()..sort(_compareAreas);
    for (var round = 0; highlights.length < maxCount; round++) {
      var added = false;
      for (final area in areas) {
        final labels = labelsByArea[area]!;
        if (round >= labels.length) continue;
        highlights.add(labels[round]);
        added = true;
        if (highlights.length >= maxCount) return;
      }
      if (!added) return;
    }
  }

  addOneAreaAtATime(entries.where((entry) => entry.version.patch == 0));
  addOneAreaAtATime(entries.where((entry) => entry.version.patch != 0));
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
