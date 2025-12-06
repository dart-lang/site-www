// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'dash_layout.dart';

/// The Jaspr Content layout to use on the homepage of the site,
/// with various elements not added, such as a TOC.
class HomepageLayout extends DashLayout {
  const HomepageLayout();

  @override
  String get name => 'homepage';

  @override
  List<String> get defaultBodyClasses => ['sidenav-hidden', 'no-toc'];

  @override
  Component buildBody(Page page, Component child) {
    return super.buildBody(
      page,
      Component.fragment([
        ?buildBanner(page),
        child,
      ]),
    );
  }
}
