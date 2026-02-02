import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'blog_list.dart';
export 'blog_list.dart';

class BlogIndex extends StatelessComponent {
  const BlogIndex({super.key});

  @override
  Component build(BuildContext context) {
    final allPosts = context.pages
        .where((page) => page.url.startsWith('/blog/'))
        .sortedBy(
          (page) =>
              DateTime.tryParse(page.data.page['date'] as String? ?? '') ??
              DateTime(1970),
        )
        .reversed
        .map(
          (page) => {
            'title': page.data.page['title'] ?? 'Untitled',
            'date': page.data.page['date'] ?? '',
            'description': page.data.page['description'] ?? '',
            'href': page.url,
            'image': page.data.page['image'],
            'author': page.data.page['author'],
            // 'avatar': avatarUrl,
            // 'author_url': profileUrl,
            'category':
                (page.data.page['category'] as String?)?.toLowerCase() ?? 'all',
          },
        )
        .toList();

    if (allPosts.isEmpty) {
      return const p([.text('No blog posts found.')]);
    }

    return BlogList(posts: allPosts);
  }
}
