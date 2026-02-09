import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class AuthorCard extends StatelessComponent {
  const AuthorCard({
    required this.name,
    required this.bio,
    this.image,
    this.twitter,
    this.github,
    super.key,
  });

  final String name;
  final String bio;
  final String? image;
  final String? twitter;
  final Map<String, dynamic>? github;

  @override
  Component build(BuildContext context) {
    return div(classes: 'author-card', [
      if (image != null)
        div(classes: 'author-image', [
          img(
            src: '/images/content/blog/authors/$image',
            alt: name,
            width: 32,
            height: 32,
          ),
        ]),
      div(classes: 'author-content', [
        h3(classes: 'author-name', [.text(name)]),
        p(classes: 'author-bio', [.text(bio)]),
        div(classes: 'author-links', [
          if (twitter != null && twitter!.isNotEmpty)
            a(
              href: 'https://twitter.com/$twitter',
              target: Target.blank,
              classes: 'author-link twitter',
              [
                // Simple text for now or icon if available
                const .text('Twitter'),
              ],
            ),
          if (github != null)
            a(
              href: 'https://github.com/${github!['handle']}',
              target: Target.blank,
              classes: 'author-link github',
              [const .text('GitHub')],
            ),
        ]),
      ]),
    ]);
  }
}
