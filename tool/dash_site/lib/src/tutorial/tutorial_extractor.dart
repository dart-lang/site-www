// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Represents a single fenced code block extracted from a tutorial chapter.
final class TutorialCodeSnippet {
  TutorialCodeSnippet({
    required this.language,
    required this.filePath,
    required this.code,
    required this.lineNumber,
    this.attributes = const {},
    this.assembledFileContent,
  });

  final String language;
  final String filePath;
  final String code;
  final int lineNumber;
  final Map<String, String> attributes;

  /// The full merged content of [filePath] immediately after applying this
  /// snippet.
  ///
  /// A single tutorial chapter often modifies the same file across multiple
  /// tasks. Recording the merged file state after each individual snippet lets
  /// Phase 2 interactive / DartPad mode show the exact compilable file state at
  /// any step within a chapter, not just at the end of the chapter.
  final String? assembledFileContent;

  TutorialCodeSnippet withAssembledContent(String? content) =>
      TutorialCodeSnippet(
        language: language,
        filePath: filePath,
        code: code,
        lineNumber: lineNumber,
        attributes: attributes,
        assembledFileContent: content,
      );

  Map<String, Object?> toJson() => {
    'language': language,
    'filePath': filePath,
    'lineNumber': lineNumber,
    if (attributes.isNotEmpty) 'attributes': attributes,
    'code': code,
    if (assembledFileContent != null)
      'assembledFileContent': assembledFileContent,
  };
}

/// Represents a code block inside a chapter's `## Tasks` section that is
/// missing a `title="..."` attribute (and does not specify `skip="true"`).
final class UntaggedTutorialSnippet {
  UntaggedTutorialSnippet({
    required this.language,
    required this.lineNumber,
    required this.codePreview,
  });

  final String language;
  final int lineNumber;
  final String codePreview;
}

/// Represents a parsed tutorial chapter and its cumulative workspace snapshot.
final class TutorialChapterSnapshot {
  TutorialChapterSnapshot({
    required this.index,
    required this.id,
    required this.title,
    required this.markdownPath,
    required this.snippets,
    required this.workspaceFiles,
    required this.createdPackages,
    required this.hasTests,
    this.untaggedTaskSnippets = const [],
  });

  /// 1-based chapter number (1 to 13), matching the human-readable chapter
  /// numbering in the tutorial UI and exported JSON filenames.
  final int index;

  /// Chapter slug ID (for example, `first-app` or `inheritance`).
  final String id;

  /// Human-readable chapter title from `tutorial.yml`.
  final String title;

  /// Path to the source Markdown file relative to the repository root.
  final String markdownPath;

  /// Code snippets with `title="..."` extracted from this chapter.
  final List<TutorialCodeSnippet> snippets;

  /// Cumulative workspace file map (`relativePath -> fileContent`) at the end
  /// of this chapter, suitable for materializing on disk or exporting to
  /// Phase 2 interactive / DartPad mode.
  final Map<String, String> workspaceFiles;

  /// Packages that exist by the end of this chapter (`cli`, `command_runner`,
  /// `wikipedia`).
  final Set<String> createdPackages;

  /// Whether this chapter includes runnable package tests.
  final bool hasTests;

  /// Any `dart` or `yaml` code blocks in the `## Tasks` section that are
  /// missing a `title="..."` attribute.
  final List<UntaggedTutorialSnippet> untaggedTaskSnippets;

  Map<String, Object?> toJson() => {
    'index': index,
    'id': id,
    'title': title,
    'markdownPath': markdownPath,
    'createdPackages': createdPackages.toList()..sort(),
    'hasTests': hasTests,
    'snippets': [for (final s in snippets) s.toJson()],
    'workspaceFiles': workspaceFiles,
  };
}

/// Extracts code blocks from `src/content/learn/tutorial/*.md` and assembles
/// cumulative project snapshots for each chapter in `src/data/tutorial.yml`.
///
/// To keep tutorial prose concise and readable, chapters frequently display
/// *partial* snippets—for example, a class definition with `// ...` and only
/// the newly added methods, a bare method without its enclosing class, or a
/// `pubspec.yaml` excerpt showing only a new `dependencies:` entry. A reader
/// following the tutorial merges these edits into the files they created in
/// earlier chapters. [TutorialExtractor] and [_WorkspaceBuilder] replicate
/// those incremental edits so each chapter produces a complete, compilable
/// workspace snapshot.
final class TutorialExtractor {
  TutorialExtractor({required this.repositoryRoot});

  final String repositoryRoot;

  static final RegExp _fenceStartPattern = RegExp(r'^(\s*)```(\w+)(.*)$');
  static final RegExp _attributePattern = RegExp(r'(\w+)=(?:"([^"]*)"|(\S+))');

