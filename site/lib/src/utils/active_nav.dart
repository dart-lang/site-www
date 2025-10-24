// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

ActiveNavEntry? activeNavEntry(String pageUrlPath) {
  final firstFragment = pageUrlPath
      .split('/')
      .firstWhereOrNull((fragment) => fragment.isNotEmpty)
      ?.trim()
      .toLowerCase();

  return switch (firstFragment) {
    'overview' => ActiveNavEntry.overview,
    'community' => ActiveNavEntry.community,
    'get-started' => ActiveNavEntry.learn,
    'get-dart' => ActiveNavEntry.getDart,
    'deprecated' ||
    'docs' ||
    'effective-dart' ||
    'get-started' ||
    'interop' ||
    'language' ||
    'libraries' ||
    'null-safety' ||
    'resources' ||
    'server' ||
    'tools' ||
    'tutorials' ||
    'web' ||
    'multiplatform-apps' => ActiveNavEntry.docs,
    _ => null,
  };
}

enum ActiveNavEntry {
  overview,
  community,
  getDart,
  docs,
  learn,
}
