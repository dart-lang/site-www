// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr_content/jaspr_content.dart';

/// Information about a page's source location and related URLs.
class PageSourceInfo {
  const PageSourceInfo({
    required this.issueUrl,
    this.sourceUrl,
  });

  /// The URL to create a new issue for this page.
  final String issueUrl;

  /// The URL to view the source of this page on GitHub.
  ///
  /// This will be `null` if the page doesn't have an `inputPath`.
  final String? sourceUrl;
}

extension PageSourceInfoExtension on Page {
  /// Returns the source information for this page.
  PageSourceInfo get sourceInfo {
    final pageUrl = url;
    final pageData = data.page;
    final siteData = data.site;
    final branch = siteData['branch'] as String? ?? 'main';
    final repoLinks = siteData['repo'] as Map<String, Object?>? ?? {};
    final repoUrl =
        repoLinks['this'] as String? ?? 'https://github.com/dart-lang/site-www';
    final inputPath = pageData['inputPath'] as String?;
    final siteUrl = siteData['url'] as String? ?? 'https://dart.dev';

    final fullPageUrl = '$siteUrl$pageUrl';
    final String issueUrl;
    final String? pageSourceUrl;

    if (inputPath != null) {
      pageSourceUrl = '$repoUrl/blob/$branch/${inputPath.replaceAll('./', '')}';
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl&page-source=$pageSourceUrl';
    } else {
      pageSourceUrl = null;
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl';
    }

    return PageSourceInfo(
      issueUrl: issueUrl,
      sourceUrl: pageSourceUrl,
    );
  }
}
