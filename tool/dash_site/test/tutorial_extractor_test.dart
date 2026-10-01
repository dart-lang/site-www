// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dash_site/src/tutorial/tutorial_extractor.dart';
import 'package:dash_site/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('TutorialExtractor', () {
    late List<TutorialChapterSnapshot> chapters;

    setUpAll(() {
      final extractor = TutorialExtractor(repositoryRoot: repositoryRoot);
      chapters = extractor.extractChapters();
    });

    test('extracts all 13 tutorial chapters in tutorial.yml order', () {
      expect(chapters, hasLength(13));
      expect(chapters.first.index, 1);
      expect(chapters.first.id, 'first-app');
      expect(chapters.last.index, 13);
      expect(chapters.last.id, 'logging');
    });

    test(
      'progressively scaffolds cli, command_runner, and wikipedia packages',
      () {
        // Chapter 1: only `cli` exists.
        expect(chapters[0].createdPackages, {'cli'});
        expect(
          chapters[0].workspaceFiles['cli/bin/cli.dart'],
          allOf(
            contains("print('Hello, Dart!');"),
            isNot(contains('package:cli/cli.dart')),
          ),
        );

        // Chapter 4 (`packages-libs`): `command_runner` added.
        final packagesLibs = chapters.firstWhere(
          (c) => c.id == 'packages-libs',
        );
        expect(packagesLibs.createdPackages, {'cli', 'command_runner'});
        expect(
          packagesLibs.workspaceFiles.keys,
          containsAll([
            'command_runner/lib/command_runner.dart',
            'command_runner/lib/src/command_runner_base.dart',
          ]),
        );

        // Chapter 10 (`data-and-json`): `wikipedia` and workspace root added.
        final dataAndJson = chapters.firstWhere((c) => c.id == 'data-and-json');
        expect(dataAndJson.createdPackages, {
          'cli',
          'command_runner',
          'wikipedia',
        });
        expect(
          dataAndJson.workspaceFiles.keys,
          containsAll([
            'pubspec.yaml',
            'wikipedia/lib/src/model/summary.dart',
            'wikipedia/lib/src/model/title_set.dart',
            'wikipedia/lib/src/model/article.dart',
            'wikipedia/lib/src/model/search_results.dart',
          ]),
        );
      },
    );

    test('incrementally merges class and enum members across steps', () {
      // Chapter 6 (`inheritance`): `Command` and `ArgResults` in arguments.dart.
      final inheritance = chapters.firstWhere((c) => c.id == 'inheritance');
      final argumentsCode =
          inheritance.workspaceFiles['command_runner/lib/src/arguments.dart']!;
      expect(argumentsCode, contains('abstract class CliElement'));
      expect(argumentsCode, contains('class Option extends CliElement'));
      expect(
        argumentsCode,
        contains('abstract class Command extends CliElement'),
      );
      expect(argumentsCode, contains('void addFlag('));
      expect(argumentsCode, contains('void addOption('));
      expect(
        argumentsCode,
        contains('FutureOr<Object?> run(ArgResults args);'),
      );
      expect(argumentsCode, contains('Command? command;'));
      expect(argumentsCode, contains('bool flag(String name)'));

      // Chapter 8 (`advanced-oop`): `ConsoleColor` enum and `TextRenderUtils` extension.
      final advancedOop = chapters.firstWhere((c) => c.id == 'advanced-oop');
      final consoleCode =
          advancedOop.workspaceFiles['command_runner/lib/src/console.dart']!;
      expect(consoleCode, contains('enum ConsoleColor'));
      expect(consoleCode, contains('lightBlue(184, 234, 254)'));
      expect(consoleCode, contains('String applyForeground(String text)'));
      expect(consoleCode, contains('extension TextRenderUtils on String'));

      // Chapter 9 (`cli-polish`): `CommandRunner` has `onOutput`, `onError`, and `parse`.
      final cliPolish = chapters.firstWhere((c) => c.id == 'cli-polish');
      final runnerBaseCode = cliPolish
          .workspaceFiles['command_runner/lib/src/command_runner_base.dart']!;
      expect(
        runnerBaseCode,
        contains('CommandRunner({this.onOutput, this.onError});'),
      );
      expect(runnerBaseCode, contains('ArgResults parse(List<String> input)'));
      expect(runnerBaseCode, contains('String _removeDash(String input)'));
    });

    test('verifies no untagged code blocks exist inside Tasks sections', () {
      for (final chapter in chapters) {
        expect(
          chapter.untaggedTaskSnippets,
          isEmpty,
          reason:
              'Chapter ${chapter.id} has untagged code block(s) in ## Tasks',
        );
      }
    });

    test('flags untagged dart/yaml blocks inside ## Tasks while ignoring intro and skip="true" blocks', () {
      final extractor = TutorialExtractor(repositoryRoot: repositoryRoot);
      const sampleMarkdown = '''
# Sample Chapter

```dart
// Conceptual block before Tasks - should be ignored.
final x = 1;
```

## Tasks

```dart title="cli/bin/cli.dart"
void main() {}
```

```dart
// Untagged block inside Tasks - should be flagged!
void forgottenTitle() {}
```

```dart skip="true"
// Explicitly opted-out block - should be ignored.
void skippedExample() {}
```

## Summary

```dart
// Block after Tasks - should be ignored.
void summaryExample() {}
```
''';
      final parsed = extractor.extractBlocksFromMarkdown(sampleMarkdown);
      expect(parsed.titledSnippets, hasLength(1));
      expect(parsed.titledSnippets.first.filePath, 'cli/bin/cli.dart');
      expect(parsed.untaggedTaskSnippets, hasLength(1));
      expect(parsed.untaggedTaskSnippets.first.language, 'dart');
      expect(
        parsed.untaggedTaskSnippets.first.codePreview,
        '// Untagged block inside Tasks - should be flagged!',
      );
    });

    test('produces serializable JSON snapshots with per-step assembledFileContent', () {
      for (final chapter in chapters) {
        final json = chapter.toJson();
        expect(json['index'], chapter.index);
        expect(json['id'], chapter.id);
        expect(json['snippets'], isNotEmpty);
        expect(json['workspaceFiles'], isA<Map<String, String>>());
        for (final snippet in chapter.snippets) {
          expect(
            snippet.assembledFileContent,
            isNotNull,
            reason:
                'Snippet at ${chapter.id}:${snippet.lineNumber} missing assembledFileContent',
          );
          expect(
            snippet.toJson()['assembledFileContent'],
            equals(snippet.assembledFileContent),
          );
        }
      }
    });
  });
}
