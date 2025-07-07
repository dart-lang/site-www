import 'package:markdown/markdown.dart' as md;

import '../util.dart';

/// A custom header syntax that extends HeaderSyntax to support:
///
/// 1. Inline attribute syntax at the end of headers
///    (e.g., `# Title {: #custom-id .class}`)
/// 2. Auto-generated IDs using slugify when no attributes are provided
final class HeaderWithAttributesSyntax extends md.HeaderSyntax {
  const HeaderWithAttributesSyntax();

  static final _attributeEndPattern = RegExp(r'\s*\{:\s*([^}]+)\}\s*$');

  @override
  md.Node parse(md.BlockParser parser) {
    final element = super.parse(parser) as md.Element;

    // Check if the header text ends with attribute syntax.
    final children = element.children;
    if (children != null && children.isNotEmpty) {
      final lastChild = children.last;
      final childText = lastChild.textContent;
      final match = _attributeEndPattern.firstMatch(childText);

      if (match != null) {
        // Extract and parse the attributes.
        final attributeString = match.group(1)!.trim();
        final attributes = parseAttributes(attributeString);

        // Remove the attribute syntax from the text.
        final cleanText = childText.substring(0, match.start).trim();
        children[children.length - 1] = md.Text(cleanText);

        // Apply the parsed attributes to the header element.
        element.attributes.addAll(attributes);
      }

      // If no ID was specified otherwise, generate an ID from the content.
      if (!element.attributes.containsKey('id')) {
        if (childText.isNotEmpty) {
          element.attributes['id'] = slugify(childText);
        }
      }
    }

    return element;
  }
}
