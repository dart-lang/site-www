// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'doc_layout.dart';

/// The Jaspr Content layout to use in the getting started tutorial.
class LearnLayout extends DocLayout {
  const LearnLayout();

  @override
  String get name => 'learn';

  @override
  List<String> get defaultBodyClasses => ['no-toc'];

  @override
  String get defaultSidenav => 'getStarted';

  @override
  bool get showTocDefault => false;
}
