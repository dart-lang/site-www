---
title: Verified publishers
description: Learn what verified publishers are, and they're verified.
---

The pub.dev verified publisher badge <img src="/assets/img/verified-publisher.svg" alt="pub.dev verified publisher logo"> lets you know that a package
was published by a publisher whose identity has been verified.
For example, [dart.dev]({{site.pub}}/publishers/dart.dev/)
is the verified publisher for packages that are supported by
Google's Dart team.

The badge appears in several places on pub.dev,
next to packages published by verified publishers:

  * Package search results
  * Package detail pages
  * Publisher profile pages
  * The pub.dev front page

Each publisher has a page with a list of
all packages belonging to that publisher,
plus additional details such as the publisher's contact email.
To visit the publisher page, click the publisher identity link
(for example, `dart.dev`) next to the verified publisher badge 
<img 
  src="/assets/img/verified-publisher.svg" 
  alt="pub.dev verified publisher logo">.

## Verification process

To ensure that creating verified publishers is low cost and available to anyone,
pub.dev relies on DNS (domain name system) domains as an identification token.
We chose DNS because we believe that most package publishers
already have a domain and a homepage for that domain.
During the [publisher creation process][publishing page],
pub.dev verifies that the user creating the verified publisher has
admin access to the associated domain, based on existing logic in the
[Google Search Console.][]

## Creating a verified publisher account

If you publish packages and want to create a new verified publisher,
see the instructions on the [publishing page][].

[publishing page]: /tools/pub/publishing#create-verified-publisher
[Google Search Console.]: https://search.google.com/search-console/about
