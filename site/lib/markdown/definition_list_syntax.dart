import 'package:markdown/markdown.dart' as md;

/// A custom Markdown block syntax for definition lists.
///
/// Definition lists are composed of terms and their definitions.
/// Terms are written on their own lines, and definitions are written
/// on the following lines, starting with a colon and a space.
///
/// For example:
///
/// ```md
/// First Term
/// : This is the definition of the first term.
///
/// Second Term
/// : This is one definition of the second term.
/// : This is another definition of the second term.
/// ```
///
/// Renders as HTML:
///
/// ```html
/// <dl>
///   <dt>First Term</dt>
///   <dd>This is the definition of the first term.</dd>
///   <dt>Second Term</dt>
///   <dd>This is one definition of the second term.</dd>
///   <dd>This is another definition of the second term.</dd>
/// </dl>
/// ```
final class DefinitionListSyntax extends md.BlockSyntax {
  static final _definitionPattern = RegExp(r'^\s*:\s+(.*)$');

  @override
  RegExp get pattern => _definitionPattern;

  const DefinitionListSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    return _isDefinitionListStart(parser);
  }

  @override
  md.Node? parse(md.BlockParser parser) {
    final elements = <md.Element>[];

    while (!parser.isDone && _isDefinitionListStart(parser)) {
      _parseTermsAndDefinitions(parser, elements);
      _skipEmptyLines(parser);
    }

    return elements.isNotEmpty ? md.Element('dl', elements) : null;
  }

  void _parseTermsAndDefinitions(
    md.BlockParser parser,
    List<md.Element> elements,
  ) {
    // Parse all consecutive terms.
    while (!parser.isDone && _isTerm(parser)) {
      // Use a block parser to ensure link references work as expected.
      // If wrapped in paragraph, remove it.
      final termNodes = md.BlockParser(
        [parser.current],
        parser.document,
      ).parseLines();
      final firstNode = termNodes.first;
      final List<md.Node> unwrappedNodes;
      if (firstNode is md.Element && firstNode.tag == 'p') {
        unwrappedNodes = firstNode.children ?? [];
      } else {
        unwrappedNodes = termNodes;
      }

      elements.add(md.Element('dt', unwrappedNodes));
      parser.advance();
    }

    // Parse all consecutive definitions.
    while (!parser.isDone && _isDefinition(parser)) {
      final definitionElement = _parseDefinition(parser);
      if (definitionElement != null) {
        elements.add(definitionElement);
      }
    }
  }

  md.Element? _parseDefinition(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content);
    if (match == null) return null;

    final lines = <String>[match.group(1)!];
    parser.advance();

    // Collect continuation lines.
    while (!parser.isDone && _isDefinitionContinuation(parser)) {
      final line = parser.current.content;
      if (line.trim().isEmpty) {
        // Check if empty line should be included.
        if (_shouldIncludeEmptyLine(parser)) {
          lines.add('');
          parser.advance();
        } else {
          break;
        }
      } else {
        lines.add(_removeIndentation(line));
        parser.advance();
      }
    }

    // Parse as blocks for multi-paragraph content.
    final nodes = md.BlockParser(
      lines.map(md.Line.new).toList(growable: false),
      parser.document,
    ).parseLines(parentSyntax: this);
    return md.Element('dd', nodes);
  }

  bool _isDefinitionListStart(md.BlockParser parser) {
    if (parser.isDone) return false;

    // Check if current line is a definition.
    if (_isDefinition(parser)) return true;

    // Check if current line is a term followed by a definition.
    if (_isTerm(parser)) {
      final nextLine = parser.peek(1);
      return nextLine != null && pattern.hasMatch(nextLine.content);
    }

    return false;
  }

  bool _isTerm(md.BlockParser parser) {
    final content = parser.current.content;
    return content.trim().isNotEmpty &&
        !content.startsWith(' ') &&
        !content.startsWith('\t') &&
        !pattern.hasMatch(content);
  }

  bool _isDefinition(md.BlockParser parser) {
    return pattern.hasMatch(parser.current.content);
  }

  bool _isDefinitionContinuation(md.BlockParser parser) {
    final content = parser.current.content;
    return !pattern.hasMatch(content) &&
        (content.trim().isEmpty ||
            content.startsWith('  ') ||
            content.startsWith('\t'));
  }

  bool _shouldIncludeEmptyLine(md.BlockParser parser) {
    final nextLine = parser.peek(1);
    if (nextLine == null) return false;

    return nextLine.content.startsWith('  ') ||
        nextLine.content.startsWith('\t') ||
        pattern.hasMatch(nextLine.content);
  }

  String _removeIndentation(String line) {
    if (line.startsWith('  ')) {
      return line.substring(2);
    } else if (line.startsWith('\t')) {
      return line.substring(1);
    }
    return line;
  }

  void _skipEmptyLines(md.BlockParser parser) {
    while (!parser.isDone && parser.current.content.trim().isEmpty) {
      parser.advance();
    }
  }
}
