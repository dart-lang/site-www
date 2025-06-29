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
