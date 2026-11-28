// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:site_shared/components/common/client/feedback.dart';

import '../../utils/page_source_info.dart';

/// The trailing content of a content documentation page, such as
/// its last updated information, report an issue links, and similar.
class TrailingContent extends StatelessComponent {
  const TrailingContent({super.key});

  @override
  Component build(BuildContext context) {
    final page = context.page;
    final pageData = page.data.page;
    final siteData = page.data.site;
    final pageDate = pageData['date'] as String?;

    final documentedDartVersion = _parseDocumentedDartVersion(
      siteData['documentedDartVersion'],
    );

    final sourceInfo = page.sourceInfo;
    final issueUrl = sourceInfo.issueUrl;
    final pageSource = sourceInfo.sourceUrl;

    return div(
      id: 'trailing-content',
      attributes: {'data-nosnippet': 'true'},
      [
        FeedbackComponent(issueUrl: issueUrl),

        p(id: 'page-github-links', [
          span([
            .text(
              'Unless stated otherwise, the documentation on '
              'this site reflects Dart $documentedDartVersion. ',
            ),
            if (pageDate != null)
              .text(
                'Page last updated on $pageDate. ',
              ),
          ]),
          if (pageSource != null) ...[
            a(
              href: pageSource,
              attributes: {'target': '_blank', 'rel': 'noopener'},
              [const .text('View source')],
            ),
            const span([.text(' or ')]),
          ],
          a(
            href: issueUrl,
            attributes: {
              'title': 'Report an issue with this page',
              'target': '_blank',
              'rel': 'noopener',
            },
            [.text(pageSource == null ? 'Report an issue' : 'report an issue')],
          ),
          const .text('.'),
        ]),
      ],
    );
  }

  static final _documentedDartVersionPattern = RegExp(
    r'^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$',
  );

  static String _parseDocumentedDartVersion(Object? value) {
    if (value is! String || !_documentedDartVersionPattern.hasMatch(value)) {
      throw FormatException(
        'documentedDartVersion in src/data/site.yaml must be a quoted string '
        'in "major.minor" format, such as "3.14". '
        'Received: $value (${value.runtimeType}).',
      );
    }
    return value;
  }
}
