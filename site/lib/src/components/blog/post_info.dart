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
    final authors = context.page.getAuthors(post.authorIds);

    return div(classes: 'post-info', [
      div(classes: 'post-info-main', [
        _AuthorInfo(authors: authors),
        span(classes: 'post-info-meta', [
          Component.text('${post.formattedDate} · ${post.readingTime}'),
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

class _AuthorInfo extends StatelessComponent {
  const _AuthorInfo({required this.authors});

  final List<Author> authors;

  @override
  Component build(BuildContext context) {
    return div(classes: 'post-info-author', [
      for (final author in authors)
        if (author.image != null)
          img(
            src: context.resolveAsset('/blog/authors/${author.image}'),
            alt: author.name,
            width: 32,
            height: 32,
          ),
      h3(classes: 'post-info-name', [
        for (final author in authors)
          span([
            if (author.linkUrl case final linkUrl?)
              a(href: linkUrl, target: Target.blank, [.text(author.name)])
            else
              .text(author.name),
          ]),
      ]),
    ]);
  }
}
