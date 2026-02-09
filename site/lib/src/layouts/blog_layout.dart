// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/blog/author_card.dart';
import '../components/common/breadcrumbs.dart';
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

    final authorData = page.data['author_data'] as Map<String, dynamic>?;

    return super.buildBody(
      page,
      .fragment([
        const Document.body(attributes: {'data-toc': 'false'}),
        ?buildBanner(page),
        div(classes: 'after-leading-content', [
          article([
            div(classes: 'content', [
              div(id: 'site-content-title', [
                if (pageData['showBreadcrumbs'] != false)
                  const PageBreadcrumbs(),
                h1(id: 'document-title', [
                  if (pageData['underscore_breaker_titles'] == true)
                    ...splitByUnderscore(pageTitle)
                  else
                    .text(pageTitle),
                ]),
                if (pageData['description'] != null)
                  p(classes: 'subtitle', [
                    .text(pageData['description'] as String),
                  ]),
              ]),
              if (authorData != null)
                AuthorCard(
                  name: authorData['name'] as String,
                  bio: authorData['bio'] as String,
                  image: authorData['image'] as String?,
                  twitter: authorData['twitter'] as String?,
                  github: authorData['github'] as Map<String, dynamic>?,
                ),
              child,
            ]),
          ]),
        ]),
      ]),
    );
  }
}
