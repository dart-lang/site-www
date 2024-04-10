// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:yaml_variable_scanner/yaml_variable_scanner.dart';

import '../utils.dart';

final class CheckSiteVariableCommand extends Command<int> {
  static const String _printModeFlag = 'print-mode';

  CheckSiteVariableCommand() {
    argParser.addOption(
      _printModeFlag,
      help: 'Configure the amount of information output.',
      allowed: ['none', 'detail', 'stats', 'detailAndStats'],
      allowedHelp: {
        'none': 'No content.',
        'detail': 'Detail to file lines and columns.',
        'stats': 'Total statistics.',
        'detailAndStats': 'detail & stats.',
      },
      defaultsTo: 'detail',
    );
  }

  @override
  String get description =>
      'Scan multiple files for text that can use site variables.';

  @override
  String get name => 'check-site-variable';

  @override
  Future<int> run() async {
    final printMode = argResults.get<String>(_printModeFlag, 'detail');

    try {
      final checkResultAll = await YamlVariableScanner.run(
        './tool/config/site_variable_scanner.yaml',
        stdout,
        printMode: PrintMode.values.byName(printMode),
      );
      if (checkResultAll.isNotEmpty) return 2;
      return 0;
    } catch (e, stackTrace) {
      stderr.writeln('Error: YamlVariableScanner failed to execute properly!');
      stderr.writeln(e);
      stderr.writeln(stackTrace);
      return 1;
    }
  }
}
