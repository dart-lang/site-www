// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;

import '../utils.dart';

final HtmlUnescape _unescape = HtmlUnescape();
final RegExp _anchorPattern = RegExp(r'(.+)\{:#([^#]+)\}');

final class GenerateEffectiveDartToc extends Command<int> {
  static const String _checkFlag = 'check';

  GenerateEffectiveDartToc() {
    argParser.addFlag(
      _checkFlag,
      defaultsTo: false,
      help: 'Just check if the TOC is up to date, do not update.',
    );
  }

  @override
  String get description => 'Generate or check up-to-date status of the '
      'Effective Dart table of contents.';

  @override
  String get name => 'effective-dart';

  @override
  Future<int> run() async => await _generateToc(
        justCheck: argResults.get<bool>(_checkFlag, false),
      );
}

Future<int> _generateToc({bool justCheck = false}) async {
  const dirPath = 'src/content/effective-dart';
  const filenames = ['style.md', 'documentation.md', 'usage.md', 'design.md'];

  final sections =
      filenames.map((name) => _Section(dirPath, name)).toList(growable: false);

  for (final section in sections) {
    // Read the lines, but skip the YAML front matter,
    // as it can lead to incorrect h3 elements.
    final lines = section.file
        .readAsLinesSync()
        .skip(1)
        .skipWhile((line) => line.trim() != '---')
        .toList(growable: false);
    final document = md.Document();

    final nodes = document.parseLines(lines);
    for (final element in nodes.whereType<md.Element>()) {
      if (element.tag == 'h2') {
        final subsection = _Subsection(element);
        section.subsections.add(subsection);
      } else if (element.tag == 'h3') {
        final rule = _Rule(element);
        section.subsections.last.rules.add(rule);
      }
    }
  }

  final newOutput = StringBuffer();
  newOutput.writeln(r'''
{% comment %}
This file is generated from the other files in this directory.
To re-generate it, please run the following command from root of
the project:

```
./dash_site effective-dart
```
{% endcomment %}
    ''');

  newOutput.writeln(
    r"<div class='effective_dart--summary_column'>",
  );

  for (var sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
    final section = sections[sectionIndex];
    if (sectionIndex > 0) {
      if (sectionIndex.isEven) {
        newOutput.writeln("<div style='clear:both'></div>");
      }
      newOutput.writeln(
        "<div class='effective_dart--summary_column'>\n",
      );
    }
    _writeSection(newOutput, section);
    newOutput.writeln('\n</div>');
  }

  newOutput.writeln("<div style='clear:both'></div>");

  final tocFile = File(path.join(dirPath, '_toc.md'));
  try {
    final oldContents = tocFile.readAsStringSync();

    if (oldContents != newOutput.toString()) {
      if (justCheck) {
        stderr.writeln(
          'Error: The Effective Dart TOC needs to be regenerated!',
        );
        return 1;
      } else {
        tocFile.writeAsStringSync(newOutput.toString());
        print('Successfully updated the Effective Dart TOC.');
      }
    } else {
      print('The Effective Dart TOC is up to date!');
    }
  } catch (e, stackTrace) {
    stderr.writeln('Error: Failed to read or write the TOC file.');
    stderr.writeln(e);
    stderr.writeln(stackTrace);
    return 1;
  }

  return 0;
}

void _writeSection(StringSink out, _Section section) {
  out.writeln('\n### ${section.name}\n');
  for (final subsection in section.subsections) {
    out.writeln('\n**${subsection.name}**\n');
    for (final rule in subsection.rules) {
      final link = section.uri.resolve('#${rule.fragment}');
      out.writeln("* <a href='$link'>${rule.html}</a>");
    }
  }
}

class _Rule {
  final String html;
  final String fragment;

  factory _Rule(md.Element element) {
    var name = _concatenatedText(element);
    var html = md.renderToHtml(element.children ?? const []);

    // Handle headers with an explicit "{:#anchor-text}" anchor.
    var match = _anchorPattern.firstMatch(name);

    final String fragment;
    if (match != null) {
      // Pull the anchor from the name.
      name = (match[1] ?? '').trim();
      fragment = match[2] ?? '';

      // Strip it from the HTML too.
      match = _anchorPattern.firstMatch(html);
      if (match != null) {
        html = (match[1] ?? '').trim();
      }
    } else {
      fragment = _generateAnchorHash(name);
    }

    if (html.endsWith('.')) {
      throw Exception(
        "Effective Dart rule '$name' ends with a period when it shouldn't.",
      );
    }

    html += '.';

    return _Rule._(html, fragment);
  }

  _Rule._(this.html, this.fragment);
}

class _Section {
  final Uri uri;
  final File file;
  final String name;
  final List<_Subsection> subsections = [];

  _Section(String dirPath, String filename)
      : file = File(path.join(dirPath, filename)),
        uri = Uri.parse('/effective-dart/').resolve(filename.split('.').first),
        name = '${filename[0].toUpperCase()}'
            "${filename.substring(1).split('.').first}";
}

class _Subsection {
  final String name;
  final String fragment;
  final List<_Rule> rules = [];

  _Subsection(md.Element element)
      : name = _concatenatedText(element),
        fragment = _generateAnchorHash(_concatenatedText(element));
}

/// Generates a valid HTML anchor from [text].
String _generateAnchorHash(String text) => text
    .toLowerCase()
    .trim()
    .replaceAll(RegExp(r'[:.]'), '-')
    .replaceAll(RegExp(r'[^a-z0-9\s_-]'), '')
    .replaceAll(RegExp(r'[\s-]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');

/// Concatenates the text found in all the children of [element].
String _concatenatedText(md.Element element) {
  final children = element.children;

  if (children == null) {
    return '';
  }

  return children
      .map((child) => (child is md.Text)
          ? _unescape.convert(child.text)
          : (child is md.Element)
              ? _concatenatedText(child)
              : _unescape.convert(child.textContent))
      .join('');
}
