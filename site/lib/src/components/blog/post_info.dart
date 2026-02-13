import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../models/blog.dart';
import 'client/share_button.dart';

class PostInfo extends StatelessComponent {
  const PostInfo({
    required this.post,
    required this.url,
    super.key,
  });

  final Post post;
  final String url;

  @override
  Component build(BuildContext context) {
    final author = context.getAuthor(post.authorId);
    final githubUrl = author.github?.handle != null
        ? 'https://github.com/${author.github!.handle}'
        : null;
    final twitterUrl = author.twitter != null
        ? 'https://twitter.com/${author.twitter}'
        : null;

    // Fallback to twitter if github is not present
    final linkUrl = githubUrl ?? twitterUrl;

    final authorInfo = div(classes: 'post-info-author', [
      if (author.image != null)
        img(
          src: '/images/content/blog/authors/${author.image}',
          alt: author.name,
          width: 32,
          height: 32,
        ),
      h3(classes: 'post-info-name', [Component.text(author.name)]),
    ]);

    final children = [
      if (linkUrl != null)
        a(href: linkUrl, target: Target.blank, [authorInfo])
      else
        authorInfo,
      span(classes: 'post-info-meta', [
        Component.text(' · ${post.formattedDate}'),
        Component.text(' · ${post.readingTime}'),
      ]),
      ShareButton(url: url, title: post.title),
    ];

    return div(classes: 'post-info', children);
  }
}
