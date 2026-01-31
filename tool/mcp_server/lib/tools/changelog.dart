import 'dart:io';

import 'package:dart_mcp/server.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class SyncSdkChangelogTool {
  Tool get toolDef => Tool(
    name: 'sync_sdk_changelog',
    description:
        'Syncs changelog entries from the Dart SDK CHANGELOG.md to src/data/changelog.yml',
    inputSchema: ObjectSchema(
      properties: {
        'version': Schema.string(
          description: 'The Dart SDK version to sync (e.g., "3.9.0")',
        ),
        'dryRun': Schema.bool(
          description:
              'If true, returns the generated content without writing to file',
        ),
      },
      required: ['version'],
    ),
  );

  Future<CallToolResult> call(CallToolRequest request) async {
    try {
      final args = request.arguments ?? {};
      final version = args['version'] as String?;
      final dryRun = args['dryRun'] as bool? ?? false;
      if (version == null) {
        throw ArgumentError('Version argument is required');
      }

      final sdkChangelogUrl = Uri.parse(
        'https://raw.githubusercontent.com/dart-lang/sdk/main/CHANGELOG.md',
      );

      // Fetch the SDK CHANGELOG.md
      final response = await http.get(sdkChangelogUrl);
      if (response.statusCode != 200) {
        return CallToolResult(
          isError: true,
          content: [
            TextContent(
              text: 'Failed to fetch SDK CHANGELOG.md: ${response.statusCode}',
            ),
          ],
        );
      }

      final patches = _parseChangelog(response.body, version);
      if (patches.isEmpty) {
        return CallToolResult(
          content: [
            TextContent(
              text: 'No entries found for version $version in SDK CHANGELOG.',
            ),
          ],
        );
      }

      // Read the local changelog.yml
      final rootDir = _findProjectRoot();
      if (rootDir == null) {
        return CallToolResult(
          isError: true,
          content: [
            TextContent(
              text: 'Could not find project root (src/data/changelog.yml).',
            ),
          ],
        );
      }

      final changelogPath = p.join(rootDir.path, 'src/data/changelog.yml');
      final changelogFile = File(changelogPath);
      if (!await changelogFile.exists()) {
        return CallToolResult(
          isError: true,
          content: [TextContent(text: 'File not found: $changelogPath')],
        );
      }

      final newYaml = _generateYamlString(patches);
      if (dryRun) {
        return CallToolResult(
          content: [
            TextContent(
              text:
                  'Dry run successful. Found ${patches.length} entries for version $version:\n\n$newYaml',
            ),
          ],
        );
      }

      final currentContent = await changelogFile.readAsString();
      final newContent = _applyPatches(currentContent, newYaml);

      await changelogFile.writeAsString(newContent);

      return CallToolResult(
        content: [
          TextContent(
            text:
                'Successfully added ${patches.length} entries for version $version in $changelogPath',
          ),
        ],
      );
    } catch (e, st) {
      return CallToolResult(
        isError: true,
        content: [TextContent(text: 'Error executing tool: $e\n$st')],
      );
    }
  }

  List<ChangelogEntry> _parseChangelog(String markdown, String targetVersion) {
    final entries = <ChangelogEntry>[];
    final lines = markdown.split('\n');

    String? currentArea;
    String? currentSubArea;

    final versionRegExp = RegExp(r'^##\s+(\d+\.\d+\.\d+)');
    // Note: The SDK changelog sometime uses "## ToolName" but typically "## 3.9.0 ..." are at the same level.
    // If we are strictly parsing inside a version, "## Area" is what we look for.
    // But SDK changelog often puts Areas as H3 or H2?
    // Let's assume standard format:
    // ## 3.9.0
    // ### Language
    // ### Tools
    // #### Pub

    // We need to be flexible.

    bool inTargetVersion = false;
    final bulletBuffer = StringBuffer();
    String? pendingLink;

    void flushBullet() {
      if (bulletBuffer.isNotEmpty) {
        final description = bulletBuffer.toString().trim();
        if (description.isNotEmpty) {
          entries.add(
            ChangelogEntry(
              version: targetVersion,
              releaseDate: 'TBD',
              area: currentArea ?? 'SDK',
              subArea: currentSubArea,
              description: description,
              tags: _inferTags(description),
              link: pendingLink,
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
      // If we see ### something, it is likely an Area (if version is ##)
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
        bulletBuffer.write(line.trim().substring(2));
      } else if (line.trim().isNotEmpty && bulletBuffer.isNotEmpty) {
        bulletBuffer.write('\n${line.trim()}');
      }
    }
    flushBullet();
    return entries;
  }

  Directory? _findProjectRoot() {
    var dir = Directory.current;
    while (true) {
      if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
        final pubspec = File(
          p.join(dir.path, 'pubspec.yaml'),
        ).readAsStringSync();
        if (pubspec.contains('workspace:')) {
          return dir;
        }
      }
      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  }

  String _applyPatches(String content, String newYaml) {
    final firstSeparator =
        '# --------------------------------------------------';
    // Insert logic: try to insert after the first separator found at the start
    if (content.startsWith(firstSeparator)) {
      final lines = content.split('\n');
      final buffer = StringBuffer();
      // Keep the First separator
      buffer.writeln(lines.first);
      // Insert new entries
      buffer.write(newYaml);
      // Rest of content
      buffer.write(lines.skip(1).join('\n'));
      return buffer.toString();
    } else {
      return newYaml + content;
    }
  }

  String _generateYamlString(List<ChangelogEntry> entries) {
    final newYaml = StringBuffer();
    final firstSeparator =
        '# --------------------------------------------------';

    for (final entry in entries) {
      newYaml.writeln('- version: ${entry.version}');
      newYaml.writeln('  releaseDate: ${entry.releaseDate}');
      newYaml.writeln('  area: ${entry.area}');
      if (entry.subArea != null) {
        newYaml.writeln('  subArea: ${entry.subArea}');
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
        newYaml.writeln('  link: ${entry.link}');
      }
      newYaml.writeln(firstSeparator);
    }
    return newYaml.toString();
  }

  List<String> _inferTags(String description) {
    final tags = <String>[];
    final lower = description.toLowerCase();
    if (lower.contains('breaking change')) {
      tags.add('breaking');
    }
    if (tags.isEmpty) tags.add('changed');
    return tags;
  }
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
