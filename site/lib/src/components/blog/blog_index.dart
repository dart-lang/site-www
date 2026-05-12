// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../models/blog.dart';
import 'blog_card.dart';
import 'client/blog_categories.dart';

extension PostIndex on BuildContext {
  List<({String url, Post post})> get blogPosts => pages
      .where((page) => page.url.startsWith('/blog/'))
      .sortedBy(
        (page) =>
            DateTime.tryParse(page.data.page['publishDate'] as String? ?? '') ??
            DateTime(1970),
      )
      .reversed
      .map((page) => (url: page.url, post: Post(page.data.page)))
      .toList();
}

class BlogIndex extends StatelessComponent {
  const BlogIndex({super.key});

  @override
  Component build(BuildContext context) {
    final posts = context.blogPosts;

    return div(classes: 'blog-index', [
      const BlogCategories(),
      div(
        id: 'blog-container',
        classes: 'blog-posts-grid',
        attributes: {'data-selected': 'all'},
        [
          for (var i = 0; i < posts.length; i++)
            BlogCard(
              post: posts[i].post,
              url: posts[i].url,
              className: i == 0
                  ? 'layout-featured'
                  : (i < 5 ? 'layout-grid' : 'layout-list'),
            ),
        ],
      ),
    ]);
  }
}
