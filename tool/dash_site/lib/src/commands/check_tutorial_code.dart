// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import '../tutorial/tutorial_extractor.dart';
import '../utils.dart';

/// Validates that all code snippets across the 13-chapter Dartpedia tutorial
/// (`src/content/learn/tutorial/*.md`) assemble into valid, compilable Dart
/// packages at every chapter boundary.
///
/// Unlike standalone code samples in `examples/` (which only test a single,
/// final version of each file), the Dartpedia tutorial is a progressive build
/// where readers start with `dart create cli` in Chapter 1 and iteratively
/// modify the same files across 13 chapters. Validating each chapter in
/// sequence catches broken imports, missing methods, or type errors that would
/// otherwise be hidden by later chapters.
///
/// Chapters are materialized sequentially inside a single temporary directory
/// (`Directory.systemTemp`) so `.dart_tool/` and resolved dependencies carry
/// over between chapters and `dart pub get` only runs when a `pubspec.yaml`
/// file changes.
final class CheckTutorialCodeCommand extends Command<int> {
  static const String _verboseFlag = 'verbose';
  static const String _chapterOption = 'chapter';
  static const String _exportJsonOption = 'export-json';

  CheckTutorialCodeCommand() {
    argParser.addFlag(
      _verboseFlag,
      abbr: 'v',
      defaultsTo: false,
      help: 'Show verbose logging for each chapter and file.',
    );
    argParser.addOption(
      _chapterOption,
      abbr: 'c',
      // 1-based to match user-facing chapter numbers (Chapters 1–13) and
      // exported snapshot filenames (`chapter_01_...` through `chapter_13_...`).
      help: 'Validate a specific chapter by 1-based chapter number or slug ID.',
    );
    argParser.addOption(
      _exportJsonOption,
      help:
          'Export extracted chapter workspace snapshots as JSON files to the '
          'specified directory (for Phase 2 interactive / DartPad mode).',
    );
  }

  @override
  String get description =>
      'Extract and validate code snippets across all Dartpedia tutorial chapters.';

  @override
  String get name => 'check-tutorial-code';

  @override
  List<String> get aliases => const ['check_tutorial_code'];

