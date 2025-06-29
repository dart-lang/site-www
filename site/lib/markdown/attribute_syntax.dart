import 'package:markdown/markdown.dart' as md;

/// A markdown extension that adds support for attribute syntax.
///
/// Supports syntax like:
/// - `{: #new-id}` - sets the element's HTML ID
/// - `{: .custom-class}` - adds a class to the element
/// - `{: #custom-id .custom-class}` - sets ID and adds class
/// - `{: .class1 .class2}` - adds multiple classes
///
/// This works by detecting attribute blocks and applying them to the
/// preceding block element.
final class AttributeBlockSyntax extends md.BlockSyntax {
  const AttributeBlockSyntax();

  static final RegExp _pattern = RegExp(r'^\{:\s*([^}]+)\}\s*$');

  @override
  RegExp get pattern => _pattern;

  @override
  md.Node? parse(md.BlockParser parser) {
    final currentLine = parser.current;
    final match = pattern.firstMatch(currentLine.content);
    if (match == null) return null;

    final attributeString = match[1]!.trim();
    parser.advance();

    // Create a special marker element that will be processed later
    // This approach allows us to apply attributes during post-processing
    final attributes = _parseAttributes(attributeString);
    return md.Element('attribute-marker', [])..attributes.addAll(attributes);
  }

  Map<String, String> _parseAttributes(String attributeString) {
    final attributes = <String, String>{};
    final parts = attributeString.split(RegExp(r'\s+'));
    final classes = <String>[];

    for (final part in parts) {
      if (part.startsWith('#')) {
        // ID attribute
        attributes['id'] = part.substring(1);
      } else if (part.startsWith('.')) {
        // Class attribute
        classes.add(part.substring(1));
      }
    }

    if (classes.isNotEmpty) {
      attributes['class'] = classes.join(' ');
    }

    return attributes;
  }
}

/// Post-processor that finds attribute-marker elements and applies their
/// attributes to the preceding block element, then removes the markers.
final class AttributePostProcessor extends md.NodeVisitor {
  void _applyAttributesToElement(
    md.Element element,
    Map<String, String> attributes,
  ) {
    for (final entry in attributes.entries) {
      if (entry.key == 'class') {
        final existingClass = element.attributes['class'];
        if (existingClass != null && existingClass.isNotEmpty) {
          element.attributes['class'] = '$existingClass ${entry.value}';
        } else {
          element.attributes['class'] = entry.value;
        }
      } else {
        // For other attributes (such as id), set them directly.
        element.attributes[entry.key] = entry.value;
      }
    }
  }

  @override
  bool visitElementBefore(md.Element element) {
    final elementChildren = element.children;
    if (elementChildren == null) return false;
    final childrenToRemove = <md.Node>[];

    for (var i = 0; i < elementChildren.length; i++) {
      final child = elementChildren[i];

      if (child is md.Element && child.tag == 'attribute-marker') {
        // Found an attribute marker,
        // apply its attributes to the previous element.
        if (i > 0) {
          final previousElement = elementChildren[i - 1];
          if (previousElement is md.Element) {
            _applyAttributesToElement(previousElement, child.attributes);
          }
        }
        // Mark this marker for removal.
        childrenToRemove.add(child);
      } else {
        // Continue visiting other children.
        child.accept(this);
      }
    }

    // Remove all attribute markers.
    for (final child in childrenToRemove) {
      elementChildren.remove(child);
    }

    return true;
  }

  @override
  void visitElementAfter(md.Element element) {}

  @override
  void visitText(md.Text text) {}
}