  /// Loads the ordered list of tutorial chapters from `src/data/tutorial.yml`
  /// and builds cumulative workspace snapshots from Chapter 1 through the last
  /// chapter.
  List<TutorialChapterSnapshot> extractChapters() {
    final tutorialYamlPath = path.join(
      repositoryRoot,
      'src',
      'data',
      'tutorial.yml',
    );
    final tutorialYamlFile = File(tutorialYamlPath);
    if (!tutorialYamlFile.existsSync()) {
      throw StateError('Could not find tutorial data file: $tutorialYamlPath');
    }

    // Read chapter order from `tutorial.yml` rather than sorting filenames so
    // the workspace state evolves in the exact sequence a reader follows.
    final yamlDoc = loadYaml(tutorialYamlFile.readAsStringSync()) as YamlMap;
    final units = yamlDoc['units'] as YamlList;
    final chaptersList = <({String id, String title, String mdPath})>[];

    for (final unit in units.cast<YamlMap>()) {
      final chapters = unit['chapters'] as YamlList?;
      if (chapters == null) continue;
      for (final chapter in chapters.cast<YamlMap>()) {
        final url = chapter['url'] as String;
        final title = chapter['title'] as String;
        final id = url.split('/').last;
        final mdPath = path.join(
          'src',
          'content',
          'learn',
          'tutorial',
          '$id.md',
        );
        chaptersList.add((id: id, title: title, mdPath: mdPath));
      }
    }

    final state = _WorkspaceBuilder();
    final snapshots = <TutorialChapterSnapshot>[];

    for (var i = 0; i < chaptersList.length; i++) {
      final chapterMeta = chaptersList[i];
      final chapterNumber = i + 1;
      final fullMdPath = path.join(repositoryRoot, chapterMeta.mdPath);
      final mdFile = File(fullMdPath);
      if (!mdFile.existsSync()) {
        throw StateError('Missing tutorial markdown file: $fullMdPath');
      }

      final markdownContent = mdFile.readAsStringSync();
      final extracted = extractBlocksFromMarkdown(markdownContent);

      // Replay `dart create` commands from bash blocks so each package's
      // baseline `pubspec.yaml` exists before subsequent tasks edit it.
      for (final bashBlock in extracted.bashBlocks) {
        if (bashBlock.contains('dart create cli')) {
          state.initCliPackage();
        }
        if (bashBlock.contains('dart create -t package command_runner')) {
          state.initCommandRunnerPackage();
        }
        if (bashBlock.contains('dart create wikipedia')) {
          state.initWikipediaPackage();
        }
      }

      final assembledSnippets = <TutorialCodeSnippet>[];
      for (final snippet in extracted.titledSnippets) {
        state.applySnippet(snippet);
        assembledSnippets.add(
          snippet.withAssembledContent(state.files[snippet.filePath]),
        );
      }

      // In `testing.md`, the tutorial instructs readers to download
      // `cat_extract.json` from an external GitHub gist because the full
      // Wikipedia API payload is too large to inline in Markdown. We synthesize
      // a minimal valid fixture so `dart test` can run offline in CI.
      if (chapterMeta.id == 'testing') {
        state.ensureCatExtractJsonFixture();
      }

      snapshots.add(
        TutorialChapterSnapshot(
          index: chapterNumber,
          id: chapterMeta.id,
          title: chapterMeta.title,
          markdownPath: chapterMeta.mdPath,
          snippets: List<TutorialCodeSnippet>.unmodifiable(assembledSnippets),
          workspaceFiles: Map<String, String>.unmodifiable(
            Map<String, String>.fromEntries(
              state.files.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key)),
            ),
          ),
          createdPackages: Set<String>.unmodifiable(state.packages),
          hasTests: state.files.keys.any(
            (k) => path.split(k).contains('test') && k.endsWith('_test.dart'),
          ),
          untaggedTaskSnippets: List<UntaggedTutorialSnippet>.unmodifiable(
            extracted.untaggedTaskSnippets,
          ),
        ),
      );
    }

    return snapshots;
  }

  /// Parses fenced code blocks from a single chapter's [markdown] source.
  ({
    List<TutorialCodeSnippet> titledSnippets,
    List<String> bashBlocks,
    List<UntaggedTutorialSnippet> untaggedTaskSnippets,
  })
  extractBlocksFromMarkdown(String markdown) {
    final lines = markdown.split('\n');
    final titledSnippets = <TutorialCodeSnippet>[];
    final bashBlocks = <String>[];
    final untaggedTaskSnippets = <UntaggedTutorialSnippet>[];

    // Track whether the parser is inside `## Tasks`. Code blocks before
    // `## Tasks` are conceptual illustrations (for example, explaining JSON
    // decoding syntax) and intentionally omit `title="..."`, whereas code
    // blocks inside `## Tasks` represent actual project edits that must
    // specify a target file path.
    var inTasksSection = false;
    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      final trimmedLine = line.trim();

      if (trimmedLine.startsWith('## ')) {
        inTasksSection = trimmedLine == '## Tasks';
      }

      // Ignore `/// ```dart` fences inside Dart doc comments (such as in
      // `error-handling.md`) so they aren't mistaken for top-level Markdown
      // code blocks.
      if (line.trimLeft().startsWith('///')) {
        i++;
        continue;
      }

      final match = _fenceStartPattern.firstMatch(line);
      if (match == null) {
        i++;
        continue;
      }

      final indent = match.group(1)!;
      final language = match.group(2)!;
      final infoRest = match.group(3)!.trim();
      final startLine = i + 1;

      final attrs = <String, String>{};
      for (final attrMatch in _attributePattern.allMatches(infoRest)) {
        final key = attrMatch.group(1)!;
        final value = attrMatch.group(2) ?? attrMatch.group(3) ?? '';
        attrs[key] = value;
      }

      i++;
      final codeLines = <String>[];
      final closePrefix = '$indent```';
      while (i < lines.length) {
        final currentLine = lines[i];
        // Don't treat a `/// ``` ` line inside a Dart doc comment as the
        // closing fence of the surrounding Markdown code block.
        if (currentLine.trimRight() == closePrefix.trimRight() ||
            (currentLine.trim() == '```' &&
                !currentLine.trimLeft().startsWith('///'))) {
          break;
        }
        if (currentLine.startsWith(indent)) {
          codeLines.add(currentLine.substring(indent.length));
        } else if (currentLine.trim().isEmpty) {
          codeLines.add('');
        } else {
          codeLines.add(currentLine);
        }
        i++;
      }

      final code = codeLines.join('\n').trim();
      if (language == 'bash') {
        bashBlocks.add(code);
      } else if (attrs.containsKey('title')) {
        final rawTitle = attrs['title']!;
        final normalizedPath = _normalizeFilePath(rawTitle);
        titledSnippets.add(
          TutorialCodeSnippet(
            language: language,
            filePath: normalizedPath,
            code: code,
            lineNumber: startLine,
            attributes: Map<String, String>.unmodifiable(
              Map<String, String>.from(attrs)..remove('title'),
            ),
          ),
        );
      } else if (inTasksSection &&
          (language == 'dart' || language == 'yaml') &&
          attrs['skip'] != 'true') {
        final firstNonEmpty = codeLines
            .map((l) => l.trim())
            .firstWhere((l) => l.isNotEmpty, orElse: () => '');
        untaggedTaskSnippets.add(
          UntaggedTutorialSnippet(
            language: language,
            lineNumber: startLine,
            codePreview: firstNonEmpty,
          ),
        );
      }

      i++;
    }

    return (
      titledSnippets: titledSnippets,
      bashBlocks: bashBlocks,
      untaggedTaskSnippets: untaggedTaskSnippets,
    );
  }

  /// Normalizes code block `title` paths so they are always relative to the
  /// multi-package `dartpedia` workspace root.
  ///
  /// In Chapter 1 (`first-app.md`), the reader has only created the `cli`
  /// package and is working inside `cli/`, so the code block title is written
  /// as `bin/cli.dart`. From Chapter 2 onward, paths are written relative to
  /// the parent directory (`cli/bin/cli.dart`). Prefixing bare `bin/` and
  /// `example/` paths ensures edits across chapters target the same file entry.
  static String _normalizeFilePath(String rawPath) {
    final trimmed = rawPath.trim().replaceAll(RegExp(r'^/+'), '');
    if (trimmed.startsWith('bin/')) {
      return 'cli/$trimmed';
    }
    if (trimmed.startsWith('example/')) {
      return 'command_runner/$trimmed';
    }
    return trimmed;
  }
}