  @override
  Future<int> run() async {
    final verbose = argResults.get<bool>(_verboseFlag, false);
    final chapterFilter = argResults?[_chapterOption] as String?;
    final exportJsonDir = argResults?[_exportJsonOption] as String?;

    final extractor = TutorialExtractor(repositoryRoot: repositoryRoot);
    final chapters = extractor.extractChapters();

    if (exportJsonDir != null) {
      _exportChapterSnapshotsJson(chapters, exportJsonDir, verbose: verbose);
    }

    final chaptersToValidate = _filterChapters(chapters, chapterFilter);
    if (chaptersToValidate.isEmpty) {
      stderr.writeln('Error: No tutorial chapter matched "$chapterFilter".');
      return 1;
    }

    stdout.writeln(
      'Validating ${chaptersToValidate.length} tutorial '
      '${chaptersToValidate.length == 1 ? 'chapter' : 'chapters'}...',
    );

    final tempWorkspace = Directory.systemTemp.createTempSync(
      'dartpedia_tutorial_check_',
    );

    try {
      final previousPubspecs = <String, String>{};
      var hasFailures = false;

      for (final chapter in chaptersToValidate) {
        if (verbose) {
          stdout.writeln(
            '\n--- Chapter ${chapter.index}: ${chapter.id} '
            '(${chapter.title}) ---',
          );
        } else {
          stdout.write(
            '  [Chapter ${chapter.index}/${chapters.length}] '
            '${chapter.id}... ',
          );
        }

        // Fail if any Dart or YAML block inside `## Tasks` is missing a
        // `title="..."` attribute. Without a title, the extractor cannot know
        // which file the snippet belongs to and would silently skip it,
        // allowing broken tutorial code to pass CI unnoticed.
        if (chapter.untaggedTaskSnippets.isNotEmpty) {
          hasFailures = true;
          if (!verbose) {
            stdout.writeln('FAILED (untagged code blocks)');
          }
          for (final untagged in chapter.untaggedTaskSnippets) {
            stderr.writeln(
              '  ${chapter.markdownPath}:${untagged.lineNumber}: '
              '```${untagged.language} block inside "## Tasks" is missing a '
              'title="..." attribute (or skip="true"). '
              'Preview: ${untagged.codePreview}',
            );
          }
          continue;
        }

        // Write the chapter's cumulative files into the temporary workspace and
        // track whether any `pubspec.yaml` changed since the previous chapter
        // so we only run `dart pub get` when dependencies actually change.
        final changedPubspecDirs = <String>{};
        for (final entry in chapter.workspaceFiles.entries) {
          final relPath = entry.key;
          final content = entry.value;
          final fullPath = path.join(tempWorkspace.path, relPath);
          final file = File(fullPath);
          file.parent.createSync(recursive: true);
          file.writeAsStringSync(content);

          if (path.basename(relPath) == 'pubspec.yaml') {
            if (previousPubspecs[relPath] != content) {
              previousPubspecs[relPath] = content;
              final pkgDir = path.dirname(relPath);
              changedPubspecDirs.add(pkgDir == '.' ? '' : pkgDir);
            }
          }
        }

        // Once Chapter 10 (`data-and-json`) introduces a root `pubspec.yaml`
        // with `workspace: [cli, command_runner, wikipedia]`, a single
        // `dart pub get` at the workspace root resolves all member packages.
        // In earlier chapters (Chapters 1–9), packages are standalone and must
        // be resolved in their individual directories.
        if (changedPubspecDirs.isNotEmpty) {
          final hasRootWorkspace = chapter.workspaceFiles.containsKey(
            'pubspec.yaml',
          );
          if (hasRootWorkspace) {
            if (!_runPubGet(tempWorkspace.path, verbose: verbose)) {
              hasFailures = true;
              break;
            }
          } else {
            for (final pkg in changedPubspecDirs) {
              final pkgPath = pkg.isEmpty
                  ? tempWorkspace.path
                  : path.join(tempWorkspace.path, pkg);
              if (!_runPubGet(pkgPath, verbose: verbose)) {
                hasFailures = true;
                break;
              }
            }
            if (hasFailures) break;
          }
        }

        final analyzePassed = _analyzeChapter(
          tempWorkspace.path,
          chapter,
          verbose: verbose,
        );
        if (!analyzePassed) {
          hasFailures = true;
          if (!verbose) {
            stdout.writeln('FAILED (analysis)');
          }
          continue;
        }

        if (chapter.hasTests) {
          final testPassed = _testChapter(
            tempWorkspace.path,
            chapter,
            verbose: verbose,
          );
          if (!testPassed) {
            hasFailures = true;
            if (!verbose) {
              stdout.writeln('FAILED (tests)');
            }
            continue;
          }
        }

        if (!verbose) {
          stdout.writeln('OK (${chapter.snippets.length} snippets)');
        }
      }

      if (hasFailures) {
        stderr.writeln('\nError: Tutorial code validation failed.');
        return 1;
      }

      stdout.writeln('\nAll tutorial chapters compiled and passed validation!');
      return 0;
    } finally {
      try {
        tempWorkspace.deleteSync(recursive: true);
      } catch (_) {}
    }
  }

  List<TutorialChapterSnapshot> _filterChapters(
    List<TutorialChapterSnapshot> chapters,
    String? filter,
  ) {
    if (filter == null || filter.trim().isEmpty) {
      return chapters;
    }
    final trimmed = filter.trim();
    final asInt = int.tryParse(trimmed);
    return chapters
        .where((c) => c.id == trimmed || (asInt != null && c.index == asInt))
        .toList();
  }

  bool _runPubGet(String workingDirectory, {required bool verbose}) {
    if (verbose) {
      stdout.writeln('  Running `dart pub get` in $workingDirectory...');
    }
    // Try `--offline` first so local runs use the local pub cache without
    // network latency (and succeed in sandboxed/offline environments). Fall
    // back to online `dart pub get` when the cache is cold (such as in CI).
    var result = Process.runSync(Platform.executable, const [
      'pub',
      'get',
      '--offline',
    ], workingDirectory: workingDirectory);
    if (result.exitCode != 0) {
      result = Process.runSync(Platform.executable, const [
        'pub',
        'get',
      ], workingDirectory: workingDirectory);
    }
    if (result.exitCode != 0) {
      stderr.writeln('\n`dart pub get` failed in $workingDirectory:');
      stderr.write(result.stdout);
      stderr.write(result.stderr);
      return false;
    }
    return true;
  }

