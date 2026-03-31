// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/blog/blog_next_posts.dart';
import '../components/blog/client/blog_categories.dart';
import '../components/blog/post_info.dart';
import '../components/common/breadcrumbs.dart';
import '../models/blog.dart';
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
  Iterable<Component> buildHead(Page page) {
    final isPost = page.url.startsWith('/blog/');
    if (isPost && page.data.page['titleBase'] == null) {
      page.apply(
        data: {
          'page': {'titleBase': 'The Dart Blog'},
        },
      );
    }
    return super.buildHead(page);
  }

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final pageTitle = pageData['title'] as String? ?? 'Untitled';
    final pageCategory = BlogCategory.fromSlug(pageData['category'] as String?);

    final isPost = page.url.startsWith('/blog/');

    return super.buildBody(
      page,
      .fragment([
        const Document.body(attributes: {'data-toc': 'false'}),
        div(classes: 'after-leading-content', [
          article([
            div(classes: 'content ${isPost ? 'post-content' : ''}', [
              div(id: 'site-content-title', [
                if (isPost)
                  PageBreadcrumbs(
                    crumbs: [
                      const BreadcrumbItem(
                        title: 'The Dart Blog',
                        url: '/blog',
                      ),
                      if (pageCategory != BlogCategory.other) ...[
                        BreadcrumbItem(
                          title: pageCategory.displayName,
                          url: '/blog?category=${pageCategory.slug}',
                        ),
                      ],
                      BreadcrumbItem(
                        title: pageTitle.split(':').first,
                        url: page.url,
                      ),
                    ],
                  ),
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
              if (isPost)
                PostInfo(
                  post: Post(pageData),
                  url: page.url,
                ),
              child,
              if (isPost)
                BlogNextPosts(
                  currentPage: page,
                  category: pageCategory,
                ),
            ]),
          ]),
        ]),
      ]),
    );
  }
}
