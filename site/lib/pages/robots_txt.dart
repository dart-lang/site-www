// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../util.dart';

final class RobotsTxtOutput implements SecondaryOutput {
  static final _indexPattern = RegExp(r'/?index\..*');

  const RobotsTxtOutput();

  @override
  Pattern get pattern => _indexPattern;

  @override
  String createRoute(String _) => '/robots.txt';

  @override
  Component build(Page _) {
    return Builder(
      builder: (context) {
        context.setHeader('Content-Type', 'text/plain; charset=utf-8');
        final String textContent;
        if (productionBuild) {
          textContent = '''
User-agent: *
Disallow:

Sitemap: https://dart.dev/sitemap.xml
''';
        } else {
          textContent = '''
User-agent: linkcheck
Disallow:

User-agent: *
Disallow: /
''';
        }
        context.setStatusCode(200, responseBody: textContent);
        return const Component.empty();
      },
    );
  }
}
