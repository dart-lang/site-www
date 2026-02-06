import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'version',
      abbr: 'v',
      help: 'The Dart SDK version to sync (e.g., "3.9.0")',
    )
    ..addFlag(
      'dry-run',
      abbr: 'd',
      help: 'If true, returns the generated content without writing to file',
      defaultsTo: false,
    )
    ..addFlag('help', abbr: 'h', help: 'Show usage', negatable: false);

  final results = parser.parse(arguments);

  if (results['help'] as bool) {
    print('Usage: dart run tool/sync_sdk_changelog.dart [options]');
    print(parser.usage);
    exit(0);
  }

  final version = results['version'] as String?;
  final dryRun = results['dry-run'] as bool;

  if (version == null) {
    print('Error: Version argument is required');
    print('Usage: dart run tool/sync_sdk_changelog.dart --version <version>');
    exit(1);
  }

  print('Syncing changelog for version $version...');

  try {
    final sdkChangelogUrl = Uri.parse(
      'https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md',
    );

    // Fetch the SDK CHANGELOG.md
    final response = await http.get(sdkChangelogUrl);
    if (response.statusCode != 200) {
      print('Failed to fetch SDK CHANGELOG.md: ${response.statusCode}');
      exit(1);
    }

    final patches = _parseChangelog(response.body, version);
    if (patches.isEmpty) {
      print('No entries found for version $version in SDK CHANGELOG.');
      exit(0);
    }

    // Read the local changelog.yml
    final rootDir = _findProjectRoot();
    if (rootDir == null) {
      print('Could not find project root (src/data/changelog.yml).');
      exit(1);
    }

    final changelogPath = p.join(rootDir.path, 'src/data/changelog.yml');
    final changelogFile = File(changelogPath);
    if (!await changelogFile.exists()) {
      print('File not found: $changelogPath');
      exit(1);
    }

    final newYaml = _generateYamlString(patches);
    if (dryRun) {
      print(
        'Dry run successful. Found ${patches.length} entries for version $version:',
      );
      print(newYaml);
      exit(0);
    }

    final currentContent = await changelogFile.readAsString();
    final newContent = _applyPatches(currentContent, newYaml);

    await changelogFile.writeAsString(newContent);

    print(
      'Successfully added ${patches.length} entries for version $version in $changelogPath',
    );
  } catch (e, st) {
    print('Error executing tool: $e\n$st');
    exit(1);
  }
}

Directory? _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

List<ChangelogEntry> _parseChangelog(String markdown, String targetVersion) {
  final entries = <ChangelogEntry>[];
  final lines = markdown.split('\n');

  String? currentArea;
  String? currentSubArea;

  final versionRegExp = RegExp(r'^##\s+(\d+\.\d+\.\d+)');

  bool inTargetVersion = false;
  final bulletBuffer = StringBuffer();
  String? pendingLink;

  void flushBullet() {
    if (bulletBuffer.isNotEmpty) {
      final description = bulletBuffer.toString().trim();
      if (description.isNotEmpty) {
        String? link = pendingLink;
        if (link == null) {
          // Default to the SDK CHANGELOG anchor if no specific link is found.
          // Anchor format for "3.11.0" is usually "#3110".
          final anchor = targetVersion.replaceAll('.', '');
          link =
              'https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#$anchor';
        }

        entries.add(
          ChangelogEntry(
            version: targetVersion,
            releaseDate: 'TBD',
            area: currentArea ?? 'SDK',
            subArea: currentSubArea,
            description: description,
            tags: _inferTags(description),
            link: link,
          ),
        );
      }
      bulletBuffer.clear();
      pendingLink = null;
    }
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Check for Version Header
    final versionMatch = versionRegExp.firstMatch(line);
    if (versionMatch != null) {
      final version = versionMatch.group(1)!;
      if (version == targetVersion) {
        inTargetVersion = true;
        currentArea = null;
        currentSubArea = null;
        continue;
      } else if (inTargetVersion) {
        flushBullet();
        break;
      }
    }

    if (!inTargetVersion) continue;

    // Detect Area/SubArea
    if (line.startsWith('### ')) {
      flushBullet();
      currentArea = line.substring(4).trim();
      currentSubArea = null;
      continue;
    }

    if (line.startsWith('#### ')) {
      flushBullet();
      currentSubArea = line.substring(5).trim();
      continue;
    }

    // Check for list items
    if (line.trim().startsWith('- ')) {
      flushBullet();
      final content = line.trim().substring(2);
      bulletBuffer.write(content);

      // Extract link if present
      final linkMatch = RegExp(r'\[.*?\]\((.*?)\)').firstMatch(content);
      if (linkMatch != null) {
        pendingLink = linkMatch.group(1);
      }
    } else if (line.trim().isNotEmpty && bulletBuffer.isNotEmpty) {
      bulletBuffer.write('\n${line.trim()}');

      if (pendingLink == null) {
        var linkMatch = RegExp(r'\[.*?\]\((.*?)\)').firstMatch(line);
        if (linkMatch != null) {
          pendingLink = linkMatch.group(1);
        } else {
          linkMatch = RegExp(r'\[.*?\]:\s+(https?://\S+)').firstMatch(line);
          if (linkMatch != null) {
            pendingLink = linkMatch.group(1);
          }
        }
      }
    }
  }
  flushBullet();
  return entries;
}

