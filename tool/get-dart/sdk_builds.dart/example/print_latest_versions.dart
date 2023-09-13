// Copyright 2015 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:sdk_builds/sdk_builds.dart';

final _dd = DartDownloads();

void main() async {
  try {
    await latest('stable');
    await latest('dev');
  } finally {
    _dd.close();
  }
}

Future<void> latest(String channel) async {
  final info = await _dd.fetchVersion(channel, 'latest');

  print('$channel\t${info.version}');
}
