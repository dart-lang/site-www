// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_dev_site/src/components/pages/changelog/changelog_index.dart';
import 'package:dart_dev_site/src/models/changelog_model.dart';
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
      for (final entry in entries) {
        expect(validAreas, contains(entry.area));
        expect(entry.tags, isNotEmpty);
        expect(entry.description.trim(), isNotEmpty);
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

    test('renders clean Markdown for /changelog/index.html.md', () {
      final markdown = ChangelogIndex.renderMarkdown(rawEntries);
      expect(markdown, contains('## Dart 3.13'));
      expect(markdown, contains('### [3.9.4] [Tools] — Pub (Fixed)'));
      expect(markdown, isNot(contains('<ChangelogIndex')));
    });
  });
}
