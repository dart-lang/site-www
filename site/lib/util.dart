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
      result.add(const Text('_'));
      result.add(const DomComponent(tag: 'wbr'));
    }
  }

  return result;
}

String slugify(String text) => text
    .toLowerCase()
    .trim()
    .replaceAll(_slugifyPunctuationToReplace, '-')
    .replaceAll(_slugifyUnsupportedToRemove, '')
    .replaceAll(_slugifyCharsToCombine, '-')
    .replaceAll(_slugifyHyphenTrim, '');

final RegExp _slugifyPunctuationToReplace = RegExp(r'[:.]');
final RegExp _slugifyUnsupportedToRemove = RegExp(
  r'[^\p{L}\p{N}\s:._-]',
  unicode: true,
);
final RegExp _slugifyCharsToCombine = RegExp(r'[\s-]+');
final RegExp _slugifyHyphenTrim = RegExp(r'^-+|-+$');

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
