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
  });

  final String language;
  final String filePath;
  final String code;
  final int lineNumber;
  final Map<String, String> attributes;

  Map<String, Object?> toJson() => {
    'language': language,
    'filePath': filePath,
    'lineNumber': lineNumber,
    if (attributes.isNotEmpty) 'attributes': attributes,
    'code': code,
  };
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
    required this.deletedFiles,
    required this.hasTests,
  });

  /// 1-based chapter index (1 to 13).
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

  /// Files explicitly deleted during this chapter.
  final Set<String> deletedFiles;

  /// Whether this chapter includes runnable package tests.
  final bool hasTests;

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
      final extracted = _extractBlocksFromMarkdown(markdownContent);
      final deletedInChapter = <String>{};

      // Handle bash scaffolding commands in the chapter.
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
        if (bashBlock.contains('rm wikipedia_test.dart')) {
          state.removeFile('wikipedia/test/wikipedia_test.dart');
          deletedInChapter.add('wikipedia/test/wikipedia_test.dart');
        }
      }

      // Apply each titled code snippet in order.
      for (final snippet in extracted.titledSnippets) {
        state.applySnippet(chapterMeta.id, snippet);
      }

      // In the testing chapter, cat_extract.json is referenced via an external
      // GitHub link because of its size; provide a minimal valid fixture so
      // `dart test` can run offline during validation.
      if (chapterMeta.id == 'testing') {
        state.ensureCatExtractJsonFixture();
      }

      snapshots.add(
        TutorialChapterSnapshot(
          index: chapterNumber,
          id: chapterMeta.id,
          title: chapterMeta.title,
          markdownPath: chapterMeta.mdPath,
          snippets: extracted.titledSnippets,
          workspaceFiles: Map<String, String>.unmodifiable(
            Map<String, String>.fromEntries(
              state.files.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key)),
            ),
          ),
          createdPackages: Set<String>.unmodifiable(state.packages),
          deletedFiles: Set<String>.unmodifiable(deletedInChapter),
          hasTests: state.files.containsKey('wikipedia/test/model_test.dart'),
        ),
      );
    }

    return snapshots;
  }

  ({List<TutorialCodeSnippet> titledSnippets, List<String> bashBlocks})
  _extractBlocksFromMarkdown(String markdown) {
    final lines = markdown.split('\n');
    final titledSnippets = <TutorialCodeSnippet>[];
    final bashBlocks = <String>[];

    var i = 0;
    while (i < lines.length) {
      final line = lines[i];
      // Skip doc-comment code fences (`/// ```dart`).
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
      }

      i++;
    }

    return (titledSnippets: titledSnippets, bashBlocks: bashBlocks);
  }

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

  void removeFile(String filePath) {
    files.remove(filePath);
    _dartFiles.remove(filePath);
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

  void applySnippet(String chapterId, TutorialCodeSnippet snippet) {
    final targetPath = snippet.filePath;
    if (snippet.language == 'yaml') {
      _applyYamlSnippet(targetPath, snippet.code);
    } else if (snippet.language == 'json') {
      files[targetPath] = '${snippet.code}\n';
    } else if (snippet.language == 'dart') {
      _applyDartSnippet(chapterId, targetPath, snippet.code);
    }
  }

  void _applyYamlSnippet(String targetPath, String code) {
    if (targetPath == 'pubspec.yaml') {
      // Root workspace pubspec.
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

    // Parse dependencies or dev_dependencies blocks if present.
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
      // Partial YAML snippet with ellipses; flags above already handled it.
    }

    files[targetPath] = model.render();
  }

  void _applyDartSnippet(String chapterId, String targetPath, String rawCode) {
    // Strip lines explicitly marked for deletion in Chapter 1.
    final filteredLines = rawCode
        .split('\n')
        .where((l) => !l.contains('// Delete this entire line'))
        .toList();
    final code = filteredLines.join('\n').trim();

    // Skip "recap" blocks that have inline placeholder bodies like
    // `void searchWikipedia(...) { /* ... existing logic ... */ }`.
    if (code.contains('/* ... existing logic ... */')) {
      return;
    }

    // If the snippet is a pure library/export file, replace the file directly.
    if (_isLibraryExportFile(code)) {
      _dartFiles.remove(targetPath);
      files[targetPath] = '$code\n';
      return;
    }

    // In Chapters 1, 2, 4, 5, 6, 7, 9, 13, when a snippet for `cli/bin/cli.dart`
    // is a complete entrypoint file (no ellipsis comments), replace `cli.dart`.
    final isFullCliEntrypoint =
        targetPath == 'cli/bin/cli.dart' &&
        !_hasEllipsisComment(code) &&
        code.contains('void main') &&
        (chapterId == 'first-app' ||
            (chapterId != 'async' && code.contains('import ')));
    if (isFullCliEntrypoint) {
      final freshModel = _DartFileModel();
      freshModel.mergeSnippet(code);
      _dartFiles[targetPath] = freshModel;
      files[targetPath] = freshModel.render();
      return;
    }

    // When a non-cli.dart file receives a complete file (has `import ` and
    // defines a class/function without any `// ...` ellipsis comments), check
    // whether it is a full replacement of the file.
    if (targetPath != 'cli/bin/cli.dart' &&
        code.contains('import ') &&
        (code.contains('class ') || code.contains('enum ')) &&
        !_hasEllipsisComment(code)) {
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
final class _DartFileModel {
  final Set<String> imports = {};
  final Map<String, _DartTopLevelDecl> declarations = {};

  void mergeSnippet(String snippet) {
    final parsed = _parseDartUnits(snippet);
    for (final imp in parsed.imports) {
      // Remove any trailing instructional comment on the import line.
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
        if (existing != null &&
            existing.kind == _DeclKind.classOrEnum &&
            _WorkspaceBuilder._hasEllipsisComment(unit.code)) {
          existing.mergeClassOrEnumMembers(unit.code);
        } else {
          declarations[unit.name] = unit;
        }
      } else if (unit.kind == _DeclKind.functionOrMethod) {
        // Check if this file has a class declaration and no top-level functions
        // with this name, meaning this bare method snippet updates the class!
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
      // For enhanced enums, enum constants precede the first `;` at depth 0.
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
        // Check if this semicolon belongs to the enum values list (preceded by
        // `)` or an identifier, not `final ` or `const `).
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

    // Ignore standalone ellipsis placeholder comments at depth 0.
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

String? _identifyMemberName(String chunk, {required String className}) {
  final clean = _stripInlineComments(_stripLeadingComments(chunk)).trim();
  if (clean.isEmpty) return null;

  // Constructor (`ClassName(...)` or `const ClassName(...)` or `factory ClassName.foo(...)`)
  final ctorMatch = RegExp(
    '^((?:const\\s+|factory\\s+)?$className(?:\\.\\w+)?)\\s*\\(',
  ).firstMatch(clean);
  if (ctorMatch != null) {
    return 'ctor:${ctorMatch.group(1)!.split(' ').last}';
  }

  // Getter (`Type get foo`)
  final getterMatch = RegExp(
    r'^(?:static\s+)?[\w<>?,\s\(\)\{\}]+\s+get\s+(\w+)\b',
  ).firstMatch(clean);
  if (getterMatch != null) {
    return 'member:${getterMatch.group(1)!}';
  }

  // Field ending with `;` or having `=` before any method body `{` or `=>`
  // (including function-typed fields like `FutureOr<void> Function(Object)? onError;`).
  if (!clean.contains('{') && !clean.contains('=>')) {
    final semiFieldMatch = RegExp(r'(\w+)\s*(?:=[^;]*)?;$').firstMatch(clean);
    if (semiFieldMatch != null && !clean.trimRight().endsWith(');')) {
      return 'member:${semiFieldMatch.group(1)!}';
    }
  }

  // Method (`ReturnType foo(`)
  final methodMatch = RegExp(r'^(?:static\s+)?[\w<>?,\s]+\s+(\w+)\s*\(')
      .firstMatch(clean);
  if (methodMatch != null) {
    return 'member:${methodMatch.group(1)!}';
  }

  // Field (`final Type foo = ...;` or `Type foo;`)
  final fieldMatch = RegExp(
    r'^(?:late\s+)?(?:final\s+|const\s+|var\s+)?(?:[\w<>?,\s\(\)\{\}]+\s+)?(\w+)\s*(?:=|;)',
  ).firstMatch(clean);
  if (fieldMatch != null) {
    return 'member:${fieldMatch.group(1)!}';
  }

  return null;
}
