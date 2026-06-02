// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../models/blog.dart';
import '../../pages/atom_feed.dart';
import '../common/button.dart';
import 'client/share_button.dart';

/// The header with post information to show at the top of a blog post.
///
/// Displays the authors, publish date, and reading time of the [post],
/// alongside actions to subscribe to the blog feed and share the post.
class PostInfo extends StatelessComponent {
  const PostInfo({
    required this.post,
    required this.url,
    super.key,
  });

  /// The post to display information about.
  final Post post;

  /// The URL of the post being shared.
  final String url;

  @override
  Component build(BuildContext context) {
    final authors = context.page.authorsFor(post);

    return div(classes: 'post-info', [
      div(classes: 'post-info-main', [
        div(classes: 'post-info-authors', [
          for (final author in authors) _AuthorInfo(author: author),
        ]),
        span(classes: 'post-info-meta', [
          .text('${post.formattedDate} · ${post.readingTime}'),
        ]),
      ]),
      div(classes: 'post-info-actions', [
        const Button(
          icon: 'rss_feed',
          href: blogAtomFeedPath,
          title: blogAtomSubscribeTitle,
          attributes: {'type': blogAtomMimeType},
        ),
        ShareButton(url: url, title: post.title),
      ]),
    ]);
  }
}

/// A single author's avatar and name within a [PostInfo] byline.
///
/// Links to the author's [Author.profileUrl] when one is available.
class _AuthorInfo extends StatelessComponent {
  const _AuthorInfo({required this.author});

  /// The author to display.
  final Author author;

  @override
  Component build(BuildContext context) {
    final info = div(classes: 'post-info-author', [
      if (author.image case final authorImagePath?)
        img(
          src: context.resolveAsset('/blog/authors/$authorImagePath'),
          alt: author.name,
          width: 32,
          height: 32,
        ),
      h3(
        classes: 'post-info-name',
        attributes: {'translate': 'no'},
        [.text(author.name)],
      ),
    ]);

    if (author.profileUrl case final profileUrl?) {
      return a(
        href: profileUrl,
        classes: 'post-info-author-link',
        target: Target.blank,
        attributes: const {'rel': 'noopener'},
        [info],
      );
    }

    return info;
  }
}
