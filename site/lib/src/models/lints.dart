// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../util.dart';

/// Reads and parses information about lint rules from
/// the `src/data/linter_rules.json` file.
List<LintDetails> readAndLoadLints() {
  if (_loadedLints case final alreadyLoadedLints?) return alreadyLoadedLints;

  final lintRulesFile = File(
    p.join(siteSrcDirectoryPath, 'data', 'linter_rules.json'),
  );
  final rawLintRules =
      jsonDecode(lintRulesFile.readAsStringSync()) as List<Object?>;

  final lintRules = rawLintRules
      .cast<Map<String, Object?>>()
      .map(LintDetails._)
      .toList(growable: false);

  return _loadedLints = lintRules;
}

/// A cache of the loaded and parsed lint rule info.
List<LintDetails>? _loadedLints;

/// Information about the Dart lint rule named [name].
// TODO(https://github.com/dart-lang/site-www/issues/4499):
//  Once replacing rules.json, get rid of this structure.
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
