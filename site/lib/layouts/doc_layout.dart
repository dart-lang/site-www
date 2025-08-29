// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/breadcrumbs.dart';
import '../components/navigation_toc_side.dart';
import '../components/navigation_toc_top.dart';
import '../components/prev_next.dart';
import '../components/trailing_content.dart';
import '../util.dart';
import 'dash_layout.dart';

class DocLayout extends DashLayout {
  const DocLayout();

  @override
  String get name => 'docs';

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final pageTitle = pageData['title'] as String;

    return super.buildBody(
      page,
      Component.fragment(
        [
          if (pageData['showToc'] != false)
            if (page.data['toc'] case final TableOfContents toc)
              NavigationTocSide(
                toc: toc,
                maxDepth: pageData['maxTocDepth'] as int?,
              ),
          article([
            div(classes: 'content', [
              div(id: 'site-content-title', [
                h1([
                  if (pageData['underscore_breaker_titles'] == true)
                    ...underscoreBreaker(pageTitle)
                  else
                    text(pageTitle),
                ]),
                if (pageData['showBreadcrumbs'] != false)
                  const PageBreadcrumbs(),
              ]),

              if (page.data['showToc'] != false)
                if (page.data['toc'] case final TableOfContents toc)
                  NavigationTocTop(
                    toc: toc,
                    maxDepth: pageData['maxTocDepth'] as int?,
                  ),
              child,

              PrevNext(
                previousPage: _pageInfoFromObject(pageData['prevpage']),
                nextPage: _pageInfoFromObject(pageData['nextpage']),
              ),
              const TrailingContent(),
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