/// Maintains the cumulative files of the `dartpedia` workspace across chapters.
final class _WorkspaceBuilder {
  final Map<String, String> files = {};
  final Set<String> packages = {};

  final Map<String, _PubspecModel> _pubspecs = {};
  final Map<String, _DartFileModel> _dartFiles = {};

  /// Scaffolds the initial `cli` package when `dart create cli` is encountered
  /// in Chapter 1.
  ///
  /// Chapter 1 first shows the default `dart create` starter code in
  /// `bin/cli.dart` (which imports `package:cli/cli.dart`) before replacing it.
  /// Seeding `cli/lib/cli.dart` ensures that initial snippet resolves cleanly.
  void initCliPackage() {
    packages.add('cli');
    final pubspec = _pubspecs.putIfAbsent(
      'cli/pubspec.yaml',
      () => _PubspecModel(
        name: 'cli',
        description: 'A sample command-line application.',
        dependencies: {},
        devDependencies: {'lints': '^5.0.0', 'test': '^1.24.0'},
      ),
    );
    files['cli/pubspec.yaml'] = pubspec.render();
    files.putIfAbsent(
      'cli/lib/cli.dart',
      () => 'int calculate() {\n  return 6 * 7;\n}\n',
    );
    files.putIfAbsent(
      'cli/bin/cli.dart',
      () =>
          "import 'package:cli/cli.dart' as cli;\n\n"
          'void main(List<String> arguments) {\n'
          "  print('Hello world: \${cli.calculate()}!');\n"
          '}\n',
    );
  }

