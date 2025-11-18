// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:yaml/yaml.dart';

import 'lint_descriptions.dart';

/// Parses lint rules from the fetched YAML source data.
List<Map<String, Object?>> parseLintRules({
  required String messagesYaml,
  required String fixStatusYaml,
  required String coreLintsYaml,
  required String recommendedLintsYaml,
  required String flutterLintsYaml,
}) {
  final messagesRoot = loadYaml(messagesYaml) as YamlMap;
  final lintRulesRoot = messagesRoot['LinterLintCode'] as YamlMap;

  final fixStatuses = _parseFixStatuses(loadYaml(fixStatusYaml) as YamlMap);
  final coreLints = _parseLintSet(loadYaml(coreLintsYaml) as YamlMap);
  final recommendedLints = _parseLintSet(
    loadYaml(recommendedLintsYaml) as YamlMap,
  );
  final flutterLints = _parseLintSet(loadYaml(flutterLintsYaml) as YamlMap);

  final lintRules = <Map<String, Object?>>[];
  for (final MapEntry(key: String rawName, value: YamlMap data)
      in lintRulesRoot.entries) {
    if (!data.containsKey('deprecatedDetails')) {
      // Every documentable lint currently needs the 'deprecatedDetails' field.
      continue;
    }

    final name = data['sharedName'] as String? ?? rawName;
    final categories = [
      if (data['categories'] case final YamlList categories)
        for (final category in categories) category as String,
    ];
    final states = [
      if (data['state'] case final YamlMap statesData)
        for (final MapEntry(key: String type, value: String? since)
            in statesData.entries)
          if (since != null) {'type': type, 'since': since},
    ];

    if (states.any((s) => s['type'] == 'internal')) {
      // We shouldn't generate docs about any internal lint rules.
      continue;
    }

    final incompatible = [
      if (data['incompatible'] case final YamlList incompatibleLints)
        for (final lintName in incompatibleLints) lintName as String,
    ];
    final sets = _determineSets(
      name,
      coreLints,
      recommendedLints,
      flutterLints,
    );
    final fixStatus = fixStatuses[name] ?? 'needsFix';
    final description = descriptionOfLint(name);
    final justification = data['deprecatedDetails'] as String;
    final hasDiagnosticDocs =
        (data['documentation'] as String?)?.isNotEmpty ?? false;

    lintRules.add({
      'name': name,
      'description': description,
      'categories': categories,
      'states': states,
      'incompatible': incompatible,
      'sets': sets,
      'fixStatus': fixStatus,
      'justification': justification,
      'hasDiagnosticDocs': hasDiagnosticDocs,
    });
  }

  return lintRules.sortedBy((l) => l['name'] as String).toList(growable: false);
}

/// Determines which lint sets include this rule.
List<String> _determineSets(
  String lintName,
  Set<String> coreLints,
  Set<String> recommendedLints,
  Set<String> flutterLints,
) {
  // If it's in core, it's also in recommended and flutter.
  if (coreLints.contains(lintName)) {
    return const ['core', 'recommended', 'flutter'];
  }

  // If it's in recommended, it's also in flutter.
  if (recommendedLints.contains(lintName)) {
    return const ['recommended', 'flutter'];
  }

  // Check if it's only in flutter.
  if (flutterLints.contains(lintName)) {
    return const ['flutter'];
  }

  return const [];
}

/// Parses the fix status YAML to get a map of lint names to fix statuses.
Map<String, String> _parseFixStatuses(YamlMap fixStatusMap) => {
  for (final MapEntry(key: String code, :YamlMap value) in fixStatusMap.entries)
    // Each entry's value is a YamlMap with a 'status' field.
    if (value['status'] case final String status)
      // The code might be prefixed (such as 'LinterCode.lint_name').
      // Extract just the lint name to use the key.
      code.split('.').last: _normalizeFixStatus(status),
};

/// Normalizes the fix status to one of: hasFix, noFix, needsFix.
String _normalizeFixStatus(String status) =>
    switch (status.toLowerCase().trim()) {
      'hasfix' => 'hasFix',
      'noFix' => 'noFix',
      'needsFix' => 'needsFix',
      _ => 'needsFix',
    };

/// Parses a lint set YAML file to extract lint rule names.
Set<String> _parseLintSet(YamlMap lintSetMap) => {
  if (lintSetMap['linter'] case final YamlMap linter)
    if (linter['rules'] case final YamlList rules)
      for (final rule in rules)
        if (rule is String) rule,
};
