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
  });
}
