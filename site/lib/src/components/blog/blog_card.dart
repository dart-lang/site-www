import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class BlogCard extends StatelessComponent {
  const BlogCard({
    required this.title,
    required this.date,
    required this.description,
    required this.href,
    this.image,
    this.author,
    this.avatar,
    this.authorUrl,
    this.isFeatured = false,
    super.key,
  });

  final String title;
  final String date;
  final String description;
  final String href;
  final String? image;
  final String? author;
  final String? avatar;
  final String? authorUrl;
  final bool isFeatured;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'blog-card ${isFeatured ? 'featured' : ''}',
      [
        if (image != null)
          div(classes: 'blog-card-image', [
            img(src: image!, alt: title),
          ]),
        div(classes: 'blog-card-content', [
          a(href: href, [
            h3(classes: 'blog-card-title', [text(title)]),
          ]),
          p(classes: 'blog-card-description', [text(description)]),
          div(classes: 'blog-card-meta', [
            if (avatar != null)
              img(
                classes: 'blog-card-avatar',
                src: avatar!,
                alt: author ?? 'Author',
              ),
            div(classes: 'blog-card-author-row', [
              if (authorUrl != null)
                a(
                  href: authorUrl!,
                  target: Target.blank,
                  classes: 'author-link',
                  [text(author ?? 'Unknown')],
                )
              else
                span(classes: 'author', [text(author ?? 'Unknown')]),
              span(classes: 'separator', [text('·')]),
              span(classes: 'date', [text(date)]),
            ]),
          ]),
        ]),
      ],
    );
  }
}