  bool _analyzeChapter(
    String workspacePath,
    TutorialChapterSnapshot chapter, {
    required bool verbose,
  }) {
    final hasRootWorkspace = chapter.workspaceFiles.containsKey('pubspec.yaml');
    final dirsToAnalyze = hasRootWorkspace
        ? <String>[workspacePath]
        : [
            for (final pkg in chapter.createdPackages)
              path.join(workspacePath, pkg),
          ];

    for (final dir in dirsToAnalyze) {
      // Pass `--no-fatal-warnings` because intermediate refactoring chapters
      // (such as Chapter 4 `packages-libs.md`) intentionally leave `dart:io`
      // and `package:http` imports in `cli/bin/cli.dart` that are not wired up
      // again until later chapters. Compile errors still fail with a non-zero
      // exit code, while transitional `unused_import` warnings are tolerated.
      final result = Process.runSync(Platform.executable, const [
        'analyze',
        '--no-fatal-warnings',
      ], workingDirectory: dir);
      if (result.exitCode != 0) {
        stderr.writeln(
          '\nAnalysis failed in Chapter ${chapter.index} (${chapter.id}) '
          '[${chapter.markdownPath}]:',
        );
        stderr.write(result.stdout);
        stderr.write(result.stderr);
        return false;
      }
      if (verbose) {
        stdout.writeln('  Analyzed ${path.basename(dir)}: OK');
      }
    }
    return true;
  }

  bool _testChapter(
    String workspacePath,
    TutorialChapterSnapshot chapter, {
    required bool verbose,
  }) {
    // Run `dart test` in each individual package that has a `test/` directory
    // rather than at the workspace root, because `dart test` fails if invoked
    // on a workspace member package that has no `test/` directory.
    final dirsToTest = <String>[
      for (final pkg in chapter.createdPackages)
        if (Directory(path.join(workspacePath, pkg, 'test')).existsSync())
          path.join(workspacePath, pkg),
    ];

    for (final dir in dirsToTest) {
      final result = Process.runSync(Platform.executable, const [
        'test',
      ], workingDirectory: dir);
      if (result.exitCode != 0) {
        stderr.writeln(
          '\nTests failed in Chapter ${chapter.index} (${chapter.id}) '
          '[${chapter.markdownPath}]:',
        );
        stderr.write(result.stdout);
        stderr.write(result.stderr);
        return false;
      }
      if (verbose) {
        stdout.writeln('  Ran `dart test` in ${path.basename(dir)}: OK');
      }
    }
    return true;
  }

  void _exportChapterSnapshotsJson(
    List<TutorialChapterSnapshot> chapters,
    String outputDirPath, {
    required bool verbose,
  }) {
    final outDir = Directory(outputDirPath);
    outDir.createSync(recursive: true);

    const encoder = JsonEncoder.withIndent('  ');
    for (final chapter in chapters) {
      final paddedIndex = chapter.index.toString().padLeft(2, '0');
      final file = File(
        path.join(outDir.path, 'chapter_${paddedIndex}_${chapter.id}.json'),
      );
      file.writeAsStringSync('${encoder.convert(chapter.toJson())}\n');
    }

    final indexFile = File(path.join(outDir.path, 'index.json'));
    final indexPayload = <String, Object?>{
      'tutorial': 'dartpedia',
      'chapterCount': chapters.length,
      'chapters': [
        for (final c in chapters)
          <String, Object?>{
            'index': c.index,
            'id': c.id,
            'title': c.title,
            'markdownPath': c.markdownPath,
            'snapshotFile':
                'chapter_${c.index.toString().padLeft(2, '0')}_${c.id}.json',
          },
      ],
    };
    indexFile.writeAsStringSync('${encoder.convert(indexPayload)}\n');

    if (verbose) {
      stdout.writeln(
        'Exported ${chapters.length} chapter snapshots to ${outDir.path}.',
      );
    }
  }
}
