// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../models/blog.dart';

class BlogCard extends StatelessComponent {
  const BlogCard({
    required this.post,
    required this.url,
    this.className,
    super.key,
  });

  final Post post;
  final String url;
  final String? className;

  @override
  Component build(BuildContext context) {
    final author = context.getAuthor(post.authorId);
    return a(
      href: url,
      classes: 'blog-card ${className ?? ''}',
      attributes: {'data-category': post.category ?? 'other'},
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
          const span(classes: 'blog-card-spacer', []),
          div(classes: 'blog-card-meta', [
            div(classes: 'blog-card-author-row', [
              if (author.image != null)
                img(
                  classes: 'blog-card-avatar',
                  src: context.resolveAsset('/blog/authors/${author.image}'),
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
