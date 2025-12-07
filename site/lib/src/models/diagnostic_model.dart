// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:path/path.dart' as p;

import '../util.dart';

extension type DiagnosticInfo.fromJson(Map<String, Object?> info) {
  String get id => info['id'] as String;
  String get description => info['description'] as String;
  String? get documentation => info['documentation'] as String?;
  bool get hasDocumentation => info['hasDocumentation'] as bool? ?? false;
  bool get fromLint => info['fromLint'] as bool? ?? false;
  List<String> get previousNames =>
      (info['previousNames'] as List<Object?>).cast<String>();
}

/// Reads and parses information about diagnostics from
/// the `src/data/diagnostics.json` file.
List<DiagnosticInfo> readAndLoadDiagnostics() {
  if (_loadedDiagnostics case final alreadyLoadedDiagnostics?) {
    return alreadyLoadedDiagnostics;
  }

  final diagnosticsFile = File(
    p.join(siteSrcDirectoryPath, 'data', 'diagnostics.json'),
  );
  final rawDiagnosticInfo =
      jsonDecode(diagnosticsFile.readAsStringSync()) as List<Object?>;

  final diagnostics = rawDiagnosticInfo
      .cast<Map<String, Object?>>()
      .map(DiagnosticInfo.fromJson)
      .toList(growable: false);

  return _loadedDiagnostics = diagnostics;
}

/// A cache of the loaded and parsed diagnostic info.
List<DiagnosticInfo>? _loadedDiagnostics;
