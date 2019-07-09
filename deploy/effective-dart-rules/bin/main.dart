// ignore_for_file: sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:html_unescape/html_unescape_small.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as path;

Future<Null> main() async {
  var dirPath = "src/_guides/language/effective-dart";
  var filenames = const <String>[
    "style.md",
    "documentation.md",
    "usage.md",
    "design.md"
  ];
  List<Section> sections =
      filenames.map((name) => Section(dirPath, name)).toList();

  for (var section in sections) {
    var lines = section.file.readAsLinesSync();
    // Ignore the YAML front matter (can lead to false H3 elements.
    lines = lines.skip(1).skipWhile((line) => line.trim() != '---').toList();
    var document = md.Document();

    // Commented out the following line because the parseRefLinks has
    // disappeared. Unfortunately, that means I had to hand-patch the TOC
    // to fix the links to custom anchors. To find these, display
    // localhost:4000/guides/language/effective-dart, and then search
    // for "{#". Delete the excess text and fix the URL.
    //document.parseRefLinks(lines);

    var nodes = document.parseLines(lines);
    for (md.Element element in nodes.where((node) => node is md.Element)) {
      if (element.tag == "h2") {
        var subsection = Subsection(element);
        section.subsections.add(subsection);
        continue;
      }

      if (element.tag == "h3") {
        var rule = Rule(element);
        section.subsections.last.rules.add(rule);
      }
    }
  }

  var outFile = File(path.join(dirPath, "toc.md"));
  IOSink out;
  try {
    out = outFile.openWrite();

    out.writeln(r"""
    {% comment %}
    This file is generated from the other files in this directory.
    To re-generate it, please run the following command from root of
    the project:

      $ dart deploy/effective-dart-rules/bin/main.dart

    {% endcomment %}
    """);

    out.writeln(r"<div class='effective_dart--summary_column' markdown='1'>");
    for (int i = 0; i < sections.length; i++) {
      var section = sections[i];
      if (i > 0) {
        if (i % 2 == 0) {
          out.writeln("<div style='clear:both'></div>");
        }
        out.writeln(
            "<div class='effective_dart--summary_column' markdown='1'>\n");
      }
      write(out, section);
      out.writeln("\n</div>");
    }
    out.writeln("<div style='clear:both'></div>");
  } finally {
    out.close();
  }
}

void write(IOSink out, Section section) {
  out.writeln("\n### ${section.name}\n");
  for (var subsection in section.subsections) {
    out.writeln("\n**${subsection.name}**\n");
    for (var rule in subsection.rules) {
      var link = section.uri.resolve('#' + rule.fragment);
      out.writeln("* <a href='$link'>${rule.html}</a>");
    }
  }
}

class Rule {
  final String name;
  String html;
  final String fragment;

  Rule(md.Element element)
      : name = _concatenatedText(element),
        html = md.renderToHtml(element.children),
        fragment = generateAnchorHash(element);
}

class Section {
  final Uri uri;
  final File file;
  final String name;
  List<Subsection> subsections = List<Subsection>();

  Section(String dirPath, String filename)
      : file = File(path.join(dirPath, filename)),
        uri = Uri.parse("/guides/language/effective-dart/")
            .resolve(filename.split('.').first),
        name = "${filename[0].toUpperCase()}"
            "${filename.substring(1).split('.').first}";
}

class Subsection {
  final String name;
  final String fragment;
  List<Rule> rules = List<Rule>();
  Subsection(md.Element element)
      : name = _concatenatedText(element),
        fragment = generateAnchorHash(element);
}

/// Generates a valid HTML anchor from the inner text of [element].
String generateAnchorHash(md.Element element) => _concatenatedText(element)
    .toLowerCase()
    .trim()
    .replaceFirst(RegExp(r'^[^a-z]+'), '')
    .replaceAll(RegExp(r'[^a-z0-9 _-]'), '')
    .replaceAll(RegExp(r'\s'), '-');

/// Concatenates the text found in all the children of [element].
String _concatenatedText(md.Element element) => element.children
    .map((child) =>
        (child is md.Text) ? unescape(child.text) : _concatenatedText(child))
    .join('');

final _unescape = HtmlUnescape();
String unescape(String input) => _unescape.convert(input);
