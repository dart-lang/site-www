import 'package:jaspr/jaspr.dart';

const productionBuild = bool.fromEnvironment('PRODUCTION');

List<Component> underscoreBreaker(String sourceString) {
  final parts = sourceString.split('_');
  final result = <Component>[];

  for (var i = 0; i < parts.length; i++) {
    result.add(text(parts[i]));

    // Add a word break opportunity after each underscore,
    // except for the final one.
    if (i < parts.length - 1) {
      result.add(text('_'));
      result.add(const DomComponent(tag: 'wbr'));
    }
  }

  return result;
}

String slugify(String text) {
  if (text.isEmpty) return text;

  return text
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[:.]'), '-')
      .replaceAll(RegExp(r'[^\p{L}\p{N}\s:._-]', unicode: true), '')
      .replaceAll(RegExp(r'[\s-]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

final RegExp _attributePattern = RegExp(r'(\w+)="([^"]*)"');
final RegExp _whitespacePattern = RegExp(r'\s+');

Map<String, String> parseAttributes(String attributeString) {
  final attributes = <String, String>{};
  final classes = <String>[];

  // Extract all key="value" pairs.
  final keyValueMatches = _attributePattern.allMatches(attributeString);
  for (final match in keyValueMatches) {
    final key = match.group(1)!;
    final value = match.group(2)!;
    attributes[key] = value;
  }

  // Remove all key="value" pairs to process remaining tokens.
  final remaining = attributeString.replaceAll(_attributePattern, '').trim();

  // Split remaining content by whitespace to find IDs and classes.
  final parts = remaining.split(_whitespacePattern);

  for (final part in parts) {
    if (part.isEmpty) continue;

    if (part.startsWith('#')) {
      attributes['id'] = part.substring(1);
    } else if (part.startsWith('.')) {
      classes.add(part.substring(1));
    }
  }

  if (classes.isNotEmpty) {
    attributes['class'] = classes.join(' ');
  }

  return attributes;
}
