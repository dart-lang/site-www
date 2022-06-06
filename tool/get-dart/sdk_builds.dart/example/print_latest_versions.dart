// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library sdk_builds.example;

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
  var info = await _dd.fetchVersion(channel, 'latest');

  print('$channel\t${info.version}');
}
