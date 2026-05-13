// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:dart_dev_site/src/pages/atom_feed.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

final MemoryLoader _loader = MemoryLoader(pages: const []);

void main() {
  test('renders Atom XML for blog posts', () {
    const output = AtomFeedOutput();

    final blogIndex = _page(
      path: 'blog/index.md',
      url: '/blog',
      pageData: {
        'title': 'The Dart Blog',
        'description': 'News and updates.',
      },
      siteData: {'url': 'https://dart.dev/'},
    );
    final pages = [
      blogIndex,
      _page(
        path: 'blog/older/index.md',
        url: '/blog/older',
        pageData: {
          'title': 'Older <Post>',
          'description': 'Use Dart',
          'publishDate': '2026-04-01',
          'updatedDate': '2026-04-03',
          'author': 'author-a',
          'category': 'releases',
        },
        authors: {
          'author-a': {'name': 'Author One'},
        },
      ),
      _page(
        path: 'blog/newer/index.md',
        url: '/blog/newer',
        pageData: {
          'title': 'Dart updates',
          'description': 'More news.',
          'publishDate': '2026-04-10',
          'updatedDate': '2026-04-11',
          'author': 'author-b',
        },
        authors: {
          'author-b': {'name': 'Author Two'},
        },
      ),
      _page(
        path: 'about.md',
        url: '/about',
        pageData: {
          'title': 'Non-blog',
          'publishDate': '2026-04-12',
        },
      ),
      _page(
        path: 'blog/hidden/index.md',
        url: '/blog/hidden',
        pageData: {
          'title': 'Hidden post',
          'publishDate': '2026-04-15',
          'atom': false,
        },
      ),
    ];

    final xml = output.renderAtomFeed(blogIndex, pages);
    final document = XmlDocument.parse(xml);
    final feed = document.rootElement;
    final entries = feed.findElements('entry').toList();

    expect(xml, startsWith('<?xml version="1.0" encoding="utf-8"?>'));
    expect(feed.name.local, 'feed');
    expect(feed.getAttribute('xmlns'), 'http://www.w3.org/2005/Atom');
    expect(feed.getElement('title')?.innerText, 'The Dart Blog');
    expect(
      feed.getElement('subtitle')?.innerText,
      'News and updates.',
    );
    expect(
      _firstLinkWithRel(feed, 'self').getAttribute('href'),
      'https://dart.dev/blog/feed.xml',
    );
    expect(
      _firstLinkWithRel(feed, 'alternate').getAttribute('href'),
      'https://dart.dev/blog',
    );
    expect(feed.getElement('updated')?.innerText, '2026-04-11T00:00:00.000Z');
    expect(entries, hasLength(2));

    final newerEntry = entries[0];
    expect(newerEntry.getElement('title')?.innerText, 'Dart updates');
    expect(
      newerEntry.getElement('updated')?.innerText,
      '2026-04-11T00:00:00.000Z',
    );
    expect(
      newerEntry.getElement('published')?.innerText,
      '2026-04-10T00:00:00.000Z',
    );

    final olderEntry = entries[1];
    expect(olderEntry.getElement('title')?.innerText, 'Older <Post>');
    expect(
      olderEntry.getElement('author')?.getElement('name')?.innerText,
      'Author One',
    );
    expect(
      olderEntry.getElement('updated')?.innerText,
      '2026-04-03T00:00:00.000Z',
    );
    expect(
      olderEntry.getElement('published')?.innerText,
      '2026-04-01T00:00:00.000Z',
    );
    expect(
      olderEntry.getElement('category')?.getAttribute('term'),
      'releases',
    );

    final titles = entries
        .map((entry) => entry.getElement('title')?.innerText)
        .toList();
    expect(titles, isNot(contains('Hidden post')));
    expect(titles, isNot(contains('Non-blog')));
  });

  test('orders same-day posts by URL', () {
    const output = AtomFeedOutput();

    const authors = {
      'dash': {'name': 'dash'},
    };
    final blogIndex = _page(
      path: 'blog/index.md',
      url: '/blog',
      pageData: const {
        'title': 'The Dart Blog',
        'description': 'News and updates.',
      },
      siteData: const {'url': 'https://dart.dev/'},
    );
    final pages = [
      blogIndex,
      _page(
        path: 'blog/b-post/index.md',
        url: '/blog/b-post',
        pageData: const {
          'title': 'B post',
          'description': 'B.',
          'publishDate': '2026-04-01',
          'author': 'dash',
        },
        authors: authors,
      ),
      _page(
        path: 'blog/a-post/index.md',
        url: '/blog/a-post',
        pageData: const {
          'title': 'A post',
          'description': 'A.',
          'publishDate': '2026-04-01',
          'author': 'dash',
        },
        authors: authors,
      ),
    ];

    final document = XmlDocument.parse(output.renderAtomFeed(blogIndex, pages));
    final titles = document.rootElement
        .findElements('entry')
        .map((entry) => entry.getElement('title')?.innerText)
        .toList();

    expect(titles, ['A post', 'B post']);
  });
}

XmlElement _firstLinkWithRel(XmlElement feed, String rel) => feed
    .findElements('link')
    .firstWhere((element) => element.getAttribute('rel') == rel);

Page _page({
  required String path,
  required String url,
  required Map<String, Object?> pageData,
  Map<String, Object?> siteData = const {},
  Map<String, Object?> authors = const {},
}) {
  return Page(
    path: path,
    url: url,
    content: '',
    initialData: {
      'page': pageData,
      'site': siteData,
      if (authors.isNotEmpty) 'authors': authors,
    },
    config: const PageConfig(),
    loader: _loader,
  );
}
