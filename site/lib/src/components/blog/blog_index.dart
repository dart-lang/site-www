import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'blog_list.dart';
export 'blog_list.dart';

class BlogIndex extends StatelessComponent {
  const BlogIndex({super.key});

  @override
  Component build(BuildContext context) {
    final page = context.page;
    final allPosts = (page.data['blog_posts'] as List?)
        ?.cast<Map<String, Object?>>();

    if (allPosts == null || allPosts.isEmpty) {
      return p([text('No blog posts found.')]);
    }

    return BlogList(posts: allPosts);
  }
}
