// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:args/command_runner.dart';

import '../diagnostics/diagnostics.dart' as diagnostics;

final class GenerateDiagnosticDocs extends Command<int> {
  @override
  String get description => 'Generate and update diagnostic docs.';

  @override
  String get name => 'generate-diagnostics';

  @override
  Future<int> run() => _updateDiagnosticDocs();
}

Future<int> _updateDiagnosticDocs() async {
  print('Updating src/content/tool/diagnostics/...');
  await diagnostics.generate();

  return 0;
}
