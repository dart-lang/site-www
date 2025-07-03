import 'package:html/parser.dart' as html show parseFragment;
import 'package:jaspr_content/jaspr_content.dart';
import 'package:markdown/markdown.dart' as md;

import 'alert_syntax.dart';
import 'attribute_syntax.dart';
import 'definition_list_syntax.dart';
import 'fenced_code_block_syntax.dart';

final md.Document _sharedMarkdownDocument = md.Document(
  blockSyntaxes: const [
    CustomHtmlSyntax(),
    CustomFencedCodeBlockSyntax(),
    AttributeBlockSyntax(),
    AlertBlockSyntax(),
    DefinitionListSyntax(),
    md.HeaderWithIdSyntax(),
    md.TableSyntax(),
    md.FootnoteDefSyntax(),
  ],
  inlineSyntaxes: [
    md.InlineHtmlSyntax(),
  ],
);

String parseMarkdownToHtml(String markdown, {bool inline = false}) {
  final nodes = inline
      ? _sharedMarkdownDocument.parseInline(markdown)
      : _sharedMarkdownDocument.parse(markdown);
  final renderer = md.HtmlRenderer();
  return renderer.render(nodes);
}

class DashMarkdownParser implements PageParser {
  static final _attributePostProcessor = AttributePostProcessor();
  static final RegExp _markdownPattern = RegExp(r'.*\.md?$');

  const DashMarkdownParser();

  @override
  Pattern get pattern => _markdownPattern;

  @override
  List<Node> parsePage(Page page) => _parseContent(page.content);

  static List<Node> _parseContent(String content) {
    final markdownNodes = _sharedMarkdownDocument.parse(content);

    final tempElement = md.Element('temp-dash-document', markdownNodes);
    tempElement.accept(_attributePostProcessor);

    return _buildNodes(tempElement.children ?? []);
  }

  static List<Node> _buildNodes(Iterable<md.Node> markdownNodes) {
    final nodes = <Node>[];
    for (final node in markdownNodes) {
      if (node is md.Text) {
        nodes.addAll(
          HtmlParser.buildNodes(html.parseFragment(node.text).nodes),
        );
      } else if (node is md.Element) {
        final nodeChildren = node.children;
        final children = nodeChildren != null
            ? _buildNodes(nodeChildren)
            : null;
        nodes.add(
          ElementNode(
            node.tag,
            {
              if (node.generatedId case final generatedId?) 'id': generatedId,
              ...node.attributes,
            },
            children,
          ),
        );
      }
      // Ignore other types of nodes, such as comments.
    }
    return nodes;
  }
}
