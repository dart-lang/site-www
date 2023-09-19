import 'dart:io';

import 'package:html_unescape/html_unescape_small.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;

final _unescape = HtmlUnescape();
final _anchorPattern = RegExp(r'(.+)\{#([^#]+)\}');

void main() async {
  const dirPath = 'src/effective-dart';
  const filenames = ['style.md', 'documentation.md', 'usage.md', 'design.md'];

  final sections =
      filenames.map((name) => Section(dirPath, name)).toList(growable: false);

  for (final section in sections) {
    var lines = section.file.readAsLinesSync();
    // Ignore the YAML front matter (can lead to false H3 elements).
    lines = lines
        .skip(1)
        .skipWhile((line) => line.trim() != '---')
        .toList(growable: false);
    final document = md.Document();

    final nodes = document.parseLines(lines);
    for (final element in nodes.whereType<md.Element>()) {
      if (element.tag == 'h2') {
        final subsection = Subsection(element);
        section.subsections.add(subsection);
      } else if (element.tag == 'h3') {
        final rule = Rule(element);
        section.subsections.last.rules.add(rule);
      }
    }
  }

  final outFile = File(path.join(dirPath, '_toc.md'));
  IOSink? out;
  try {
    out = outFile.openWrite();

    out.writeln(r'''
{% comment %}
This file is generated from the other files in this directory.
To re-generate it, please run the following command from root of
the project:

```
$ dart run tool/effective_dart_rules/bin/main.dart
```
{% endcomment %}
    ''');

    out.writeln(r"<div class='effective_dart--summary_column' markdown='1'>");
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      if (i > 0) {
        if (i.isEven) {
          out.writeln("<div style='clear:both'></div>");
        }
        out.writeln(
            "<div class='effective_dart--summary_column' markdown='1'>\n");
      }
      write(out, section);
      out.writeln('\n</div>');
    }
    out.writeln("<div style='clear:both'></div>");
  } finally {
    await out?.close();
  }
}

void write(IOSink out, Section section) {
  out.writeln('\n### ${section.name}\n');
  for (final subsection in section.subsections) {
    out.writeln('\n**${subsection.name}**\n');
    for (final rule in subsection.rules) {
      final link = section.uri.resolve('#${rule.fragment}');
      out.writeln("* <a href='$link'>${rule.html}</a>");
    }
  }
}

class Rule {
  final String html;
  final String fragment;

  factory Rule(md.Element element) {
    var name = _concatenatedText(element);
    var html = md.renderToHtml(element.children ?? const []);
    var fragment = _generateAnchorHash(name);

    // Handle headers with an explicit "{#anchor-text}" anchor.
    var match = _anchorPattern.firstMatch(name);
    if (match != null) {
      // Pull the anchor from the name.
      name = (match[1] ?? '').trim();
      fragment = match[2] ?? '';

      // Strip it from the HTML too.
      match = _anchorPattern.firstMatch(html);
      if (match != null) {
        html = (match[1] ?? '').trim();
      }
    }

    if (html.endsWith('.')) {
      throw Exception(
          "Effective Dart rule '$name' ends with a period when it shouldn't.");
    }

    html += '.';

    return Rule._(html, fragment);
  }

  Rule._(this.html, this.fragment);
}

class Section {
  final Uri uri;
  final File file;
  final String name;
  final List<Subsection> subsections = [];

  Section(String dirPath, String filename)
      : file = File(path.join(dirPath, filename)),
        uri = Uri.parse('/effective-dart/').resolve(filename.split('.').first),
        name = '${filename[0].toUpperCase()}'
            "${filename.substring(1).split('.').first}";
}

class Subsection {
  final String name;
  final String fragment;
  final List<Rule> rules = [];

  Subsection(md.Element element)
      : name = _concatenatedText(element),
        fragment = _generateAnchorHash(_concatenatedText(element));
}

/// Generates a valid HTML anchor from [text].
String _generateAnchorHash(String text) => text
    .toLowerCase()
    .trim()
    .replaceFirst(RegExp(r'^[^a-z]+'), '')
    .replaceAll(RegExp(r'[^a-z0-9 _-]'), '')
    .replaceAll(RegExp(r'\s'), '-');

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