  /// Scaffolds `command_runner/pubspec.yaml` when
  /// `dart create -t package command_runner` is encountered.
  ///
  /// Default `dart create` template files under `lib/` and `test/` are omitted
  /// because the tutorial immediately replaces `lib/command_runner.dart` and
  /// `lib/src/command_runner_base.dart` with custom classes, which would break
  /// the default `command_runner_test.dart` (`Awesome.isAwesome`).
  void initCommandRunnerPackage() {
    packages.add('command_runner');
    final pubspec = _pubspecs.putIfAbsent(
      'command_runner/pubspec.yaml',
      () => _PubspecModel(
        name: 'command_runner',
        description: 'A starting point for Dart libraries or applications.',
        dependencies: {},
        devDependencies: {'lints': '^5.0.0', 'test': '^1.24.0'},
      ),
    );
    files['command_runner/pubspec.yaml'] = pubspec.render();
  }

  /// Scaffolds `wikipedia/pubspec.yaml` when `dart create wikipedia` is
  /// encountered.
  ///
  /// The default `test/wikipedia_test.dart` template file is omitted because
  /// Chapter 10 (`data-and-json.md`) creates model files under `lib/src/model/`
  /// without creating `lib/wikipedia.dart` until Chapter 12 (`fetch-data.md`),
  /// and Chapter 11 (`testing.md`) instructs the reader to delete
  /// `wikipedia_test.dart` (`rm wikipedia_test.dart`). Omitting the unused
  /// template file avoids a broken import in Chapter 10 and avoids needing to
  /// delete it in Chapter 11.
  void initWikipediaPackage() {
    packages.add('wikipedia');
    final pubspec = _pubspecs.putIfAbsent(
      'wikipedia/pubspec.yaml',
      () => _PubspecModel(
        name: 'wikipedia',
        description: 'A starting point for Dart libraries or applications.',
        dependencies: {},
        devDependencies: {'lints': '^5.0.0', 'test': '^1.24.0'},
      ),
    );
    files['wikipedia/pubspec.yaml'] = pubspec.render();
  }

  void ensureCatExtractJsonFixture() {
    files.putIfAbsent(
      'wikipedia/test/test_data/cat_extract.json',
      () => '''
{
  "batchcomplete": "",
  "query": {
    "pages": {
      "6678": {
        "pageid": 6678,
        "ns": 0,
        "title": "Cat",
        "extract": "The cat (Felis catus), also referred to as the domestic cat or house cat, is a small domesticated carnivorous mammal."
      }
    }
  }
}
''',
    );
  }

  void applySnippet(TutorialCodeSnippet snippet) {
    final targetPath = snippet.filePath;
    if (snippet.language == 'yaml') {
      _applyYamlSnippet(targetPath, snippet.code);
    } else if (snippet.language == 'json') {
      files[targetPath] = '${snippet.code}\n';
    } else if (snippet.language == 'dart') {
      _applyDartSnippet(targetPath, snippet.code);
    }
  }

  /// Merges a partial or complete `pubspec.yaml` snippet into the package's
  /// [_PubspecModel].
  ///
  /// Tutorial chapters show only the lines being added to `pubspec.yaml` (such
  /// as `resolution: workspace` or a two-line `dependencies:` block with `# ...`
  /// comments), which would not be a valid `pubspec.yaml` on its own.
  void _applyYamlSnippet(String targetPath, String code) {
    if (targetPath == 'pubspec.yaml') {
      // Lower `sdk: ^3.8.1` to `sdk: ^3.8.0` so the root workspace pubspec
      // resolves on any Dart 3.8+ SDK.
      files[targetPath] = '${code.replaceAll('sdk: ^3.8.1', 'sdk: ^3.8.0')}\n';
      return;
    }

    final model = _pubspecs[targetPath];
    if (model == null) {
      files[targetPath] = '$code\n';
      return;
    }

    if (code.contains('publish_to: none')) {
      model.publishToNone = true;
    }
    if (code.contains('resolution: workspace')) {
      model.workspaceResolution = true;
    }

    final cleanedLines = code
        .split('\n')
        .where((line) => !line.trimLeft().startsWith('#'))
        .toList();
    final cleanedYaml = cleanedLines.join('\n');
    try {
      final parsed = loadYaml(cleanedYaml);
      if (parsed is YamlMap) {
        if (parsed['dependencies'] case final YamlMap deps) {
          for (final entry in deps.entries) {
            model.dependencies[entry.key.toString()] = entry.value;
          }
        }
        if (parsed['dev_dependencies'] case final YamlMap devDeps) {
          for (final entry in devDeps.entries) {
            model.devDependencies[entry.key.toString()] = entry.value;
          }
        }
      }
    } catch (_) {
      // Some tutorial YAML snippets include literal `...` placeholders outside
      // comments (for example, when adding `resolution: workspace`). Those
      // flags are already captured by the string checks above.
    }

    files[targetPath] = model.render();
  }

