// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dash_site/src/commands/sync_changelog.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('SyncChangelog.parseAndGenerateYaml', () {
    test('inlines ref links and maps each bullet to its issue URL', () {
      const markdown = '''
## 3.9.1

**Released on:** 2025-08-20

This is a patch release that:

- Fixes an issue in DevTools causing assertion errors in the terminal after
  clicking 'Clear' on the Network Screen (issue [dart-lang/sdk#61187][]).
- Fixes miscompilation to ARM32 when an app used
  a large amount of literals (issue [flutter/flutter#172626][]).
- Fixes an issue with git dependencies using `tag_pattern`,
  where the `pubspec.lock` file would not be stable when
  running `dart pub get` (issue [dart-lang/pub#4644][]).

[dart-lang/sdk#61187]: https://github.com/dart-lang/sdk/issues/61187
[flutter/flutter#172626]: https://github.com/flutter/flutter/issues/172626
[dart-lang/pub#4644]: https://github.com/dart-lang/pub/issues/4644
''';

      final yamlOutput = SyncChangelog.parseAndGenerateYaml(markdown, '3.9.1');
      final entries = loadYaml(yamlOutput) as YamlList;
      expect(entries, hasLength(3));

      final first = entries[0] as YamlMap;
      expect(
        first['description'],
        contains(
          '[dart-lang/sdk#61187](https://github.com/dart-lang/sdk/issues/61187)',
        ),
      );
      expect(first['link'], 'https://github.com/dart-lang/sdk/issues/61187');

      final second = entries[1] as YamlMap;
      expect(
        second['description'],
        contains(
          '[flutter/flutter#172626](https://github.com/flutter/flutter/issues/172626)',
        ),
      );
      expect(
        second['link'],
        'https://github.com/flutter/flutter/issues/172626',
      );

      final third = entries[2] as YamlMap;
      expect(
        third['description'],
        contains(
          '[dart-lang/pub#4644](https://github.com/dart-lang/pub/issues/4644)',
        ),
      );
      expect(third['link'], 'https://github.com/dart-lang/pub/issues/4644');
    });

    test('reads the release date from the "Released on" line', () {
      const markdown = '''
## 3.14.0

  **Released on:** 2026-11-04

### Language

- Adds a thing.

## 3.13.0

**Released on:** 2026-08-12

### Language

- Adds an older thing.
''';

      final entries = loadYaml(
        SyncChangelog.parseAndGenerateYaml(markdown, '3.14.0'),
      ) as YamlList;
      expect(entries, hasLength(1));
      expect((entries.single as YamlMap)['releaseDate'], '2026-11-04');
    });

    test('falls back to the TBD placeholder when unreleased', () {
      const markdown = '''
## 3.14.0

**Released on:** Unreleased

### Language

- Adds a thing.
''';

      final entries = loadYaml(
        SyncChangelog.parseAndGenerateYaml(markdown, '3.14.0'),
      ) as YamlList;
      expect(
        (entries.single as YamlMap)['releaseDate'],
        SyncChangelog.unknownReleaseDate,
      );
    });

    test('an explicit release date overrides the changelog', () {
      const markdown = '''
## 3.14.0

**Released on:** Unreleased

### Language

- Adds a thing.
''';

      final entries = loadYaml(
        SyncChangelog.parseAndGenerateYaml(
          markdown,
          '3.14.0',
          releaseDate: '2026-11-04',
        ),
      ) as YamlList;
      expect((entries.single as YamlMap)['releaseDate'], '2026-11-04');
    });

    test('preserves prose sub-area sections that contain bullet lists', () {
      const markdown = '''
## 3.13.0

**Released on:** 2026-08-12

### Language

#### Primary constructors

The primary constructors feature is a brevity feature.

Key capabilities include:
- Concise field declarations in the class header.
- Optional `this` body syntax for initializer lists.

See the [feature specification][primary-constructor-spec].

[primary-constructor-spec]: https://github.com/dart-lang/language/blob/main/accepted/3.13/primary-constructors/feature-specification.md
''';

      final yamlOutput = SyncChangelog.parseAndGenerateYaml(markdown, '3.13.0');
      final entries = loadYaml(yamlOutput) as YamlList;
      expect(entries, hasLength(1));

      final entry = entries.single as YamlMap;
      expect(entry['area'], 'Language');
      expect(entry['subArea'], 'Primary constructors');
      expect(
        entry['description'],
        allOf(
          contains('The primary constructors feature is a brevity feature.'),
          contains('- Concise field declarations in the class header.'),
          contains(
            '[feature specification](https://github.com/dart-lang/language/blob/main/accepted/3.13/primary-constructors/feature-specification.md)',
          ),
        ),
      );
      expect(
        entry['link'],
        'https://github.com/dart-lang/language/blob/main/accepted/3.13/primary-constructors/feature-specification.md',
      );
    });

    test('handles fenced code blocks and orphan H4 headers via AST', () {
      const markdown = '''
## 3.9.4 - 2025-09-30

#### Pub

- `dart pub get --example` now resolves `example/` folders (issue [dart-lang/pub#4674][]).

[dart-lang/pub#4674]: https://github.com/dart-lang/pub/issues/4674

## 3.13.0

**Released on:** 2026-08-12

### Language

#### Primary constructors

Declare classes concisely with generic types like `List<int>`:

```dart
## not a version header
- not a bullet item
class Point<T>(var T x, var T y);
```
''';

      final v394 = loadYaml(
        SyncChangelog.parseAndGenerateYaml(markdown, '3.9.4'),
      ) as YamlList;
      expect(v394, hasLength(1));
      final pubEntry = v394.single as YamlMap;
      expect(pubEntry['releaseDate'], '2025-09-30');
      expect(pubEntry['area'], 'Tools');
      expect(pubEntry['subArea'], 'Pub');
      expect(pubEntry['link'], 'https://github.com/dart-lang/pub/issues/4674');

      final v313 = loadYaml(
        SyncChangelog.parseAndGenerateYaml(markdown, '3.13.0'),
      ) as YamlList;
      expect(v313, hasLength(1));
      final pcEntry = v313.single as YamlMap;
      expect(pcEntry['description'], contains('`List<int>`'));
      expect(pcEntry['description'], contains('```dart'));
      expect(
        pcEntry['description'],
        contains('class Point<T>(var T x, var T y);'),
      );
    });
  });

  group('SyncChangelog.syncIntoYaml (idempotent sync)', () {
    const sdkMarkdown = '''
## 3.14.0

**Released on:** 2026-11-11

### Libraries

#### `dart:ffi`

- Added `NativeFinalizer.callback` ([#63811][]).
- Added `Abi.iosArm64e` ([#63420][]).

[#63811]: https://github.com/dart-lang/sdk/issues/63811
[#63420]: https://github.com/dart-lang/sdk/issues/63420

## 3.13.1

**Released on:** 2026-09-01

#### Pub

- Fixed lockfile bug ([dart-lang/pub#5000][]).

[dart-lang/pub#5000]: https://github.com/dart-lang/pub/issues/5000
''';

    test('skips entries already present by issue URL or fingerprint', () {
      const existingYaml = '''
# --------------------------------------------------
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Libraries
  subArea: '`dart:ffi`'
  description: |
    Hand-edited docs prose for NativeFinalizer.callback
    ([#63811](https://github.com/dart-lang/sdk/issues/63811)).
  tags:
    - new
  link: /interop/c-interop
# --------------------------------------------------
''';

      final firstSync = SyncChangelog.syncIntoYaml(
        sdkMarkdown: sdkMarkdown,
        existingYaml: existingYaml,
        targetVersion: '3.14.0',
      );
      expect(firstSync.skippedCount, 1);
      expect(firstSync.addedCount, 1);
      final parsed = loadYaml(firstSync.updatedYaml) as YamlList;
      expect(parsed, hasLength(2));

      // Re-running a second time is a complete no-op.
      final secondSync = SyncChangelog.syncIntoYaml(
        sdkMarkdown: sdkMarkdown,
        existingYaml: firstSync.updatedYaml,
        targetVersion: '3.14.0',
      );
      expect(secondSync.addedCount, 0);
      expect(secondSync.skippedCount, 2);
      expect(secondSync.updatedYaml, firstSync.updatedYaml);
    });

    test('inserts patch versions in monotonic descending SemVer order', () {
      const existingYaml = '''
# --------------------------------------------------
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Language
  description: Feature in 3.14.
  tags:
    - new
# --------------------------------------------------
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Language
  description: Feature in 3.13.
  tags:
    - new
# --------------------------------------------------
''';

      final synced = SyncChangelog.syncIntoYaml(
        sdkMarkdown: sdkMarkdown,
        existingYaml: existingYaml,
        targetVersion: '3.13.1',
      );
      expect(synced.addedCount, 1);
      final parsed = loadYaml(synced.updatedYaml) as YamlList;
      final versions = [
        for (final entry in parsed) (entry as YamlMap)['version'].toString(),
      ];
      expect(versions, ['3.14.0', '3.13.1', '3.13.0']);
    });
  });

  group('SyncChangelog.checkDrift', () {
    const sdkMarkdown = '''
## 3.14.0

**Released on:** 2026-11-11

### Libraries

#### `dart:ffi`

- Added `NativeFinalizer.callback` ([#63811][]).

[#63811]: https://github.com/dart-lang/sdk/issues/63811

### Tools

#### Pub

- Fixed workspace resolution ([dart-lang/pub#4674][]).

[dart-lang/pub#4674]: https://github.com/dart-lang/pub/issues/4674
''';

    test(
      'passes when site rewrites prose while covering issues and sections',
      () {
        const siteYaml = '''
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Libraries
  subArea: '`dart:ffi`'
  description: |
    Added `NativeFinalizer.callback` for inspecting finalizers
    ([#63811](https://github.com/dart-lang/sdk/issues/63811)).
  tags:
    - new
  link: /interop/c-interop
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Tools
  subArea: Pub
  description: |
    Fixed `dart pub get --example` resolution across workspaces.
  tags:
    - fixed
  link: https://github.com/dart-lang/pub/issues/4674
''';

        final report = SyncChangelog.checkDrift(
          sdkMarkdown: sdkMarkdown,
          siteYaml: siteYaml,
          targetVersion: '3.14.0',
        );
        expect(report.hasDrift, isFalse);
        expect(report.versionMissing, isFalse);
        expect(report.missingIssueUrls, isEmpty);
        expect(report.missingSections, isEmpty);
      },
    );

    test('detects missing sections and unreferenced SDK issue URLs', () {
      const siteYaml = '''
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Libraries
  subArea: '`dart:ffi`'
  description: Added `NativeFinalizer.callback`.
  tags:
    - new
  link: /interop/c-interop
''';

      final report = SyncChangelog.checkDrift(
        sdkMarkdown: sdkMarkdown,
        siteYaml: siteYaml,
        targetVersion: '3.14.0',
      );
      expect(report.hasDrift, isTrue);
      expect(report.versionMissing, isFalse);
      expect(
        report.missingIssueUrls,
        unorderedEquals([
          'https://github.com/dart-lang/sdk/issues/63811',
          'https://github.com/dart-lang/pub/issues/4674',
        ]),
      );
      expect(report.missingSections, ['Tools / Pub']);
    });
  });
}
