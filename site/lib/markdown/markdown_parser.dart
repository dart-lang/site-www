import 'dart:collection';

import 'package:html/parser.dart' as html;
// ignore: implementation_imports
import 'package:html/src/token.dart' as html;
// ignore: implementation_imports
import 'package:html/src/tokenizer.dart' as html;
import 'package:jaspr_content/jaspr_content.dart';
import 'package:markdown/markdown.dart' as md;

import 'alert_syntax.dart';
import 'attribute_syntax.dart';
import 'definition_list_syntax.dart';
import 'fenced_code_block_syntax.dart';
import 'header_syntax.dart';

final md.Document sharedMarkdownDocument = md.Document(
  blockSyntaxes: const [
    JasprHtmlBlockSyntax(),
    CustomFencedCodeBlockSyntax(),
    HeaderWithAttributesSyntax(),
    AttributeBlockSyntax(),
    AlertBlockSyntax(),
    DefinitionListSyntax(),
    md.TableSyntax(),
    md.FootnoteDefSyntax(),
    md.EmptyBlockSyntax(),
    md.BlockquoteSyntax(),
    md.HorizontalRuleSyntax(),
    md.UnorderedListSyntax(),
    md.OrderedListSyntax(),
    md.LinkReferenceDefinitionSyntax(),
    md.ParagraphSyntax(),
  ],
  inlineSyntaxes: [
    md.InlineHtmlSyntax(),
    AttributeInlineSyntax(),
  ],
  withDefaultBlockSyntaxes: false,
);

String parseMarkdownToHtml(String markdown, {bool inline = false}) {
  final nodes = inline
      ? sharedMarkdownDocument.parseInline(markdown)
      : sharedMarkdownDocument.parse(markdown);
  final renderer = md.HtmlRenderer();
  return renderer.render(nodes);
}

final RegExp _markdownFilePattern = RegExp(r'.*\.md$');

// TODO(parlough): Switch back to Jaspr's built in Markdown parser.
class DashMarkdownParser implements PageParser {
  const DashMarkdownParser();

  @override
  Pattern get pattern => _markdownFilePattern;

  @override
  List<Node> parsePage(Page page) {
    final markdownNodes = sharedMarkdownDocument.parse(page.content);

    return _buildNodes(markdownNodes);
  }

  static List<Node> _buildNodes(Iterable<md.Node> markdownNodes) {
    // ignore: prefer_const_constructors
    final root = ElementNode('_', {}, []);
    final stack = Queue<ElementNode>();
    stack.add(root);
    var currentNodes = root.children!;

    for (final node in markdownNodes) {
      if (node is HtmlText) {
        final tokenizer = html.HtmlTokenizer(
          node.text,
          lowercaseElementName: false,
        );

        while (tokenizer.moveNext()) {
          final token = tokenizer.current;

          if (token.kind == html.TokenKind.parseError) {
            final error = (token as html.ParseErrorToken).data;
            if (error == 'expected-tag-name-but-got-question-mark') {
              // Ignore opening of processing instructions.
              continue;
            } else {
              throw AssertionError('Unexpected parse error: ${token.data}');
            }
          }

          if (token.kind == html.TokenKind.startTag) {
            final tag = (token as html.StartTagToken).name ?? '';
            final attributes = token.data.map(
              (k, v) => MapEntry(k.toString(), v),
            );
            final element = ElementNode(tag, attributes, []);
            currentNodes.add(element);
            final selfClosing =
                token.selfClosing || _isVoidElement(token.name ?? '');
            if (!selfClosing) {
              stack.add(element);
              currentNodes = element.children!;
            }
          } else if (token.kind == html.TokenKind.endTag) {
            if (stack.last.tag != (token as html.EndTagToken).name) {
              // If the end tag does not match the last opened tag, ignore it.
              continue;
            }
            stack.removeLast();
            currentNodes = stack.last.children!;
          } else if (token.kind == html.TokenKind.characters ||
              token.kind == html.TokenKind.spaceCharacters) {
            currentNodes.add(TextNode((token as html.StringToken).data));
          } else if (token.kind == html.TokenKind.comment) {
            // Drop HTML comments from the output.
          } else if (token.kind == html.TokenKind.doctype) {
            // Ignore doctype tokens.
            continue;
          }
        }
      } else if (node is md.Text) {
        currentNodes.addAll(
          HtmlParser.buildNodes(html.parseFragment(node.text).nodes),
        );
      } else if (node is md.Element) {
        final children = _buildNodes(node.children ?? []);
        currentNodes.add(
          ElementNode(
            node.tag,
            {
              if (node.generatedId != null) 'id': node.generatedId!,
              ...node.attributes,
            },
            children,
          ),
        );
      }
    }

    return root.children!;
  }
}

bool _isVoidElement(String tag) => {
  'area',
  'base',
  'br',
  'col',
  'embed',
  'hr',
  'img',
  'input',
  'link',
  'meta',
  'param',
  'source',
  'track',
  'wbr',
}.contains(tag.toLowerCase());
