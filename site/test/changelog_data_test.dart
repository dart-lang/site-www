// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters_notifier.dart';
import 'package:dart_dev_site/src/components/pages/changelog/changelog_index.dart';
import 'package:dart_dev_site/src/models/changelog_model.dart';
import 'package:dart_dev_site/src/pages/changelog_slices.dart';
import 'package:dart_dev_site/src/util.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('changelog.yml data integrity', () {
    late List<Map<String, Object?>> rawEntries;
    late List<ChangelogEntry> entries;

    setUpAll(() {
      var changelogFile = File(
        path.join(siteSrcDirectoryPath, 'data', 'changelog.yml'),
      );
      if (!changelogFile.existsSync()) {
        changelogFile = File(path.join('src', 'data', 'changelog.yml'));
      }
      final yamlList = loadYaml(changelogFile.readAsStringSync()) as YamlList;
      rawEntries = [
        for (final item in yamlList)
          <String, Object?>{
            for (final MapEntry(:key, :value) in (item as YamlMap).entries)
              key.toString(): value is YamlList ? value.toList() : value,
          },
      ];
      entries = [for (final map in rawEntries) ChangelogEntry.fromMap(map)];
    });

    test('parses all entries with valid areas and non-empty tags', () {
      expect(entries, isNotEmpty);
      const validAreas = {
        'SDK',
        'Language',
        'Libraries',
        'Tools',
        'Dart Runtime',
        'Docs',
      };
      final refUsagePattern = RegExp(r'\[([^\]]+)\]\[([^\]]*)\]');
      final refDefPattern = RegExp(r'^\s*\[([^\]]+)\]:\s*\S+', multiLine: true);

      for (final entry in entries) {
        expect(validAreas, contains(entry.area));
        expect(entry.tags, isNotEmpty);
        expect(entry.description.trim(), isNotEmpty);

        final definedRefs = {
          for (final match in refDefPattern.allMatches(entry.description))
            match.group(1)!.toLowerCase(),
        };
        for (final match in refUsagePattern.allMatches(entry.description)) {
          final label = match.group(1)!;
          final refKey = (match.group(2)!.isEmpty ? label : match.group(2)!)
              .toLowerCase();
          expect(
            definedRefs,
            contains(refKey),
            reason:
                'Unresolved Markdown reference link "${match.group(0)}" in '
                'version ${entry.version} (${entry.area} / ${entry.subArea}).',
          );
        }
      }
    });

    test('every entry has a concrete YYYY-MM-DD release date', () {
      // The changelog page shows the `x.y.0` entry's date in the version
      // header, so a leftover `TBD` placeholder from `sync-changelog`
      // would be rendered verbatim as "Released TBD".
      final isoDate = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      for (final entry in entries) {
        expect(
          entry.releaseDate,
          isNotNull,
          reason:
              'Missing releaseDate for ${entry.version}: '
              '${entry.description.split('\n').first}',
        );
        expect(
          entry.releaseDate,
          matches(isoDate),
          reason:
              'releaseDate "${entry.releaseDate}" for ${entry.version} '
              'is not YYYY-MM-DD. Replace any "TBD" placeholders with the '
              'actual release date.',
        );
      }
    });

    test('throws ArgumentError on unknown tag IDs', () {
      expect(
        () => ChangelogEntry.fromMap({
          'version': '3.13.0',
          'releaseDate': '2026-08-12',
          'area': 'Language',
          'description': 'Test entry',
          'tags': ['unknown_tag'],
        }),
        throwsArgumentError,
      );
    });

    test('includes corrected 3.9.4 Pub and 3.9.3 DDC patch entries', () {
      final v394 = entries.singleWhere(
        (e) => e.version == Version.parse('3.9.4'),
      );
      expect(v394.area, 'Tools');
      expect(v394.subArea, 'Pub');
      expect(v394.description, contains('dart pub get --example'));
      expect(v394.tags, contains(ChangelogTag.fixed));

      final v393 = entries.singleWhere(
        (e) => e.version == Version.parse('3.9.3'),
      );
      expect(v393.area, 'Tools');
      expect(v393.subArea, 'Development JavaScript compiler (DDC)');
      expect(v393.description, contains('static calls are deeply nested'));
      expect(v393.tags, contains(ChangelogTag.fixed));
    });

    test('renders clean Markdown for /changelog.md', () {
      final markdown = ChangelogIndex.renderMarkdown(rawEntries);
      expect(markdown, contains('## Pre-sliced endpoints'));
      expect(markdown, contains('/changelog/index.json'));
      expect(markdown, contains('/changelog/tags/breaking.md'));
      expect(markdown, contains('## Dart 3.13'));
      expect(markdown, contains('### [3.9.4] [Tools] — Pub (Fixed)'));
      expect(markdown, isNot(contains('<ChangelogIndex')));
    });

    test('emits static index.json, version, tag, and area slices', () {
      final slicePages = buildChangelogSlicePages(entries);
      final pagesByPath = {
        for (final page in slicePages) page.path: page,
      };

      expect(pagesByPath.length, slicePages.length);
      for (final page in slicePages) {
        expect(
          changelogSlicePathPattern.hasMatch(page.path),
          isTrue,
          reason: 'Unexpected slice path: ${page.path}',
        );
        expect(page.keepSuffix, isTrue, reason: page.path);
        final pageData = page.initialData['page'] as Map<String, Object?>;
        expect(pageData['sitemap'], isFalse, reason: page.path);
        expect(page.content, isNotNull);
        expect(page.content!.trim(), isNotEmpty, reason: page.path);
      }

      // Root manifest: /changelog/index.json
      final indexPage = pagesByPath['changelog/index.json'];
      expect(indexPage, isNotNull);
      final manifest = jsonDecode(indexPage!.content!) as Map<String, Object?>;
      expect(manifest['totalEntries'], entries.length);
      expect(manifest['htmlUrl'], '/changelog');
      expect(manifest['markdownUrl'], '/changelog.md');

      final releases = (manifest['releases'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(releases, isNotEmpty);
      expect(manifest['totalReleases'], releases.length);

      // Every linked release slice in index.json exists in emitted pages.
      for (final release in releases) {
        final mdPath = (release['markdownUrl'] as String).substring(1);
        final jsonPath = (release['jsonUrl'] as String).substring(1);
        expect(pagesByPath, contains(mdPath));
        expect(pagesByPath, contains(jsonPath));
      }

      // Spot-check a minor version slice containing patch releases (3.9).
      final v39Json = jsonDecode(
        pagesByPath['changelog/versions/3.9.json']!.content!,
      ) as Map<String, Object?>;
      final v39Entries = (v39Json['entries'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(
        v39Entries.any(
          (e) =>
              e['version'] == '3.9.4' &&
              e['id'] == 'v3-9-4-tools-pub-0' &&
              e['url'] == '/changelog#v3-9-4-tools-pub-0',
        ),
        isTrue,
      );
      expect(
        pagesByPath['changelog/versions/3.9.md']!.content,
        contains('# Dart 3.9 changelog'),
      );

      // Cross-version breaking changes slice contains only breaking entries.
      final breakingJson = jsonDecode(
        pagesByPath['changelog/tags/breaking.json']!.content!,
      ) as Map<String, Object?>;
      final breakingEntries = (breakingJson['entries'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(breakingEntries, isNotEmpty);
      for (final entry in breakingEntries) {
        final tags = (entry['tags'] as List<Object?>).cast<String>();
        expect(tags, contains('breaking'));
      }
      expect(
        pagesByPath['changelog/tags/breaking.md']!.content,
        contains('# Dart SDK changelog: Breaking changes'),
      );

      // Cross-version deprecated/removed slice.
      final deprecatedJson = jsonDecode(
        pagesByPath['changelog/tags/deprecated-removed.json']!.content!,
      ) as Map<String, Object?>;
      final deprecatedEntries = (deprecatedJson['entries'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(deprecatedEntries, isNotEmpty);
      for (final entry in deprecatedEntries) {
        final tags = (entry['tags'] as List<Object?>).cast<String>();
        expect(
          tags.contains('deprecated') || tags.contains('removed'),
          isTrue,
        );
      }

      // Cross-version Language area slice contains only Language entries.
      final languageJson = jsonDecode(
        pagesByPath['changelog/areas/language.json']!.content!,
      ) as Map<String, Object?>;
      final languageEntries = (languageJson['entries'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(languageEntries, isNotEmpty);
      for (final entry in languageEntries) {
        expect(entry['area'], 'Language');
      }
      expect(
        pagesByPath['changelog/areas/language.md']!.content,
        contains('# Dart SDK changelog: Language changes'),
      );
    });
  });

  group('ChangelogFiltersNotifier #fragment routing & serialization', () {
    late ChangelogFiltersNotifier notifier;

    setUp(() {
      notifier = ChangelogFiltersNotifier()
        ..availableAreas.addAll([
          'SDK',
          'Language',
          'Libraries',
          'Tools',
          'Dart Runtime',
          'Docs',
        ])
        ..availableVersions.addAll([
          for (var minor = 0; minor <= 13; minor++) Version(3, minor, 0),
          Version(2, 19, 0),
        ]);
    });

    test('routes direct card and version anchors without hiding filters', () {
      notifier.setTag(ChangelogTag.breaking, true);
      final result = notifier.parseAndApplyUrlFragment(
        '#v3-13-0-language-primary-constructors-0',
      );

      expect(result.isFilterHash, isFalse);
      expect(result.searchQuery, isEmpty);
      expect(result.targetId, 'v3-13-0-language-primary-constructors-0');
      expect(notifier.selectedTags, isEmpty);
      expect(notifier.selectedAreas, isEmpty);
      expect(notifier.selectedVersions, isEmpty);
    });

    test('hydrates structured filter hash including from/to version range', () {
      final result = notifier.parseAndApplyUrlFragment(
        '#from=3.10&to=3.13&tags=breaking,versioned'
        '&area=language,Dart+Runtime&q=macro&id=v3-13-0-language-0',
      );

      expect(result.isFilterHash, isTrue);
      expect(result.searchQuery, 'macro');
      expect(result.targetId, 'v3-13-0-language-0');
      expect(
        notifier.selectedTags,
        unorderedEquals([
          ChangelogTag.breaking,
          ChangelogTag.languageVersioned,
        ]),
      );
      expect(
        notifier.selectedAreas,
        unorderedEquals(['Language', 'Dart Runtime']),
      );
      expect(
        notifier.selectedVersions,
        unorderedEquals([
          Version(3, 10, 0),
          Version(3, 11, 0),
          Version(3, 12, 0),
          Version(3, 13, 0),
        ]),
      );
    });

    test('serializes active filters into canonical URL fragment', () {
      notifier
        ..setTag(ChangelogTag.breaking, true)
        ..setTag(ChangelogTag.newTag, true)
        ..setArea('Dart Runtime', true)
        ..setArea('Language', true)
        ..setVersion(Version(3, 12, 0), true)
        ..setVersion(Version(3, 13, 0), true);

      final fragment = notifier.toUrlFragment(searchQuery: 'primary');
      expect(
        fragment,
        'tags=new,breaking&area=Language,Dart+Runtime'
        '&versions=3.13,3.12&q=primary',
      );
    });

    test('setVersionRange selects range and serializes from/to fragment', () {
      notifier.setVersionRange(
        from: Version(3, 10, 0),
        to: Version(3, 12, 0),
      );

      expect(notifier.fromVersion, Version(3, 10, 0));
      expect(notifier.toVersion, Version(3, 12, 0));
      expect(
        notifier.selectedVersions,
        unorderedEquals([
          Version(3, 10, 0),
          Version(3, 11, 0),
          Version(3, 12, 0),
        ]),
      );
      expect(notifier.toUrlFragment(), 'from=3.10&to=3.12');

      // Toggling an individual version clears fromVersion/toVersion
      // and falls back to discrete versions=... serialization.
      notifier.setVersion(Version(3, 11, 0), false);
      expect(notifier.fromVersion, isNull);
      expect(notifier.toVersion, isNull);
      expect(notifier.toUrlFragment(), 'versions=3.12,3.10');
    });

    test('setVersionRange clamps an inverted range to the from version', () {
      notifier.setVersionRange(from: Version(3, 12, 0), to: Version(3, 10, 0));

      expect(notifier.fromVersion, Version(3, 12, 0));
      expect(notifier.toVersion, Version(3, 12, 0));
      expect(notifier.selectedVersions, {Version(3, 12, 0)});
    });

    test('hasVersionFilter reflects both discrete and range selection', () {
      expect(notifier.hasVersionFilter, isFalse);

      notifier.setVersion(Version(3, 13, 0), true);
      expect(notifier.hasVersionFilter, isTrue);

      // A range with no matching available versions still counts as active
      // so the UI can offer to clear it.
      notifier.setVersionRange(from: Version(9, 0, 0));
      expect(notifier.selectedVersions, isEmpty);
      expect(notifier.hasVersionFilter, isTrue);

      notifier.reset();
      expect(notifier.hasVersionFilter, isFalse);
    });

    test('explicit versions= wins over from/to when both are present', () {
      notifier.parseAndApplyUrlFragment('#versions=3.13&from=3.10&to=3.12');

      // Both are applied to the selection, but the range isn't recorded so
      // the fragment round-trips back to the discrete form.
      expect(notifier.fromVersion, isNull);
      expect(notifier.toVersion, isNull);
      expect(
        notifier.selectedVersions,
        unorderedEquals([
          Version(3, 10, 0),
          Version(3, 11, 0),
          Version(3, 12, 0),
          Version(3, 13, 0),
        ]),
      );
      expect(notifier.toUrlFragment(), 'versions=3.13,3.12,3.11,3.10');
    });

    test('updateFacetCounts ignores its own facet but honors the others', () {
      final sampleEntries = [
        ChangelogEntry(
          version: Version.parse('3.13.0'),
          area: 'Language',
          description: 'Primary constructors.',
          tags: {ChangelogTag.newTag},
        ),
        ChangelogEntry(
          version: Version.parse('3.13.0'),
          area: 'Tools',
          description: 'Remove the legacy analyzer flag.',
          tags: {ChangelogTag.breaking},
        ),
        ChangelogEntry(
          version: Version.parse('3.12.0'),
          area: 'Language',
          description: 'Tighten a type promotion rule.',
          tags: {ChangelogTag.breaking},
        ),
      ];

      // No filters: plain totals.
      expect(notifier.updateFacetCounts(sampleEntries, ''), isTrue);
      expect(notifier.tagCounts, {
        ChangelogTag.newTag: 1,
        ChangelogTag.breaking: 2,
      });
      expect(notifier.areaCounts, {'Language': 2, 'Tools': 1});

      // Same inputs again: no change, no notification.
      var notifications = 0;
      notifier.addListener(() => notifications++);
      expect(notifier.updateFacetCounts(sampleEntries, ''), isFalse);
      expect(notifications, 0);

      // Selecting a tag narrows area counts but leaves tag counts intact
      // so users can still see what switching tags would yield.
      notifier.setTag(ChangelogTag.breaking, true);
      notifier.updateFacetCounts(sampleEntries, '');
      expect(notifier.tagCounts, {
        ChangelogTag.newTag: 1,
        ChangelogTag.breaking: 2,
      });
      expect(notifier.areaCounts, {'Language': 1, 'Tools': 1});

      // A version filter narrows both.
      notifier.setVersion(Version(3, 13, 0), true);
      notifier.updateFacetCounts(sampleEntries, '');
      expect(notifier.tagCounts, {
        ChangelogTag.newTag: 1,
        ChangelogTag.breaking: 1,
      });
      expect(notifier.areaCounts, {'Tools': 1});
    });

    test(
      'filterEntries performs tokenized AND search across fields and tags',
      () {
        final sampleEntries = [
          ChangelogEntry(
            version: Version.parse('3.13.0'),
            area: 'Language',
            subArea: 'Primary constructors',
            description: 'Introduce concise primary constructor syntax.',
            tags: {ChangelogTag.newTag},
          ),
          ChangelogEntry(
            version: Version.parse('3.9.4'),
            area: 'Tools',
            subArea: 'Pub',
            description: 'Fix `dart pub get --example` resolution.',
            tags: {ChangelogTag.fixed},
          ),
        ];

        // Out-of-order multi-token query across description and subArea.
        final constructorMatches = notifier.filterEntries(
          sampleEntries,
          'syntax primary',
        );
        expect(constructorMatches, [sampleEntries.first]);

        // Multi-token query matching tag label ("fixed"), subArea ("pub"),
        // and patch version ("3.9.4").
        final pubMatches = notifier.filterEntries(
          sampleEntries,
          'fixed pub 3.9.4',
        );
        expect(pubMatches, [sampleEntries.last]);

        // Multi-token query where one token does not match.
        final noMatches = notifier.filterEntries(
          sampleEntries,
          'primary pub',
        );
        expect(noMatches, isEmpty);
      },
    );
  });
}
