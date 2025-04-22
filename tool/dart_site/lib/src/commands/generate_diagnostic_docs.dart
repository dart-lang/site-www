// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:args/command_runner.dart';

import '../diagnostics/diagnostics.dart' as diagnostics;
import '../diagnostics/linter.dart' as linter;

final class GenerateDiagnosticDocs extends Command<int> {
  GenerateDiagnosticDocs();

  @override
  String get description => 'Generate and update diagnostic docs.';

  @override
  String get name => 'generate-diagnostics';

  @override
  Future<int> run() => _update();
}

Future<int> _update() async {
  print('Updating src/_data/linter_rules.json...');
  await _updateLintInfo();

  print('Updating src/content/tool/diagnostic-messages.md...');
  await _updateDiagnosticDocs();

  return 0;
}

Future<void> _updateLintInfo() async {
  await linter.fetchAndUpdate();
}

Future<void> _updateDiagnosticDocs() async {
  await diagnostics.generate();
}
