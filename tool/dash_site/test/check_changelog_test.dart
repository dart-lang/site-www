// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dash_site/src/commands/check_changelog.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('CheckChangelogCommand.validateChangelogYaml', () {
    test('accepts the repository src/data/changelog.yml', () {
      var changelogFile = File(p.join('src', 'data', 'changelog.yml'));
      if (!changelogFile.existsSync()) {
        changelogFile = File(
          p.join('..', '..', 'src', 'data', 'changelog.yml'),
        );
      }
      expect(changelogFile.existsSync(), isTrue);
      expect(
        CheckChangelogCommand.validateChangelogYaml(
          changelogFile.readAsStringSync(),
        ),
        isEmpty,
      );
    });

    test(
      'accepts valid entries with code-block brackets and resolved refs',
      () {
        const yaml = '''
- version: 3.14.0
  releaseDate: 2026-11-11
  area: Language
  subArea: Primary constructors
  description: |
    Use `matrix[0][1]` safely and read the [spec][pc-spec].

    ```dart
    final value = grid[0][1];
    ```

    [pc-spec]: https://dart.dev/language/primary-constructors
  tags:
    - new
    - versioned
  link: /language/primary-constructors
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Tools
  subArea: Pub
  description: Fixed workspace resolution.
  tags:
    - fixed
  link: https://github.com/dart-lang/pub/issues/4674
''';

        expect(CheckChangelogCommand.validateChangelogYaml(yaml), isEmpty);
      },
    );

    test('flags invalid schema, area, tag, date, and link fields', () {
      const yaml = '''
- version: not-a-version
  releaseDate: TBD
  area: UnknownArea
  description: Missing concrete metadata.
  tags:
    - made_up_tag
    - new
    - new
  link: ftp://example.com/bad
- version: 3.14.0
  releaseDate: 2026-02-30
  area: Language
  description: Impossible calendar date.
  tags:
    - new
''';

      final errors = CheckChangelogCommand.validateChangelogYaml(yaml);
      expect(
        errors,
        allOf(
          contains(contains('invalid SemVer version "not-a-version"')),
          contains(contains('invalid releaseDate "TBD"')),
          contains(contains('invalid area "UnknownArea"')),
          contains(contains('unknown tag "made_up_tag"')),
          contains(contains('duplicate tag "new"')),
          contains(contains('invalid link "ftp://example.com/bad"')),
          contains(contains('invalid releaseDate "2026-02-30"')),
        ),
      );
    });

    test('flags non-monotonic SemVer ordering', () {
      const yaml = '''
- version: 3.12.0
  releaseDate: 2026-05-06
  area: Language
  description: Older entry placed first.
  tags:
    - new
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Language
  description: Newer entry placed second.
  tags:
    - new
''';

      final errors = CheckChangelogCommand.validateChangelogYaml(yaml);
      expect(
        errors,
        contains(contains('breaks monotonic descending SemVer ordering')),
      );
    });

    test('flags conflicting releaseDates within the same version', () {
      const yaml = '''
- version: 2.0.0
  releaseDate: 2018-08-07
  area: Language
  description: Sound type system.
  tags:
    - breaking
- version: 2.0.0
  releaseDate: 2018-02-22
  area: SDK
  description: Conflicting beta release date.
  tags:
    - changed
''';

      final errors = CheckChangelogCommand.validateChangelogYaml(yaml);
      expect(
        errors,
        contains(contains('conflicting releaseDate "2018-02-22"')),
      );
    });

    test('flags duplicate entry fingerprints', () {
      const yaml = '''
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Tools
  subArea: Pub
  description: |
    Fix workspace resolution.
  tags:
    - fixed
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Tools
  subArea: Pub
  description: Fix   workspace   resolution.
  tags:
    - fixed
''';

      final errors = CheckChangelogCommand.validateChangelogYaml(yaml);
      expect(errors, contains(contains('duplicates entry #1')));
    });

    test('flags unresolved Markdown reference links outside code blocks', () {
      const yaml = '''
- version: 3.13.0
  releaseDate: 2026-08-12
  area: Tools
  subArea: "Analyzer [#99999][]"
  description: See [dart-lang/sdk#12345][] for details.
  tags:
    - fixed
''';

      final errors = CheckChangelogCommand.validateChangelogYaml(yaml);
      expect(
        errors,
        allOf(
          contains(
            contains(
              'unresolved Markdown reference link "[dart-lang/sdk#12345][]"',
            ),
          ),
          contains(contains('unresolved Markdown reference link "[#99999][]"')),
        ),
      );
    });
  });
}