String _applyPatches(String content, String newYaml) {
  final firstSeparator = '# --------------------------------------------------';
  if (content.startsWith(firstSeparator)) {
    final lines = content.split('\n');
    final buffer = StringBuffer();
    buffer.writeln(lines.first);
    buffer.write(newYaml);
    buffer.write(lines.skip(1).join('\n'));
    return buffer.toString();
  } else {
    return newYaml + content;
  }
}

String _generateYamlString(List<ChangelogEntry> entries) {
  final newYaml = StringBuffer();
  final firstSeparator = '# --------------------------------------------------';

  // Helper to safely quote strings for YAML if needed
  String yamlSafe(String? value) {
    if (value == null) return '';
    // Simple check: alpha-numeric only?
    if (RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) return value;
    return jsonEncode(value);
  }

  for (final entry in entries) {
    newYaml.writeln('- version: ${entry.version}');
    newYaml.writeln('  releaseDate: ${entry.releaseDate ?? "TBD"}');

    newYaml.writeln('  area: ${yamlSafe(entry.area)}');
    if (entry.subArea != null) {
      newYaml.writeln('  subArea: ${yamlSafe(entry.subArea!)}');
    }
    newYaml.writeln('  description: |');
    for (final line in entry.description.split('\n')) {
      newYaml.writeln('    $line');
    }
    if (entry.tags.isNotEmpty) {
      newYaml.writeln('  tags:');
      for (final tag in entry.tags) {
        newYaml.writeln('    - $tag');
      }
    }
    if (entry.link != null) {
      newYaml.writeln('  link: ${yamlSafe(entry.link)}'); 
    }
    newYaml.writeln(firstSeparator);
  }
  return newYaml.toString();
}

List<String> _inferTags(String description) {
  final tags = <String>{};
  final lower = description.toLowerCase();

  // Helper to check for whole words
  bool hasWord(String word) {
    return RegExp('\\b$word\\b').hasMatch(lower);
  }

  // Breaking
  if (lower.contains('breaking change') ||
      hasWord('breaking') ||
      lower.contains('no longer compile') ||
      lower.contains('compile-time error') ||
      lower.contains('runtime error')) {
    tags.add('breaking');
  }

  // New
  if (hasWord('added') ||
      hasWord('adds') ||
      hasWord('introduces') ||
      hasWord('introduced') ||
      lower.contains('new feature') ||
      lower.contains('support for') ||
      hasWord('initial') ||
      hasWord('enable')) {
    tags.add('new');
  }

  // Fixed
  if (hasWord('fixed') ||
      hasWord('fixes') ||
      hasWord('fix') ||
      hasWord('bug') ||
      hasWord('issue') ||
      hasWord('resolves') ||
      hasWord('resolved')) {
    tags.add('fixed');
  }

  // Deprecations
  if (hasWord('deprecated') ||
      hasWord('deprecates') ||
      hasWord('deprecation') ||
      lower.contains('legacy')) {
    tags.add('deprecated');
  }

  // Removals
  if (hasWord('removed') ||
      hasWord('removes') ||
      hasWord('deleted') ||
      hasWord('drop') ||
      hasWord('dropped') ||
      lower.contains('no longer supported') ||
      lower.contains('no longer supports')) {
    tags.add('removed');
  }

  // Experimental
  if (hasWord('experimental') || hasWord('experiment') || hasWord('preview')) {
    tags.add('experimental');
  }

  if (tags.isEmpty) {
    tags.add('changed');
  }

  // If we have specific tags, we might want to ensure 'changed' isn't explicitly needed,
  // but if something is 'new' AND 'breaking', that's fine.

  return tags.toList();
}

class ChangelogEntry {
  final String version;
  final String releaseDate;
  final String area;
  final String? subArea;
  final String description;
  final List<String> tags;
  final String? link;

  ChangelogEntry({
    required this.version,
    required this.releaseDate,
    required this.area,
    this.subArea,
    required this.description,
    required this.tags,
    this.link,
  });
}
