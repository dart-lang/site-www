// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dash_site/dash_site.dart';
import 'package:io/io.dart' as io;

void main(List<String> args) async {
  final runner = DashSiteCommandRunner();
  try {
    final result = await runner
        .run(args)
        .whenComplete(io.sharedStdIn.terminate);

    exit(result is int ? result : 0);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  } catch (e, stackTrace) {
    stderr.writeln(e);
    stderr.writeln(stackTrace);
    exit(1);
  }
}
