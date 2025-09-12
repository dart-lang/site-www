// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:args/command_runner.dart';

import '../diagnostics/linter.dart' as linter;

final class GenerateLintDocs extends Command<int> {
  @override
  String get description => 'Generate and update lint docs.';

  @override
  String get name => 'generate-lints';

  @override
  Future<int> run() => _updateLintInfo();
}

Future<int> _updateLintInfo() async {
  print('Updating src/_data/linter_rules.json...');
  await linter.fetchAndUpdate();

  return 0;
}
