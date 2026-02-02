// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/common/breadcrumbs.dart';
import '../components/layout/toc.dart';
import '../components/layout/trailing_content.dart';
import '../models/on_this_page_model.dart';
import '../util.dart';
import 'dash_layout.dart';

/// The Jaspr Content layout to use for blog pages,
/// adding elements such as breadcrumbs.
class BlogLayout extends DashLayout {
  const BlogLayout();

  @override
  String get name => 'blog';

  @override
  String get defaultSidenav => 'blog';

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final pageTitle = pageData['title'] as String? ?? 'Untitled';
    final tocData = OnThisPageData.fromPage(page);

    return super.buildBody(
      page,
      Component.fragment(
        [
          if (tocData == null)
            const Document.body(attributes: {'data-toc': 'false'})
          else
            NarrowTableOfContents(
              tocData,
              currentTitle: pageTitle,
            ),
          ?buildBanner(page),
          div(classes: 'after-leading-content', [
            if (tocData != null)
              aside(id: 'side-menu', [
                WideTableOfContents(tocData),
              ]),
            article([
              div(classes: 'content', [
                div(id: 'site-content-title', [
                  h1(id: 'document-title', [
                    if (pageData['underscore_breaker_titles'] == true)
                      ...splitByUnderscore(pageTitle)
                    else
                      .text(pageTitle),
                  ]),
                  if (pageData['showBreadcrumbs'] != false)
                    const PageBreadcrumbs(),
                ]),

                child,
                const TrailingContent(),
              ]),
            ]),
          ]),
        ],
      ),
    );
  }
}
