import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'blog_card.dart';

@client
class BlogList extends StatefulComponent {
  const BlogList({required this.posts, super.key});

  final List<Map<String, Object?>> posts;

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  String selectedCategory = 'all';

  static const categories = [
    'all',
    'spotlight',
    'events',
    'releases',
    'tutorials',
  ];

  @override
  Component build(BuildContext context) {
    final filteredPosts = selectedCategory == 'all'
        ? component.posts
        : component.posts
              .where((post) => post['category'] == selectedCategory)
              .toList();

    Map<String, dynamic>? featured;
    Iterable<Map<String, dynamic>> others = [];

    if (filteredPosts.isNotEmpty) {
      featured = filteredPosts.first;
      others = filteredPosts.skip(1);
    }

    return div(classes: 'blog-index', [
      // Categories
      div(classes: 'blog-categories', [
        for (final category in categories)
          button(
            classes:
                'blog-category-chip ${category == selectedCategory ? 'active' : ''}',
            onClick: () {
              setState(() {
                selectedCategory = category;
              });
            },
            [
              text(category[0].toUpperCase() + category.substring(1)),
            ],
          ),
      ]),

      if (featured != null)
        BlogCard(
          title: (featured['title'] as String?) ?? 'Untitled',
          date: (featured['date'] as String?) ?? '',
          description: (featured['description'] as String?) ?? '',
          href: (featured['href'] as String?) ?? '#',
          image: featured['image'] as String?,
          author: featured['author'] as String?,
          avatar: featured['avatar'] as String?,
          authorUrl: featured['author_url'] as String?,
          isFeatured: true,
        ),

      if (others.isNotEmpty)
        div(classes: 'blog-grid', [
          for (final post in others)
            BlogCard(
              title: (post['title'] as String?) ?? 'Untitled',
              date: (post['date'] as String?) ?? '',
              description: (post['description'] as String?) ?? '',
              href: (post['href'] as String?) ?? '#',
              image: post['image'] as String?,
              author: post['author'] as String?,
              avatar: post['avatar'] as String?,
              authorUrl: post['author_url'] as String?,
            ),
        ])
      else if (filteredPosts.isEmpty)
        div(classes: 'no-posts', [
          text('No posts found in this category.'),
        ]),
    ]);
  }
}
