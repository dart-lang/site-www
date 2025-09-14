// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/breadcrumbs.dart';
import '../components/prev_next.dart';
import '../components/toc.dart';
import '../components/trailing_content.dart';
import '../util.dart';
import 'dash_layout.dart';

/// The Jaspr Content layout to use for normal docs pages,
/// adding elements such as breadcrumbs, TOC, and prev/next cards.
class DocLayout extends DashLayout {
  const DocLayout();

  @override
  String get name => 'docs';

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final pageTitle = pageData['title'] as String;
    final showToc = pageData['showToc'] as bool? ?? true;
    final tocData = showToc ? page.data['toc'] as TableOfContents? : null;
    final noToc = tocData == null || tocData.entries.length < 2;
    final maxTocDepth = pageData['maxTocDepth'] as int?;

    return super.buildBody(
      page,
      Component.fragment(
        [
          if (noToc)
            const Document.body(attributes: {'data-toc': 'false'})
          else if (tocData case final TableOfContents toc)
            TopTableOfContents(
              toc,
              currentTitle: pageTitle,
              maxDepth: maxTocDepth,
            ),
          div(classes: 'after-leading-content', [
            if (!noToc)
              if (tocData case final TableOfContents toc)
                aside(id: 'side-menu', [
                  SideTableOfContents(toc, maxDepth: maxTocDepth),
                ]),
            article([
              div(classes: 'content', [
                div(id: 'site-content-title', [
                  h1(id: 'document-title', [
                    if (pageData['underscore_breaker_titles'] == true)
                      ...splitByUnderscore(pageTitle)
                    else
                      text(pageTitle),
                  ]),
                  if (pageData['showBreadcrumbs'] != false)
                    const PageBreadcrumbs(),
                ]),

                child,

                PrevNext(
                  previousPage: _pageInfoFromObject(pageData['prevpage']),
                  nextPage: _pageInfoFromObject(pageData['nextpage']),
                ),
                const TrailingContent(),
              ]),
            ]),
          ]),
        ],
      ),
    );
  }
}

({String url, String title})? _pageInfoFromObject(Object? data) {
  if (data case {
    'url': final String pageUrl,
    'title': final String pageTitle,
  }) {
    return (url: pageUrl, title: pageTitle);
  }

  return null;
}
