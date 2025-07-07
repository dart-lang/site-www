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
