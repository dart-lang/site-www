// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../util.dart';
import '../../utils/page_source_info.dart';
import 'breadcrumbs.dart';
import 'client/page_header_options.dart';

class PageHeader extends StatelessComponent {
  const PageHeader({
    super.key,
    required this.title,
    this.description,
    this.wrap = true,
    this.showBreadcrumbs = true,
    this.splitTitleByUnderscores = false,
  });

  final String title;
  final String? description;
  final bool wrap;
  final bool showBreadcrumbs;
  final bool splitTitleByUnderscores;

  @override
  Component build(BuildContext context) {
    final sourceInfo = context.page.sourceInfo;

    return header(
      id: 'site-content-title',
      classes: [if (wrap) 'wrap'].toClasses,
      [
        if (showBreadcrumbs) const PageBreadcrumbs(),
        h1(id: 'document-title', [
          if (splitTitleByUnderscores)
            ...splitByUnderscore(title)
          else
            text(title),
        ]),
        if (description case final description? when description.isNotEmpty)
          p(
            classes: ['page-description'].toClasses,
            [
              text(description),
            ],
          ),
        PageHeaderOptions(
          title: title,
          sourceUrl: sourceInfo.sourceUrl,
          issueUrl: sourceInfo.issueUrl,
        ),
      ],
    );
  }
}
