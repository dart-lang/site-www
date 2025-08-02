import 'dart:convert' show LineSplitter;

import 'package:jaspr_content/jaspr_content.dart';
import 'package:meta/meta.dart';

import '../components/dartpad_injector.dart';
import '../components/wrapped_code_block.dart';

final class CodeBlockProcessor implements PageExtension {
  const CodeBlockProcessor();

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    return _processNodes(nodes);
  }

  List<Node> _processNodes(List<Node> nodes) {
    return [for (final node in nodes) _processNode(node)];
  }

  Node _processNode(Node node) {
    if (node is! ElementNode) return node;

    if (node.tag.toLowerCase() == 'pre') {
      final children = node.children;
      if (children != null && children.isNotEmpty) {
        final firstChild = children.first;
        if (firstChild is ElementNode && firstChild.tag == 'code') {
          final lines = _extractContent(firstChild);
          final language = _extractLanguage(
            firstChild.attributes['class'] ?? '',
          );

          final rawMetadata = firstChild.attributes.remove('data-meta');
          final metadata = rawMetadata != null
              ? _parseAttributes(rawMetadata)
              : const <String, String?>{};
          final title = metadata['title'];

          if (language == 'dartpad') {
            return ComponentNode(
              DartPadInjector(
                content: lines,
                title: title,
                theme: metadata['theme'],
                height: metadata['height'],
                runAutomatically: metadata['run'] == 'true',
              ),
            );
          }

          final tag = metadata['tag'];

          final rawHighlightLines = metadata['highlightLines'];
          // ignore: unused_local_variable
          final skipSyntaxHighlighting = metadata.containsKey('noHighlight');

          var showLineNumbers = false;
          int? initialLineNumber;
          if (metadata.containsKey('showLineNumbers')) {
            showLineNumbers = true;

            final rawShowLineNumbers = metadata['showLineNumbers'];
            if (rawShowLineNumbers != null) {
              initialLineNumber = int.tryParse(rawShowLineNumbers);
            }
          }

          final codeLines = _removeHighlights(lines);
          final processedContent = codeLines
              .map((line) => line.content)
              .toList(growable: false);

          return ComponentNode(
            WrappedCodeBlock(
              content: processedContent,
              language: language,
              title: title,
              highlightLines: _parseNumbersAndRanges(rawHighlightLines),
              tag: tag != null ? CodeBlockTag.parse(tag) : null,
              initialLineNumber: initialLineNumber ?? 1,
              showLineNumbers: showLineNumbers,
            ),
          );
        }
      }
    }

    final nodeChildren = node.children;
    return ElementNode(
      node.tag,
      node.attributes,
      nodeChildren != null ? _processNodes(nodeChildren) : null,
    );
  }

  String _extractLanguage(String className) {
    final match = RegExp(r'language-(\w+)').firstMatch(className);
    return match?.group(1)?.toLowerCase() ?? 'plaintext';
  }

  List<String> _extractContent(Node node) {
    // Remove trailing empty spaces and new lines.
    final text = node.innerText.trimRight();

    return const LineSplitter()
        .convert(text)
        .map((l) => l.trimRight())
        .toList(growable: false);
  }

  List<_CodeLine> _removeHighlights(List<String> lines) {
    final lineHighlights = <int, List<({int startColumn, int length})>>{};
    ({int startLine, int startColumn})? currentHighlight;

    final processedLines = <String>[];

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      if (line.trim().isEmpty) {
        // Empty lines should still be a part of the output.
        processedLines.add('');
        continue;
      }

      final processedLine = StringBuffer();
      var i = 0;

      while (i < line.length) {
        // Check for the opening marker [!.
        if (i + 1 < line.length && line[i] == '[' && line[i + 1] == '!') {
          if (currentHighlight != null) {
            throw ArgumentError(
              'Opening highlight marker "[!" found at '
              'line ${lineIndex + 1}, column ${i + 1} while '
              'previous highlight at line ${currentHighlight.startLine + 1}, '
              'column ${currentHighlight.startColumn + 1} is not closed',
            );
          }
          currentHighlight = (
            startLine: lineIndex,
            startColumn: processedLine.length,
          );

          // Skip past the [! marker in the line.
          i += 2;
          continue;
        }

        // If there's an open highlight span, check for the closing marker !].
        if (currentHighlight != null &&
            i + 1 < line.length &&
            line[i] == '!' &&
            line[i + 1] == ']') {
          if (currentHighlight.startLine == lineIndex) {
            // If the highlight span is opened and closed in the same line.
            lineHighlights.putIfAbsent(lineIndex, () => []).add((
              startColumn: currentHighlight.startColumn,
              length: processedLine.length - currentHighlight.startColumn,
            ));
          } else {
            // If the highlight span is opened then closed in separate lines.

            // Add the highlight range for the line the span is opened in.
            lineHighlights
                .putIfAbsent(currentHighlight.startLine, () => [])
                .add((
                  startColumn: currentHighlight.startColumn,
                  length:
                      processedLines[currentHighlight.startLine].length -
                      currentHighlight.startColumn,
                ));

            // Add the highlight range for the lines completely included.
            for (var j = currentHighlight.startLine + 1; j < lineIndex; j++) {
              lineHighlights.putIfAbsent(j, () => []).add((
                startColumn: 0,
                length: processedLines[j].length,
              ));
            }

            // Add the highlight range for the line the span is closed in.
            lineHighlights.putIfAbsent(lineIndex, () => []).add((
              startColumn: 0,
              length: processedLine.length,
            ));
          }

          currentHighlight = null;

          // Skip past the !] marker in the line.
          i += 2;
          continue;
        }

        processedLine.write(line[i]);
        i++;
      }

      processedLines.add(processedLine.toString());
    }

    // Check if a highlight span was never closed.
    if (currentHighlight != null) {
      throw ArgumentError(
        'Unclosed highlight marker starting at '
        'line ${currentHighlight.startLine + 1}, '
        'column ${currentHighlight.startColumn + 1}',
      );
    }

    return [
      for (var i = 0; i < processedLines.length; i++)
        _CodeLine(
          content: processedLines[i],
          highlights: lineHighlights[i] ?? [],
        ),
    ];
  }
}