  /// Applies either a full-file replacement or an incremental declaration/member
  /// update to [targetPath].
  void _applyDartSnippet(String targetPath, String rawCode) {
    // Chapter 1 first shows the starter `bin/cli.dart` with a comment
    // `import 'package:cli/cli.dart' as cli; // Delete this entire line` to
    // teach readers what to remove. Remove any such deleted imports from the
    // existing file model as well as filtering them out of the new snippet.
    final existingModel = _dartFiles[targetPath];
    final filteredLines = <String>[];
    for (final line in rawCode.split('\n')) {
      if (line.contains('// Delete this entire line')) {
        final semiIdx = line.indexOf(';');
        if (semiIdx != -1 && existingModel != null) {
          existingModel.imports.remove(line.substring(0, semiIdx + 1).trim());
        }
      } else {
        filteredLines.add(line);
      }
    }
    final code = filteredLines.join('\n').trim();

    // Skip "context/recap" snippets where a function body is abbreviated with
    // `/* ... existing logic ... */` so we don't overwrite the real body from
    // the previous step with an empty comment.
    if (code.contains('/* ... existing logic ... */')) {
      return;
    }

    // Pure barrel files (`library;` + `export ...;`) don't contain declarations
    // to merge and can be written directly.
    if (_isLibraryExportFile(code)) {
      _dartFiles.remove(targetPath);
      files[targetPath] = '$code\n';
      return;
    }

    // A snippet that includes top-level `import`s, defines a top-level
    // entrypoint (`void main`), `class`, or `enum`, and has no `// ...`
    // ellipsis comments is a complete replacement of the file (for example,
    // when `cli/bin/cli.dart` or `help_command.dart` is refactored and shown in
    // full at the end of a task).
    final isCompleteFileReplacement =
        !_hasEllipsisComment(code) &&
        code.contains('import ') &&
        (code.contains('void main') ||
            code.contains('class ') ||
            code.contains('enum '));
    if (isCompleteFileReplacement) {
      final freshModel = _DartFileModel();
      freshModel.mergeSnippet(code);
      _dartFiles[targetPath] = freshModel;
      files[targetPath] = freshModel.render();
      return;
    }

    final fileModel = _dartFiles.putIfAbsent(targetPath, _DartFileModel.new);
    fileModel.mergeSnippet(code);
    files[targetPath] = fileModel.render();
  }

  static bool _isLibraryExportFile(String code) {
    final lines = code
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !l.startsWith('//'))
        .toList();
    return lines.isNotEmpty &&
        lines.every((l) => l == 'library;' || l.startsWith('export '));
  }

  /// Returns true if [code] contains an instructional ellipsis comment such as
  /// `// ...` or `// ... rest of the class ...`, indicating that the snippet
  /// is a partial diff that must be merged with existing declarations rather
  /// than replacing the file.
  static bool _hasEllipsisComment(String code) {
    for (final line in code.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('//') &&
          (trimmed.contains('...') ||
              trimmed.toLowerCase().contains('rest of the'))) {
        return true;
      }
    }
    return false;
  }
}

final class _PubspecModel {
  _PubspecModel({
    required this.name,
    required this.description,
    required this.dependencies,
    required this.devDependencies,
  });

  final String name;
  final String description;
  bool publishToNone = false;
  bool workspaceResolution = false;
  final Map<String, Object?> dependencies;
  final Map<String, Object?> devDependencies;

  String render() {
    final buffer = StringBuffer();
    buffer.writeln('name: $name');
    if (publishToNone) {
      buffer.writeln('publish_to: none');
    }
    buffer.writeln('description: $description');
    buffer.writeln('version: 1.0.0');
    if (workspaceResolution) {
      buffer.writeln('resolution: workspace');
    }
    buffer.writeln();
    buffer.writeln('environment:');
    buffer.writeln('  sdk: ^3.8.0');
    buffer.writeln();
    buffer.writeln('dependencies:');
    if (dependencies.isEmpty) {
      buffer.writeln('  # path: ^1.8.0');
    } else {
      for (final entry in dependencies.entries) {
        final value = entry.value;
        if (value is Map) {
          buffer.writeln('  ${entry.key}:');
          for (final sub in value.entries) {
            buffer.writeln('    ${sub.key}: ${sub.value}');
          }
        } else {
          buffer.writeln('  ${entry.key}: $value');
        }
      }
    }
    buffer.writeln();
    buffer.writeln('dev_dependencies:');
    for (final entry in devDependencies.entries) {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }
}

/// Incrementally merges Dart imports, top-level declarations, and class/enum
/// members across tutorial steps.
///
/// Across the tutorial, a file like `command_runner_base.dart` or
/// `arguments.dart` is built up over 3–6 separate code blocks. Later blocks
/// often show `class CommandRunner { // ... Future<void> run(...) { ... } }`,
/// or even just a bare method `String get usage { ... }` without the enclosing
/// `class` header. Tracking declarations and class members by name allows later
/// snippets to add new methods or overwrite updated methods while preserving
/// fields and methods introduced in earlier steps.
final class _DartFileModel {
  final Set<String> imports = {};
  final Map<String, _DartTopLevelDecl> declarations = {};

