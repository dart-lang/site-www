// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

List<LintDetails> readAndLoadLints() {
  if (_loadedLints case final alreadyLoadedLints?) return alreadyLoadedLints;

  final lintRulesFile = File(p.join('..', 'src', 'data', 'linter_rules.json'));
  final rawLintRules =
      jsonDecode(lintRulesFile.readAsStringSync()) as List<Object?>;

  final lintRules = rawLintRules
      .cast<Map<String, Object?>>()
      .map(LintDetails._)
      .toList(growable: false);

  return _loadedLints = lintRules;
}

List<LintDetails>? _loadedLints;

// TODO(parlough): Once replacing rules.json, get rid of this structure.
extension type LintDetails._(Map<String, Object?> details) {
  String get name => details['name'] as String;
  String get id => name.trim();
  String get description => details['description'] as String;
  List<String> get categories =>
      (details['categories'] as List<Object?>).cast<String>();
  String get state => details['state'] as String;
  List<String> get incompatibleLints =>
      (details['incompatible'] as List<Object?>).cast<String>();
  List<String> get lintSets =>
      (details['sets'] as List<Object?>).cast<String>();
  String get fixStatus => details['fixStatus'] as String;
  String get docs => details['details'] as String;
  String get sinceDartSdk => details['sinceDartSdk'] as String;
}
