import 'dart:convert' show LineSplitter;

import 'package:jaspr_content/jaspr_content.dart';

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
          final language = _extractLanguage(
            firstChild.attributes['class'] ?? '',
          );
          final rawMetadata = firstChild.attributes.remove('data-meta');
          final metadata = rawMetadata != null
              ? _parseAttributes(rawMetadata)
              : const <String, String?>{};
          final title = metadata['title'];
          final tag = metadata['tag'];

          final rawHighlightLines = metadata['highlightLines'];

          var showLineNumbers = false;
          int? initialLineNumber;
          if (metadata.containsKey('showLineNumbers')) {
            showLineNumbers = true;

            final rawShowLineNumbers = metadata['showLineNumbers'];
            if (rawShowLineNumbers != null) {
              initialLineNumber = int.tryParse(rawShowLineNumbers);
            }
          }

          return ComponentNode(
            WrappedCodeBlock(
              content: _extractContent(firstChild),
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
    return match?.group(1) ?? 'plaintext';
  }

  List<String> _extractContent(Node node) {
    // Remove trailing empty spaces and new lines.
    final text = node.innerText.trimRight();

    return const LineSplitter().convert(text);
  }
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
