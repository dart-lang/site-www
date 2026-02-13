import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../models/blog.dart';

class BlogCard extends StatelessComponent {
  const BlogCard({
    required this.post,
    required this.url,
    this.isFeatured = false,
    this.className,
    super.key,
  });

  final Post post;
  final String url;
  final bool isFeatured;
  final String? className;

  @override
  Component build(BuildContext context) {
    final author = context.getAuthor(post.authorId);
    return a(
      href: url,
      classes: 'blog-card ${isFeatured ? 'featured' : ''} ${className ?? ''}',
      attributes: {'data-category': post.category},
      [
        if (post.image != null)
          div(classes: 'blog-card-image', [
            img(src: post.image!, alt: post.title),
          ]),
        div(classes: 'blog-card-content', [
          h3(classes: 'blog-card-title', [
            .text(post.title),
          ]),
          p(classes: 'blog-card-description', [
            .text(post.description),
          ]),
          div(classes: 'blog-card-meta', [
            div(classes: 'blog-card-author-row', [
              if (author.image != null)
                img(
                  classes: 'blog-card-avatar',
                  src: '/images/content/blog/authors/${author.image}',
                  alt: author.name,
                )
              else if (author.github?.avatarUrl case final avatarUrl?)
                img(
                  classes: 'blog-card-avatar',
                  src: avatarUrl,
                  alt: author.name,
                ),
              span(classes: 'author', [
                .text(author.name),
              ]),
              const span(classes: 'separator', [.text(' · ')]),
              span(classes: 'date', [
                .text(post.formattedDate),
              ]),
              const span(classes: 'separator', [.text(' · ')]),
              span(classes: 'reading-time', [
                .text(post.readingTime),
              ]),
            ]),
          ]),
        ]),
      ],
    );
  }
}
