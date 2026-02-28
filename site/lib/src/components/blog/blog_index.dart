import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../models/blog.dart';
import 'blog_card.dart';
import 'client/blog_categories.dart';

class BlogIndex extends StatelessComponent {
  const BlogIndex({super.key});

  @override
  Component build(BuildContext context) {
    final posts = context.pages
        .where((page) => page.url.startsWith('/blog/'))
        .sortedBy(
          (page) =>
              DateTime.tryParse(
                page.data.page['publishDate'] as String? ?? '',
              ) ??
              DateTime(1970),
        )
        .reversed
        .toList();

    return div(classes: 'blog-index', [
      const BlogCategories(),
      div(
        id: 'blog-container',
        classes: 'blog-posts-grid',
        attributes: {'data-selected': 'all'},
        [
          for (var i = 0; i < posts.length; i++)
            BlogCard(
              post: Post(posts[i].data.page),
              url: posts[i].url,
              isFeatured: i == 0,
              className: i == 0
                  ? 'layout-featured'
                  : (i < 5 ? 'layout-grid' : 'layout-list'),
            ),
        ],
      ),
    ]);
  }
}