  void mergeSnippet(String snippet) {
    final parsed = _parseDartUnits(snippet);
    for (final imp in parsed.imports) {
      // Strip trailing instructional comments (such as `// Add this import`)
      // before deduplicating import directives in the [imports] set.
      final semiIdx = imp.indexOf(';');
      if (semiIdx != -1) {
        imports.add(imp.substring(0, semiIdx + 1).trim());
      } else {
        imports.add(imp.trim());
      }
    }

    for (final unit in parsed.units) {
      if (unit.kind == _DeclKind.classOrEnum) {
        final existing = declarations[unit.name];
        // When a class or enum snippet includes `// ...`, merge its new or
        // updated members into the existing class rather than discarding
        // previously defined fields and methods.
        if (existing != null &&
            existing.kind == _DeclKind.classOrEnum &&
            _WorkspaceBuilder._hasEllipsisComment(unit.code)) {
          existing.mergeClassOrEnumMembers(unit.code);
        } else {
          declarations[unit.name] = unit;
        }
      } else if (unit.kind == _DeclKind.functionOrMethod) {
        // Some tutorial tasks show a single updated method or getter (such as
        // `String get usage { ... }`) without repeating the surrounding
        // `class ... { ... }` wrapper. If the target file defines a single
        // class and has no top-level function with that name, merge the method
        // into that class.
        final singleClass = _singleClassDeclaration();
        if (singleClass != null && !declarations.containsKey(unit.name)) {
          singleClass.mergeSingleMethod(unit.name, unit.code);
        } else {
          declarations[unit.name] = unit;
        }
      } else {
        declarations[unit.name] = unit;
      }
    }
  }

  _DartTopLevelDecl? _singleClassDeclaration() {
    final classes = declarations.values
        .where((d) => d.kind == _DeclKind.classOrEnum && d.isClass)
        .toList();
    if (classes.length == 1) {
      return classes.first;
    }
    return null;
  }

  String render() {
    final buffer = StringBuffer();
    if (imports.isNotEmpty) {
      final dartImports = imports.where((i) => i.contains("'dart:")).toList()
        ..sort();
      final pkgImports = imports.where((i) => i.contains("'package:")).toList()
        ..sort();
      final relImports =
          imports
              .where((i) => !i.contains("'dart:") && !i.contains("'package:"))
              .toList()
            ..sort();

      for (final imp in [...dartImports, ...pkgImports, ...relImports]) {
        buffer.writeln(imp);
      }
      buffer.writeln();
    }

    var first = true;
    for (final decl in declarations.values) {
      if (!first) buffer.writeln();
      buffer.writeln(decl.render());
      first = false;
    }
    return buffer.toString();
  }
}

enum _DeclKind { variable, functionOrMethod, classOrEnum, extensionDecl }

final class _DartTopLevelDecl {
  _DartTopLevelDecl({
    required this.name,
    required this.kind,
    required this.code,
    this.isClass = false,
  }) {
    if (kind == _DeclKind.classOrEnum) {
      _initMembers(code);
    }
  }

  final String name;
  final _DeclKind kind;
  final bool isClass;
  String code;

  String _header = '';
  String _enumConstantsSection = '';
  final Map<String, String> _members = {};

  void _initMembers(String source) {
    final openBrace = source.indexOf('{');
    final closeBrace = source.lastIndexOf('}');
    if (openBrace == -1 || closeBrace == -1 || closeBrace <= openBrace) {
      _header = source;
      return;
    }
    _header = source.substring(0, openBrace + 1);
    final body = source.substring(openBrace + 1, closeBrace);
    _parseBodyIntoMembers(body, isInitial: true);
  }

  void mergeClassOrEnumMembers(String updateSource) {
    final openBrace = updateSource.indexOf('{');
    final closeBrace = updateSource.lastIndexOf('}');
    if (openBrace == -1 || closeBrace == -1 || closeBrace <= openBrace) {
      return;
    }
    _header = updateSource.substring(0, openBrace + 1);
    final body = updateSource.substring(openBrace + 1, closeBrace);
    _parseBodyIntoMembers(body, isInitial: false);
  }

  void mergeSingleMethod(String methodName, String methodSource) {
    final cleanKey = methodName.startsWith('get ')
        ? methodName.substring(4).trim()
        : methodName;
    _members['member:$cleanKey'] = _indentMember(methodSource);
  }

  void _parseBodyIntoMembers(String body, {required bool isInitial}) {
    var workingBody = body;
    if (!isClass && _header.contains('enum ')) {
      // Enhanced enums (such as `ConsoleColor` in `advanced-oop.md`) declare
      // enum values first, terminated by a `;`, followed by fields,
      // constructors, and methods. Splitting on that top-level `;` lets later
      // snippets add methods to the enum without losing the enum values list.
      final semiIdx = _findTopLevelEnumSemicolon(workingBody);
      if (semiIdx != -1) {
        final enumPart = workingBody.substring(0, semiIdx + 1);
        if (isInitial || !_WorkspaceBuilder._hasEllipsisComment(enumPart)) {
          _enumConstantsSection = enumPart.trimRight();
        }
        workingBody = workingBody.substring(semiIdx + 1);
      } else if (isInitial) {
        _enumConstantsSection = workingBody.trimRight();
        return;
      }
    }

    final chunks = _splitTopLevelChunks(workingBody);
    for (final chunk in chunks) {
      final memberName = _identifyMemberName(chunk, className: name);
      if (memberName != null) {
        _members[memberName] = _indentMember(chunk);
      }
    }
  }

