// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show jsonDecode;
import 'dart:io' show File;

import 'package:path/path.dart' as p;

import '../util.dart' show siteSrcDirectoryPath;

/// Reads and parses information about all non-internal lint rules from
/// the `src/data/lint-info.json` file.
List<LintRule> readAndLoadLints() {
  if (_loadedLints case final alreadyLoadedLints?) return alreadyLoadedLints;

  final lintRulesFile = File(
    p.join(siteSrcDirectoryPath, 'data', 'lint-info.json'),
  );
  final rawLintRules =
      jsonDecode(lintRulesFile.readAsStringSync()) as List<Object?>;

  print(rawLintRules);

  final lintRules = rawLintRules
      .cast<Map<String, Object?>>()
      .map(LintRule.fromJson)
      .where((rule) => rule.latestState.type != LintStateType.internal)
      .toList(growable: false);

  print(lintRules.length);

  return _loadedLints = lintRules;
}

/// A cache of the loaded and parsed lint rule info.
List<LintRule>? _loadedLints;

/// Represents a Dart analyzer lint rule with all its metadata.
final class LintRule {
  /// The name of the lint rule.
  final String name;

  /// A short description of the lint rule.
  final String description;

  /// The categories of the lint rule such as 'style' and 'errorProne'.
  final List<String> categories;

  /// The states of the lint rule with version information.
  final List<LintState> states;

  /// The names of the lint rules incompatible with this one.
  final List<String> incompatible;

  /// The lint sets this rule is in (`core`, `recommended`, `flutter`).
  final List<String> sets;

  /// The status of the fix for this lint rule.
  final LintFixStatus fixStatus;

  /// The justification for the lint rule from deprecatedDetails.
  final String justification;

  /// Whether the lint rule has published diagnostic documentation.
  final bool hasDiagnosticDocs;

  const LintRule({
    required this.name,
    required this.description,
    required this.categories,
    required this.states,
    required this.incompatible,
    required this.sets,
    required this.fixStatus,
    required this.justification,
    required this.hasDiagnosticDocs,
  });

  /// The most recent state of this lint.
  LintState get latestState => states.last;

  factory LintRule.fromJson(Map<String, Object?> json) => LintRule(
    name: json['name'] as String,
    description: json['description'] as String,
    categories: (json['categories'] as List<Object?>).cast<String>(),
    states: (json['states'] as List<Object?>)
        .cast<Map<String, Object?>>()
        .map(LintState.fromJson)
        .toList(growable: false),
    incompatible: (json['incompatible'] as List<Object?>).cast<String>(),
    sets: (json['sets'] as List<Object?>).cast<String>(),
    fixStatus: LintFixStatus.values.byName(json['fixStatus'] as String),
    justification: json['justification'] as String,
    hasDiagnosticDocs: json['hasDiagnosticDocs'] as bool,
  );
}

/// Represents the state of a lint rule at a specific version.
final class LintState {
  /// The type of state, such as stable or experimental.
  final LintStateType type;

  /// The SDK version when this state was introduced.
  final String since;

  const LintState({required this.type, required this.since});

  /// If this lint is in a released of the SDK.
  bool get isReleased {
    final standardizedSince = since.trim().toLowerCase();
    return standardizedSince != 'unreleased' &&
        !standardizedSince.contains('-wip');
  }

  factory LintState.fromJson(Map<String, Object?> json) => LintState(
    type: LintStateType.values.byName(json['type'] as String),
    since: json['since'] as String,
  );
}

enum LintFixStatus {
  hasFix,
  needsFix,
  noFix,
  unknown,
}

enum LintStateType {
  deprecated,
  experimental,
  internal,
  removed,
  stable,
}
