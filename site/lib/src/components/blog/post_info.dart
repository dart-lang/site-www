// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

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
    final twitterUrl = author.twitter != null && author.twitter!.isNotEmpty
        ? 'https://twitter.com/${author.twitter}'
        : null;

    // Fallback to twitter if github is not present
    final linkUrl = githubUrl ?? twitterUrl;

    final authorInfo = div(classes: 'post-info-author', [
      if (author.image != null)
        img(
          src: context.resolveAsset('/blog/authors/${author.image}'),
          alt: author.name,
          width: 32,
          height: 32,
        ),
      h3(classes: 'post-info-name', [Component.text(author.name)]),
    ]);

    return div(classes: 'post-info', [
      div(classes: 'post-info-main', [
        if (linkUrl != null)
          a(href: linkUrl, target: Target.blank, [authorInfo])
        else
          authorInfo,
        span(classes: 'post-info-meta', [
          Component.text('${post.formattedDate} · ${post.readingTime}'),
        ]),
      ]),
      ShareButton(url: url, title: post.title),
    ]);
  }
}