  static String _indentMember(String raw) {
    final lines = raw.trim().split('\n');
    return [
      for (final line in lines)
        if (line.trim().isEmpty) '' else '  ${line.trimLeft()}',
    ].join('\n');
  }

  String render() {
    if (kind != _DeclKind.classOrEnum || _header.isEmpty) {
      return code;
    }
    final buffer = StringBuffer();
    buffer.writeln(_header);
    if (_enumConstantsSection.isNotEmpty) {
      // If an enum originally had only enum values (ending without `;`) and a
      // later snippet adds fields or methods, Dart syntax requires a trailing
      // `;` after the enum values list.
      final enumSection =
          _members.isNotEmpty &&
              !_enumConstantsSection.trimRight().endsWith(';')
          ? '${_enumConstantsSection.trimRight()};'
          : _enumConstantsSection;
      buffer.writeln(enumSection);
      if (_members.isNotEmpty) buffer.writeln();
    }
    var first = true;
    for (final member in _members.values) {
      if (!first) buffer.writeln();
      buffer.writeln(member);
      first = false;
    }
    buffer.write('}');
    return buffer.toString();
  }
}

int _findTopLevelEnumSemicolon(String body) {
  var braceDepth = 0;
  var parenDepth = 0;
  final lines = body.split('\n');
  var offset = 0;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.startsWith('//')) {
      offset += line.length + 1;
      continue;
    }
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '{') braceDepth++;
      if (ch == '}') braceDepth--;
      if (ch == '(') parenDepth++;
      if (ch == ')') parenDepth--;
      if (ch == ';' && braceDepth == 0 && parenDepth == 0) {
        // Distinguish the semicolon that terminates the enum values list from
        // a semicolon at the end of a field or constructor declaration when a
        // partial enum snippet omits the enum values with `// ...`.
        if (!trimmed.startsWith('const ') &&
            !trimmed.startsWith('final ') &&
            !trimmed.startsWith('String ') &&
            !trimmed.startsWith('int ') &&
            !trimmed.startsWith('static ')) {
          return offset + i;
        }
      }
    }
    offset += line.length + 1;
  }
  return -1;
}

({List<String> imports, List<_DartTopLevelDecl> units}) _parseDartUnits(
  String source,
) {
  final imports = <String>[];
  final units = <_DartTopLevelDecl>[];

  final chunks = _splitTopLevelChunks(source);
  for (final chunk in chunks) {
    final clean = _stripLeadingComments(chunk).trim();
    if (clean.isEmpty) continue;

    if (clean.startsWith('import ') || clean.startsWith('export ')) {
      for (final line in clean.split('\n')) {
        final t = line.trim();
        if (t.startsWith('import ') || t.startsWith('export ')) {
          imports.add(t);
        }
      }
      continue;
    }

    final classMatch = RegExp(r'^(?:abstract\s+)?(class|enum)\s+(\w+)')
        .firstMatch(clean);
    if (classMatch != null) {
      final isClass = classMatch.group(1) == 'class';
      final name = classMatch.group(2)!;
      units.add(
        _DartTopLevelDecl(
          name: name,
          kind: _DeclKind.classOrEnum,
          code: chunk.trim(),
          isClass: isClass,
        ),
      );
      continue;
    }

    final extMatch = RegExp(r'^extension\s+(\w+)\s+on\s+').firstMatch(clean);
    if (extMatch != null) {
      units.add(
        _DartTopLevelDecl(
          name: extMatch.group(1)!,
          kind: _DeclKind.extensionDecl,
          code: chunk.trim(),
        ),
      );
      continue;
    }

    final varMatch = RegExp(r'^(?:const|final|var)\s+(?:[\w<>?]+\s+)?(\w+)\s*=')
        .firstMatch(clean);
    if (varMatch != null) {
      units.add(
        _DartTopLevelDecl(
          name: varMatch.group(1)!,
          kind: _DeclKind.variable,
          code: chunk.trim(),
        ),
      );
      continue;
    }

    final fnName = _identifyFunctionOrMethodName(clean);
    if (fnName != null) {
      units.add(
        _DartTopLevelDecl(
          name: fnName,
          kind: _DeclKind.functionOrMethod,
          code: chunk.trim(),
        ),
      );
    }
  }

  return (imports: imports, units: units);
}