@immutable
final class _CodeLine {
  final String content;
  final List<({int startColumn, int length})> highlights;

  const _CodeLine({required this.content, required this.highlights});
}

class CodeSpan {
  final String text;
  final bool? bold;
  final String? color;

  const CodeSpan({required this.text, this.bold, this.color});
}

/// Parses a comma-separated list of numbers and ranges into a set of numbers.
///
/// Returns all unique numbers specified in the input.
Set<int> _parseNumbersAndRanges(String? input) {
  if (input == null) return const {};
  final elements = input.trim().split(',');
  if (elements.isEmpty) return const {};

  final combinedNumbers = <int>{};

  for (final element in elements) {
    final rangeParts = element.split('-');

    // If it includes a dash, it is (hopefully) a range between two numbers.
    if (rangeParts.length > 1) {
      // Split by the dash, and turn each string into a number.
      // Assume the user only included one dash.
      final start = int.tryParse(rangeParts[0].trim());
      final end = int.tryParse(rangeParts[1].trim());

      if (start != null && end != null) {
        for (var i = start; i <= end; i++) {
          combinedNumbers.add(i);
        }
      }
    } else {
      // It's (hopefully) just a single number.
      final number = int.tryParse(element.trim());
      if (number != null) {
        combinedNumbers.add(number);
      }
    }
  }

  return combinedNumbers;
}

/// Matches a key-value attribute pair, similar to HTML elements.
///
/// Group 1: The attribute key.
/// Group 2: The value if quoted.
/// Group 3: The value if unquoted.
final RegExp _attributeRegex = RegExp(r'(\w+)=(?:"([^"]*)"|(\S+))');

Map<String, String?> _parseAttributes(String input) {
  final matches = _attributeRegex.allMatches(input);

  return {
    for (final match in matches)
      match.group(1)!: match.group(2) ?? match.group(3),
  };
}
