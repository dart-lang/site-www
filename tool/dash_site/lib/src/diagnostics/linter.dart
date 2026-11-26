// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' show loadYaml;

import '../utils.dart';

String get _outputPath =>
    path.join(repositoryRoot, 'src', 'data', 'linter_rules.json');

/// Canonical mixed-case names for linter rules whose names were converted
/// to lowercase in newer SDK machine rules outputs.
const Map<String, String> _canonicalRuleNames = {
  'prefer_for_elements_to_map_fromiterable':
      'prefer_for_elements_to_map_fromIterable',
  'prefer_iterable_wheretype': 'prefer_iterable_whereType',
};

/// Sanitizes Markdown content in linter descriptions and details to prevent
/// unclosed HTML tag errors during site generation.
String _sanitizeLintMarkdown(String text) {
  var sanitized = text;

  // Wrap unbackticked `<Type>.toString()` in a code span.
  sanitized = sanitized.replaceAll(
    RegExp(r'(?<!`)<Type>\.toString\(\)(?!`)'),
    r'`<Type>.toString()`',
  );

  // Wrap single-quoted types with generic brackets like `'FutureOr<void>'`
  // in code spans.
  sanitized = sanitized.replaceAllMapped(
    RegExp(r"(?<!`)'([^'\n]*<[^'\n]+>)'(?!`)"),
    (match) => "`'${match.group(1)}'`",
  );

  return sanitized;
}

final Future<List<Map<String, Object?>>> _lintDocs = () async {
  final rawRulesInfoUri = Uri.parse(
    'https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/linter/tool/machine/rules.json',
  );
  final rawRulesInfo = await http.read(rawRulesInfoUri);
  final rulesInfo = (jsonDecode(rawRulesInfo) as List<Object?>)
      .cast<Map<String, Object?>>();

  final coreRules = await _rulesConfigured(
    'https://raw.githubusercontent.com/dart-lang/core/refs/heads/main/pkgs/lints/lib/core.yaml',
  );
  final recommendedRules = await _rulesConfigured(
    'https://raw.githubusercontent.com/dart-lang/core/refs/heads/main/pkgs/lints/lib/recommended.yaml',
  );
  final flutterRules = await _rulesConfigured(
    'https://raw.githubusercontent.com/flutter/packages/refs/heads/main/packages/flutter_lints/lib/flutter.yaml',
  );

  for (final rule in rulesInfo) {
    final rawName = rule['name'] as String;
    final ruleName = _canonicalRuleNames[rawName] ?? rawName;
    rule['name'] = ruleName;

    if (rule['description'] case final String description) {
      rule['description'] = _sanitizeLintMarkdown(description);
    }
    if (rule['details'] case final String details) {
      rule['details'] = _sanitizeLintMarkdown(details);
    }

    rule['sets'] = {
      if (coreRules.contains(ruleName) || coreRules.contains(rawName))
        ...['core', 'recommended', 'flutter'],
      if (recommendedRules.contains(ruleName) ||
          recommendedRules.contains(rawName))
        ...['recommended', 'flutter'],
      if (flutterRules.contains(ruleName) || flutterRules.contains(rawName))
        'flutter',
    }.toList(growable: false);
  }

  return rulesInfo;
}();

Future<Set<String>> get allLintNames async {
  return (await _lintDocs).map((l) => l['name'] as String).toSet();
}

Future<void> fetchAndUpdate() async {
  final formattedRuleInfo = const JsonEncoder.withIndent('  ')
      .convert(await _lintDocs);

  File(_outputPath).writeAsStringSync('$formattedRuleInfo\n');
}

Future<Set<String>> _rulesConfigured(String path) async {
  final optionsUri = Uri.parse(path);
  final optionsString = await http.read(optionsUri);
  final options = loadYaml(optionsString) as Map;

  // Assume the structure of the analysis options file.
  final linterOptions = options['linter'] as Map;
  final enabledRules = linterOptions['rules'] as List<Object?>;
  return {for (final ruleName in enabledRules) ruleName as String};
}