/// Splits Dart source into top-level or class-level declaration chunks by
/// tracking `{}` and `()` nesting depth.
List<String> _splitTopLevelChunks(String source) {
  final chunks = <String>[];
  final current = <String>[];
  var braceDepth = 0;
  var parenDepth = 0;

  for (final line in source.split('\n')) {
    final trimmed = line.trim();
    if (braceDepth == 0 && parenDepth == 0 && trimmed.isEmpty) {
      if (current.isNotEmpty &&
          !_isOnlyCommentsOrAnnotations(current.join('\n'))) {
        chunks.add(current.join('\n'));
        current.clear();
      }
      continue;
    }

    // Drop standalone placeholder comments like `// ...` or
    // `// Add this code` at depth 0 so they don't get attached to the next
    // declaration chunk or mistaken for an incomplete declaration.
    if (braceDepth == 0 &&
        parenDepth == 0 &&
        trimmed.startsWith('//') &&
        (trimmed.contains('...') ||
            trimmed.toLowerCase().contains('rest of the') ||
            trimmed.toLowerCase().contains('add this code'))) {
      continue;
    }

    current.add(line);
    if (!trimmed.startsWith('//')) {
      final codePart = line.split('//').first;
      for (var i = 0; i < codePart.length; i++) {
        final ch = codePart[i];
        if (ch == '{') braceDepth++;
        if (ch == '}') braceDepth--;
        if (ch == '(') parenDepth++;
        if (ch == ')') parenDepth--;
      }
    }

    if (braceDepth == 0 &&
        parenDepth == 0 &&
        !_isOnlyCommentsOrAnnotations(current.join('\n'))) {
      final codeOnly = current.last.split('//').first.trimRight();
      if (codeOnly.endsWith('}') || codeOnly.endsWith(';')) {
        chunks.add(current.join('\n'));
        current.clear();
      }
    }
  }

  if (current.isNotEmpty && !_isOnlyCommentsOrAnnotations(current.join('\n'))) {
    chunks.add(current.join('\n'));
  }

  return chunks;
}

bool _isOnlyCommentsOrAnnotations(String text) {
  for (final line in text.split('\n')) {
    final t = line.trim();
    if (t.isEmpty || t.startsWith('//') || t.startsWith('@')) continue;
    return false;
  }
  return true;
}

String _stripLeadingComments(String text) {
  final lines = text.split('\n');
  final kept = <String>[];
  var seenCode = false;
  for (final line in lines) {
    final t = line.trim();
    if (!seenCode && (t.isEmpty || t.startsWith('//') || t.startsWith('@'))) {
      continue;
    }
    seenCode = true;
    kept.add(line);
  }
  return kept.join('\n');
}

String _stripInlineComments(String text) {
  return [for (final line in text.split('\n')) line.split('//').first]
      .join('\n');
}

String? _identifyFunctionOrMethodName(String clean) {
  final withoutComments = _stripInlineComments(clean).trim();
  final headerEnd = withoutComments.indexOf('{');
  final header =
      (headerEnd != -1
              ? withoutComments.substring(0, headerEnd)
              : withoutComments)
          .trim();
  final m = RegExp(r'^(?:static\s+)?(?:[\w<>?,\s]+\s+)?(get\s+\w+|\w+)\s*\(')
      .firstMatch(header);
  return m?.group(1)?.replaceAll(RegExp(r'\s+'), ' ');
}

/// Identifies a stable key (`ctor:<name>` or `member:<name>`) for a class or
/// enum member so that subsequent tutorial snippets that redefine the same
/// constructor, getter, method, or field replace the earlier version in-place.
String? _identifyMemberName(String chunk, {required String className}) {
  final clean = _stripInlineComments(_stripLeadingComments(chunk)).trim();
  if (clean.isEmpty) return null;

  // Match constructors (`ClassName(...)`, `const ClassName(...)`, or
  // `factory ClassName.fromJson(...)`) before methods so named/factory
  // constructors aren't misclassified as regular methods.
  final ctorMatch = RegExp(
    '^((?:const\\s+|factory\\s+)?$className(?:\\.\\w+)?)\\s*\\(',
  ).firstMatch(clean);
  if (ctorMatch != null) {
    return 'ctor:${ctorMatch.group(1)!.split(' ').last}';
  }

  final getterMatch = RegExp(
    r'^(?:static\s+)?[\w<>?,\s\(\)\{\}]+\s+get\s+(\w+)\b',
  ).firstMatch(clean);
  if (getterMatch != null) {
    return 'member:${getterMatch.group(1)!}';
  }

  // Match function-typed fields (such as `FutureOr<void> Function(Object)? onError;`)
  // before the method regex below, because the parentheses in `Function(...)`
  // would otherwise match the method signature pattern.
  if (!clean.contains('{') && !clean.contains('=>')) {
    final semiFieldMatch = RegExp(r'(\w+)\s*(?:=[^;]*)?;$').firstMatch(clean);
    if (semiFieldMatch != null && !clean.trimRight().endsWith(');')) {
      return 'member:${semiFieldMatch.group(1)!}';
    }
  }

  final methodMatch = RegExp(r'^(?:static\s+)?[\w<>?,\s]+\s+(\w+)\s*\(')
      .firstMatch(clean);
  if (methodMatch != null) {
    return 'member:${methodMatch.group(1)!}';
  }

  final fieldMatch = RegExp(
    r'^(?:late\s+)?(?:final\s+|const\s+|var\s+)?(?:[\w<>?,\s\(\)\{\}]+\s+)?(\w+)\s*(?:=|;)',
  ).firstMatch(clean);
  if (fieldMatch != null) {
    return 'member:${fieldMatch.group(1)!}';
  }

  return null;
}
